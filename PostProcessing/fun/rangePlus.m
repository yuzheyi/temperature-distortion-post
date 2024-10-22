function results = rangePlus(path,deltaAngled)
path_fold=[path '\']
file_path=fullfile(path_fold, 'average.mat');
load(file_path)
%%过滤data只有数据
data = T
data(1,:)=[]
%%提取角度信息
angles = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), data(:,1));
data(:,1)=[]
i=1
%%提取位置信息
axis_poision =cellfun(@(x) str2double(regexp(x, '[\d.]+', 'match')), T(1,2:width(T)));
computer_length=axis_poision(1,length(axis_poision))
while i<=length(axis_poision)
    values = cell2mat(data(:, i)); % 提取数值部分
    averageTemperature = mean(values) 
    % 寻找大于500的角度

        VaribleCol=[]
        %%拟合角度-温度函数
        angle=-180:deltaAngled:180%x轴
        VaribleCol=[values' values(1)];%y轴,因为是-180到180所以要将第一个数字重复一下
        %%样条插值
        xx=-180:0.1:180
        f_varible=spline(angle,VaribleCol,xx)
        xId=xx(find(f_varible > averageTemperature))
        yId=f_varible(find(f_varible > averageTemperature))
        num_x = length(xId);%%查找大于平均值x的个数
        axis_poision(2,i)=0.1*num_x%%使用积分的思想，角度范围大于y值的角度乘变化步长
        highAverageTemperature(i) = mean(yId)
        averageTemperatureC(i)=averageTemperature;
    i=i+1
end


xi = 0.1:0.01:computer_length;  % 用于插值的新的x值

% 进行三次样条插值
yi = interp1(axis_poision(1,:), axis_poision(2,:), xi, 'pchip');
figure(1)
% 绘制原始数据和插值结果的图形
plot(axis_poision(1,:), axis_poision(2,:), 'o', xi, yi, '-');
xlabel('轴向距离');
ylabel('周向角度');
legend('原始数据', '插值结果');
saveas(figure(1), [file_path '周角范围.png']);
close(figure(1))


yi = interp1(axis_poision(1,:), highAverageTemperature, xi, 'pchip');
figure(1)
% 绘制原始数据和插值结果的图形
plot(axis_poision(1,:), highAverageTemperature, 'o', xi, yi, '-');
xlabel('轴向距离');
ylabel('高温区温度');
legend('原始数据', '插值结果');
saveas(figure(1), [file_path '高温区温度.png']);
close(figure(1))




results.angle =axis_poision
results.highAverageTemperature = highAverageTemperature
results.averageTemperatureC= averageTemperatureC