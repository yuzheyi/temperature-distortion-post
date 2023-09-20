function T_divation(path)
path_fold=[path '\']
file_path=fullfile(path_fold, 'average.mat');
load(file_path)
%%过滤data只有数据
data = T
data(1,:)=[]
%%提取角度信息
angles = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), data(:,1));
%%提取位置信息
axis_poision =cellfun(@(x) str2double(regexp(x, '[\d.]+', 'match')), T(1,2:width(T)));
data(:,1)=[]
data=cell2mat(data)
%%提取计算最远位置
computer_length=axis_poision(1,length(axis_poision))
for i=1:1:width(data)
    data_in_position=data(:, i)
    T_average(i)=mean(data(:, i))
    data_high_temperature=data_in_position(data_in_position>T_average(i))
    T_theta_average(i) = mean(data_high_temperature)
    T_no_unit(i)=(T_theta_average(i)-T_average(i))/T_average(i)
end

xi = 0:0.01:computer_length;  % 用于插值的新的x值

for i = 1
figure(1)
% 进行三次样条插值
yi = interp1(axis_poision, T_no_unit, xi, 'pchip');
% 绘制原始数据和插值结果的图形
plot(axis_poision, T_no_unit, 'o', xi, yi, '-');
xlabel('轴向距离');
ylabel('温度不均匀度');
yticks = get(gca, 'YTick');  % 获取当前纵坐标刻度值
yticklabels = cellstr(num2str(yticks' * 100, '%g%%'));  % 将刻度值转换为百分号形式
set(gca, 'YTickLabel', yticklabels);  % 设置新的刻度标签

%ytickformat('percentage'); 
%title(['角度为' num2str(angles(i)) '°的轴向截面']);
legend('原始数据', '插值结果');
hold on
end
