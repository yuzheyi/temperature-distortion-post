% 访问 JSON 内容
selected_folder = configData.unsteadyPost.root_path;
path = [selected_folder filesep];
deltaAngled=5
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
    colMax=max(find(any(time.Var1 < 500, 2)))
    time=time.Var1((find(any(time.Var1 < 500, 2))))
    planeData.time=time
    

    %% 查找文件夹下所有的截面文件
    filePlaneDataFold = [path 'planeData' filesep]
    % 获取所有文件
    files = dir(fullfile(filePlaneDataFold, 'planexy*'));
    % 去掉 'planxy' 并显示结果
    name = {files.name}
    filePathAll = fullfile({files.folder}, {files.name});%文件路径
    fileNum = length(filePathAll)%文件数量
    if fileNum == length(time)
        disp("开始解析文件")
    else
        error("时间与截面数量不匹配")
    end
    %% 从小到大进行排序
    % 提取数字部分并进行排序
    numbers = zeros(size(filePathAll));
    for i = 1:length(filePathAll)
        % 使用正则表达式提取数字
        numbers(i) = str2double(regexprep(filePathAll{i}, '.*planexy(\d+)', '$1'));
    end
    
    % 对数字进行排序并获取排序索引
    [~, sortedIndices] = sort(numbers);
    
    % 根据排序索引重新排列文件路径
    sortedFilePaths = filePathAll(sortedIndices);

    %% 数据计算
    for i = 1:length(time)
        %读取数据
        filePath=sortedFilePaths{1, i}
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

% 创建表格，将多个数据列合并
dataTable = table(...
                    planeData.time, ...
                    angleRange.angle', ...
                    angleRange.averageTemperature', ...
                    angleRange.highAverageTemperature', ...
                    'VariableNames', {'Time','Angle', 'AverageTemperature', 'HighAverageTemperature'});
% 写入 CSV 文件
writetable(dataTable, [savePath 'combinedData.csv']);

%% 输出图像
time = planeData.time;
result = angleRange
distort=(abs(result.averageTemperature-result.highAverageTemperature)./result.averageTemperature)%%温度周向不均匀度

figure(1)
titleName=['高温区周向角']
plot(time,result.angle)
title(titleName);
saveas( 1,[savePath '高温区周向角.jpg']);

figure(2)
result.angle(find(distort<0.19))=0
titleName=['周向不均匀度大于20%的高温区周向角']
plot(time,result.angle)
title(titleName);
saveas( 2,[savePath '周向不均匀度大于20%的高温区周向角.jpg']);

writematrix(result.angle, [savePath 'angleRangeFilter.csv']);

figure(3)
plot(time,result.averageTemperature)
integral_value = trapz(time, result.averageTemperature);
average_value(3) = integral_value / (max(time) - min(time));
titleName=['average temperature is ' num2str(average_value(3))]
title(titleName);
integral_value = trapz(time, result.averageTemperature);
average_value(3) = integral_value / (max(time) - min(time));
saveas( 3,[savePath '面平均温度.jpg']);

figure(4)
plot(time,result.highAverageTemperature)
integral_value = trapz(time, result.highAverageTemperature);
average_value(4) = integral_value / (max(time) - min(time));
titleName =['high average temperature is ' num2str(average_value(4))]
title(titleName);
saveas( 4, [savePath '高温区平均温度.jpg']);

figure(5)
plot(time,distort)
titleName =['周向不均匀度']
title(titleName);
saveas( 5, [savePath '周向不均匀度.jpg']);




% 假设阶段1的任务完成后，您想要更改提示文字
newMsg = '完成';
% 查找提示对话框的文本对象
txtHandle = findobj(h, 'Type', 'text');
% 设置文本对象的字符串为新的提示文字
set(txtHandle, 'String', newMsg);
drawnow;
uiwait(h);
delete(h);
