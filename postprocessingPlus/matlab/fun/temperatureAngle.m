%%T为输入参数表示高温区最小温度为多少

function result = temperatureAngle(Varible,deltaAngled)
    deltaAngle=deltaAngled%%设置的温度变化间隔
    highAverageTemperature=[]
    for i=1:size(Varible,2)
        VaribleCol=[]
        averageTemperature=mean(Varible(:,i))
        VaribleCol=Varible(:,i);
        VaribleCol(VaribleCol < averageTemperature) = 0;
%         VaribleCol(VaribleCol < 400) = 0;
%         Varible(Varible < averageTemperature) = 0;
        non_zero_rows = find(any(VaribleCol ~= 0, 2));
        if isempty(non_zero_rows)
            angle(i) = 0;
            highAverageTemperature(i)=averageTemperature
        else
            %%使用插值进一步增加精度
            %%最大行数
            lowAngle = Varible(max(non_zero_rows)+1,i);
            highAngle= Varible(max(non_zero_rows),i);
            externbAngleMax = abs(averageTemperature-highAngle)/(highAngle-lowAngle)*deltaAngle
            %%最小行数
            lowAngle = Varible(min(non_zero_rows)-1,i);
            highAngle= Varible(min(non_zero_rows),i);
            
            externbAngleMin = abs(averageTemperature-highAngle)/(highAngle-lowAngle)*deltaAngle;    
            externAngle=externbAngleMin + externbAngleMax;%%插值多出来的角度
            if externAngle>2*deltaAngle
                externAngle=0
            end
            angle(i)=(max(non_zero_rows)-min(non_zero_rows))*deltaAngle+externAngle
            VaribleCol=Varible(:,i);
            highAverageTemperature(i) = mean(VaribleCol(min(non_zero_rows):max(non_zero_rows)))
        end
        averageTemperatureC(i)=averageTemperature;
        
        
        
    end
    result.angle = angle;
    result.averageTemperature = averageTemperatureC
    result.highAverageTemperature = highAverageTemperature

end

% % 打开文件
% fileID = fopen('E:\mywork\博士工作\脉冲爆震温度畸变装置\数据\新数据\case2\plane\data','r');
% % 读取文件
% % 读取文件
% data = textscan(fileID, '%s', 'Delimiter', '\n');
% % 关闭文件
% fclose(fileID);
% 
% 
% 
% % 找到 'planexy' 所在行并提取行的数字
% planexy_row = data(strcmp(data{1,1}, 'planexy'), :);
% planexy_values = table2array(planexy_row);