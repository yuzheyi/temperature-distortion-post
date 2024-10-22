% 访问 JSON 内容
selected_folder = configData.unsteadyPost.root_path;
path = [selected_folder filesep];
%% 读取plane的数据
msg = ['读取' path '的数据...'];
h = msgbox(msg, '提示');
if exist([path 'planeData.mat'], 'file')
    load([path 'planeData.mat'],'planeData');
else
    extractCustomTimeData(path) 
    time=readtable([path 'time.csv'])
%     colMax=max(find(any(time.x < 0.05, 2)))
%     time=time.x((find(any(time.x < 0.05, 2))))
    colMax=max(find(any(time.x < 5, 2)))
    time=time.x((find(any(time.x < 5, 2))))
    planeData.time=time
    for i = 1:colMax
        %读取数据
        count=10+(i-1)*10
        filePath=[path 'planexy' num2str(count)]
        data = readtable(filePath);
        planeData.xposition(:,i)=data.x_coordinate
        planeData.yposition(:,i)=data.y_coordinate
        planeData.pressure(:,i)=data.pressure
%         planeData.temperature(:,i)=data.temperature
        planeData.temperature(:,i)=data.total_temperature%增加修改统计温升为总压
        judge.x(i)=sum(planeData.xposition(:,i)-mean(planeData.xposition,2))
        judge.y(i)=sum(planeData.yposition(:,i)-mean(planeData.yposition,2))
    end
    save([path 'planeData.mat'],'planeData');
end


deltaAngled=5
pause(1);
%% 绘制网格插值平均
% 假设阶段1的任务完成后，您想要更改提示文字
newMsg = '正在计算角度下的平均值...';
% 查找提示对话框的文本对象
txtHandle = findobj(h, 'Type', 'text');
% 设置文本对象的字符串为新的提示文字
set(txtHandle, 'String', newMsg);
drawnow;
if exist([path 'resultaverage.mat'], 'file')
    load([path 'resultaverage.mat']);
else
    %%计算角度下的平均值
    resultaverage = averageAngleVaribleGrid(planeData.xposition,planeData.yposition,planeData.temperature,deltaAngled)
    resultaverage.time=planeData.time;
    save([path 'resultaverage.mat'],'resultaverage');
end

%% 计算温度角度范围
pause(1);
% 假设阶段1的任务完成后，您想要更改提示文字
newMsg = '正在计算温度角度范围...';
% 查找提示对话框的文本对象
txtHandle = findobj(h, 'Type', 'text');
% 设置文本对象的字符串为新的提示文字
set(txtHandle, 'String', newMsg);
drawnow;
if exist([path 'resultAngle.mat'], 'file')
    load([path 'resultAngle.mat']);
else
    angleRange = temperatureAnglePlus(resultaverage.dataAverageVArea,deltaAngled);
    angleRange.time=planeData.time;
    save([path 'resultAngle.mat'] , 'angleRange');
end
%% 计算压力参数
pause(1);
% 假设阶段1的任务完成后，您想要更改提示文字
newMsg = '正在计算计算压力参数...';
% 查找提示对话框的文本对象
txtHandle = findobj(h, 'Type', 'text');
% 设置文本对象的字符串为新的提示文字
set(txtHandle, 'String', newMsg);
if exist([path 'pressureDistortResult.mat'], 'file')
    load([path 'pressureDistortResult.mat']);
else
    pressure_correction = 87000;
    pressureDistortResult = pressureDistort(path,87000,deltaAngled)
    save([path 'pressureDistortResult.mat'] , 'pressureDistortResult');
end
%% 创建csv格式方便其他程序调用
savePath=([path '/csvfile/'])
mkdir(savePath)
writematrix(angleRange.angle, [savePath 'angleRange.csv']);
writematrix(angleRange.averageTemperature,[savePath 'averageTemperature.csv']);
writematrix(angleRange.highAverageTemperature, [savePath 'highAverageTemperature.csv']);
writematrix(planeData.time, [savePath 'time.csv']);
%% 输出图像
time = planeData.time;
result = angleRange
distort=(abs(result.averageTemperature-result.highAverageTemperature)./result.averageTemperature)%%温度周向不均匀度

figure(1)
titleName=['高温区周向角']
plot(time,result.angle)
title(titleName);

figure(2)
result.angle(find(distort<0.19))=0
titleName=['周向不均匀度大于20%的高温区周向角']
plot(time,result.angle)
title(titleName);

writematrix(result.angle, [savePath 'angleRangeFilter.csv']);
figure(3)
plot(time,result.averageTemperature)
integral_value = trapz(time, result.averageTemperature);
average_value(3) = integral_value / (max(time) - min(time));
titleName=['average temperature is ' num2str(average_value(3))]
title(titleName);
integral_value = trapz(time, result.averageTemperature);
average_value(3) = integral_value / (max(time) - min(time));

figure(4)
plot(time,result.highAverageTemperature)
integral_value = trapz(time, result.highAverageTemperature);
average_value(4) = integral_value / (max(time) - min(time));
titleName =['high average temperature is ' num2str(average_value(4))]
title(titleName);

figure(5)
plot(time,distort)
titleName =['周向不均匀度']
title(titleName);


% 假设阶段1的任务完成后，您想要更改提示文字
newMsg = '完成';
% 查找提示对话框的文本对象
txtHandle = findobj(h, 'Type', 'text');
% 设置文本对象的字符串为新的提示文字
set(txtHandle, 'String', newMsg);
drawnow;
uiwait(h);
delete(h);
