clear all
%% 选取文件路径
%使用 uigetdir 函数弹出对话框，让用户选择文件夹
selected_folder = uigetdir();
%检查用户是否点击了取消按钮
if selected_folder == 0
    disp('用户取消了选择文件夹。');
else
    % 如果用户选择了文件夹，则输出所选文件夹路径
    disp(['用户选择的文件夹路径为：' selected_folder]);
    % 在这里可以继续对所选文件夹进行其他操作
    % ...
    path = ([selected_folder '\'])
end

%% 读取plane的数据
if exist([path 'planeData.mat'], 'file')
    load([path 'planeData.mat'],'planeData');
else
    time=readtable([path 'time.csv'])
    colMax=max(find(any(time.x < 0.05, 2)))
    time=time.x((find(any(time.x < 0.05, 2))))
    planeData.time=time
    for i = 1:colMax
        %读取数据
        count=100+(i-1)*50
        filePath=[path 'planexy' num2str(count)]
        data = readtable(filePath);
        planeData.xposition(:,i)=data.x_coordinate
        planeData.yposition(:,i)=data.y_coordinate
        planeData.pressure(:,i)=data.pressure
        planeData.temperature(:,i)=data.temperature
        judge.x(i)=sum(planeData.xposition(:,i)-mean(planeData.xposition,2))
        judge.y(i)=sum(planeData.yposition(:,i)-mean(planeData.yposition,2))
    end
    save([path 'planeData.mat'],'planeData');
end


deltaAngled=5

%% 绘制网格插值平均
if exist([path 'resultaverage.mat'], 'file')
    load([path 'resultaverage.mat']);
else
    %%计算角度下的平均值
    resultaverage = averageAngleVaribleGrid(planeData.xposition,planeData.yposition,planeData.temperature,deltaAngled)
    resultaverage.time=planeData.time;
    save([path 'resultaverage.mat'],'resultaverage');
end

%% 计算角度范围
if exist([path 'resultAngle.mat'], 'file')
    load([path 'resultAngle.mat']);
else
    angleRange = temperatureAnglePlus(resultaverage.dataAverageVArea,deltaAngled);
    angleRange.time=planeData.time;
    save([path 'resultAngle.mat'] , 'angleRange');
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


