function temperture_on_line(path,var)
path_fold=[path '\']
file_path=fullfile(path_fold, 'average.mat');
load(file_path)
%%过滤data只有数据
data = var
data(1,:)=[]
%%提取角度信息
angles = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), data(:,1));
%%提取位置信息
axis_poision =cellfun(@(x) str2double(regexp(x, '[\d.]+', 'match')), T(1,2:width(T)));
data(:,1)=[]
data=cell2mat(data)
%%提取计算最远位置
computer_length=axis_poision(1,length(axis_poision))
xi = 0:0.01:computer_length;  % 用于插值的新的x值
legend_names = [];
for i = 1:6:length(angles)
figure(1)
% 进行三次样条插值
yi = interp1(axis_poision, data(i,:), xi, 'pchip');
% 绘制原始数据和插值结果的图形
%plot(axis_poision, data(i,:), '-o', xi, yi, '-');
plot(axis_poision, data(i,:), '-o')
xlabel('轴向距离');
ylabel('温度');
%title(['角度为' num2str(angles(i)) '°的轴向截面']);
%legend('angle=' num2str(angles(i)));
legend_names = [legend_names, {['angle=' num2str(angles(i))] }];
legend('原始数据', '插值结果');
hold on
end
legend(legend_names);
saveas(figure(1), [file_path '截面分布图.png']);
close(figure(1))