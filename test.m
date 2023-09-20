clear all
% data = readtable('E:\mywork\脉冲爆震温度畸变装置\数据\case2\data');
[Rdata, headers] = xlsread('E:\mywork\博士工作\脉冲爆震温度畸变装置\数据\case2\data.xlsx', 2);
integral_result = trapz(Rdata(:,4), Rdata(:,2));
average_temperature=integral_result/(max(Rdata(:,4))-min(Rdata(:,4)))