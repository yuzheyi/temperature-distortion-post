%%T为输入参数表示高温区最小温度为多少

function result = temperatureAnglePlus(Varible,deltaAngled)
    deltaAngle=deltaAngled%%设置的温度变化间隔
    highAverageTemperature=[]
    for i=1:size(Varible,2)
        VaribleCol=[]
        averageTemperature=mean(Varible(:,i))
        %%拟合角度-温度函数
        angle=-180:deltaAngled:180%x轴
        VaribleCol=[Varible(:,i)' Varible(1,i)];%y轴,因为是-180到180所以要将第一个数字重复一下
        %%样条插值
        xx=-180:0.1:180
        f_varible=spline(angle,VaribleCol,xx)
        xId=xx(find(f_varible > averageTemperature))
        yId=f_varible(find(f_varible > averageTemperature))
        num_x = length(xId);%%查找大于平均值x的个数
        angleResult(i)=0.1*num_x%%使用积分的思想，角度范围大于y值的角度乘变化步长
%         close;
%         figure;
%         plot(xx,f_varible,'l',angle,VaribleCol)
        highAverageTemperature(i) = mean(yId)
        averageTemperatureC(i)=averageTemperature;
        
        
   
    end
    result.angle = angleResult;
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