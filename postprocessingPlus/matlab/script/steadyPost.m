%% 读取plane的数据
path=[path filesep]
% path='E:\Desktop\RDC\caseRDC27\result\steady1\min\'
deltaAngled=5
pressure_correction = 87000;
msg = ['读取' path '的数据...'];
h = msgbox(msg, '提示');
pause(1);
if exist([path 'averageData.mat'], 'file')
    load([path 'averageData.mat'],'averageData');
else
    %% 查找文件夹下所有的截面文件
    % 获取所有文件
    files = dir(fullfile(path, 'planexy*'));
    % 去掉 'planxy' 并显示结果
    name = {files.name}
    filePathAll = fullfile({files.folder}, {files.name});%文件路径
    fileNum = length(filePathAll)%文件数量
    %%
    for i = 1:fileNum
        %%%读取数据
        filePath= filePathAll{1, i}
        data = readtable(filePath, 'FileType', 'text');
        % planeData.xposition=data.x_coordinate
        % planeData.yposition=data.y_coordinate
        % planeData.zposition=data.z_coordinate 
        %% 增加判断，获取xyz坐标，并判断哪一个平面为横截面,通过比较方差
        coordinate = [data.x_coordinate,data.y_coordinate,data.z_coordinate]
        V_coordinate = var(coordinate,0,1)
        [V_dim,cowMin]=min(V_coordinate)%由于方差最小为轴向距离
        axiaPosition = mean(coordinate(:,cowMin))%由于方差最小为轴向距离
        coordinate(:,cowMin)=[]%去除轴向保留截面坐标
        planeData.xposition = coordinate(:,1)
        planeData.yposition = coordinate(:,2)

        %%
        planeData.pressure=data.pressure
        planeData.temperature=data.total_temperature
        %   过滤点
        % 计算坐标平方和
        xy_square_sum = planeData.xposition.^2 + planeData.yposition.^2;       
        % 根据坐标平方和筛选数据
        filtered_indices = xy_square_sum <= 0.375^2;
        planeData.xposition = planeData.xposition(filtered_indices);
        planeData.yposition = planeData.yposition(filtered_indices);
        planeData.temperature = planeData.temperature(filtered_indices);
        planeData.pressure = planeData.pressure(filtered_indices) + pressure_correction;

        T = averageAngleVaribleGrid(planeData.xposition,planeData.yposition,planeData.temperature,deltaAngled)
        averageData.temperature(:,i) = T.dataAverageVArea
        P = averageAngleVaribleGrid(planeData.xposition,planeData.yposition,planeData.pressure,deltaAngled)
        averageData.pressure(:,i) = P.dataAverageVArea
        averageData.axis_poision(i) = axiaPosition

        % 计算热点温度
        hot_point_tempearture(i) = max(planeData.temperature)

    end
    save([path 'planeDataTime.mat'],'planeData');
    averageData.angle = P.angle  
    save([path 'averageData.mat'],'averageData');
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
pause(1);
if exist([path 'resultAngle.mat'], 'file')
    load([path 'resultAngle.mat']);
else
    angleRange = temperatureAnglePlus(averageData.temperature,deltaAngled);
    save([path 'resultAngle.mat'] , 'angleRange');
end
file_path= path
plot_varible_on_line(averageData.temperature,averageData.axis_poision,averageData.angle)
plot_varible_on_line(averageData.pressure,averageData.axis_poision,averageData.angle)
% %% 计算压力参数
% pause(1);
% % 假设阶段1的任务完成后，您想要更改提示文字
% newMsg = '正在计算计算压力参数...';
% % 查找提示对话框的文本对象
% txtHandle = findobj(h, 'Type', 'text');
% % 设置文本对象的字符串为新的提示文字
% set(txtHandle, 'String', newMsg);
% if exist([path 'pressureDistortResult.mat'], 'file')
%     load([path 'pressureDistortResult.mat']);
% else
%     pressure_correction = 87000;
%     pressureDistortResult = pressureDistort(path,87000,deltaAngled)
%     save([path 'pressureDistortResult.mat'] , 'pressureDistortResult');
% end
% %% 创建csv格式方便其他程序调用
% savePath=([path '/csvfile/'])
% myTable.angle = angleRange.angle'
% myTable.highAverageTemperature = angleRange.highAverageTemperature'
% 
% 
% writetable(T, [savePath 'data.csv'], 'WriteVariableNames', true);
% % mkdir(savePath)
% % writematrix(angleRange.angle, [savePath 'angleRange.csv']);
% % writematrix(angleRange.averageTemperature,[savePath 'averageTemperature.csv']);
% % writematrix(angleRange.highAverageTemperature, [savePath 'highAverageTemperature.csv']);
% % writematrix(planeData.time, [savePath 'time.csv']);
% %% 输出图像
% time = planeData.time;
% result = angleRange
% distort=(abs(result.averageTemperature-result.highAverageTemperature)./result.averageTemperature)%%温度周向不均匀度
% 
% figure(1)
% titleName=['高温区周向角']
% plot(time,result.angle)
% title(titleName);
% 
% figure(2)
% result.angle(find(distort<0.19))=0
% titleName=['周向不均匀度大于20%的高温区周向角']
% plot(time,result.angle)
% title(titleName);
% 
% writematrix(result.angle, [savePath 'angleRangeFilter.csv']);
% figure(3)
% plot(time,result.averageTemperature)
% integral_value = trapz(time, result.averageTemperature);
% average_value(3) = integral_value / (max(time) - min(time));
% titleName=['average temperature is ' num2str(average_value(3))]
% title(titleName);
% integral_value = trapz(time, result.averageTemperature);
% average_value(3) = integral_value / (max(time) - min(time));
% 
% figure(4)
% plot(time,result.highAverageTemperature)
% integral_value = trapz(time, result.highAverageTemperature);
% average_value(4) = integral_value / (max(time) - min(time));
% titleName =['high average temperature is ' num2str(average_value(4))]
% title(titleName);
% 
% figure(5)
% plot(time,distort)
% titleName =['周向不均匀度']
% title(titleName);
% 
% 
% % 假设阶段1的任务完成后，您想要更改提示文字
% newMsg = '完成';
% % 查找提示对话框的文本对象
% txtHandle = findobj(h, 'Type', 'text');
% % 设置文本对象的字符串为新的提示文字
% set(txtHandle, 'String', newMsg);
% drawnow;
% uiwait(h);
% delete(h);
