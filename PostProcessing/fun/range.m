function results = range(path)
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
    average_temperature = mean(values) 
    
        VaribleCol=[]
        averageTemperature=mean(Varible(:,i))
        %%拟合角度-温度函数
        angle=-180:deltaAngled:180%x轴
        VaribleCol=[Varible(:,i)' Varible(1,i)];%y轴
        %%样条插值
        xx=-180:0.1:180
        f_varible=spline(angle,VaribleCol,xx)
        xId=xx(find(f_varible > averageTemperature))
        yId=f_varible(find(f_varible > averageTemperature))
        num_x = length(xId);%%查找大于平均值x的个数
        angleResult(i)=0.1*num_x%%使用积分的思想，角度范围大于y值的角度乘变化步长
    
    % 寻找大于500的角度
    greaterThan400Angles = angles(values > average_temperature);
    % 通过小于500摄氏度的范围反算出高温
    startIndex = find(values <average_temperature, 1); % 第一个小于400的角度索引
    endIndex = find(values <average_temperature, 1, 'last'); % 最后一个小于400的角度索引
    %通过两个角度的插值进一步增加角度精度（基于简单的两点线性插值）
    angle_start=5-(average_temperature-data{startIndex,i})/(data{(startIndex-1),i}-data{startIndex,i})*5
    angle_end=5-(average_temperature-data{endIndex,i})/(data{(endIndex+1-length(data)*floor((endIndex+0.9)/length(data))),i}-data{endIndex,i})*5
    greaterThan400Range = 360-abs(angles(startIndex)-angles(endIndex));
    %当处于挡板内部时，实际轴向角不需要进行插值，否则会造成角度过大
    %判断如果和之前结果的平均差值为0时，则说明在挡板内部，其变化率总保持0，当挡板消失，平均值必然发生改变因此可认为没有挡板结构
    axis_poisio_judge(i)= greaterThan400Range




    if mean(axis_poisio_judge)-greaterThan400Range ~=0
        axis_poision(2,i)= greaterThan400Range+angle_start+angle_end
    else
        axis_poision(2,i)= greaterThan400Range
    end
    
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
results =axis_poision