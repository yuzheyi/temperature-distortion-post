path_fold=[path '\']
file_path=fullfile('E:\mywork\博士工作\脉冲爆震温度畸变装置\数据\result-case1-900\', 'average.mat');
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
% 寻找大于500的角度
greaterThan400Angles = angles(values > average_temperature);

% 通过小于500摄氏度的范围反算出高温
startIndex = find(values <average_temperature, 1); % 第一个大于400的角度索引
endIndex = find(values <average_temperature, 1, 'last'); % 最后一个大于400的角度索引
%通过插值进一步
greaterThan400Range = 360-abs(angles(startIndex)-angles(endIndex));
axis_poision(2,i)= greaterThan400Range
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