% 访问 JSON 数据
root_path = configData.multiSteadyPost.root_path  
cases = configData.multiSteadyPost.cases;
limits = configData.multiSteadyPost.limits;
% 初始化存储 angle 和 highAverageTemperature 的 cell 数组
angleData = [];
highTempData = [];

index = 1;
for ii = 1:length(cases)
    for j = 1:length(limits)
        close all;
        path = [root_path '\' cases{ii} '\' limits{j}];
        run('steadyPost.m');
        delete(h);
        angleData(:,index) = angleRange.angle';
        highTempData(:,index) = angleRange.highAverageTemperature';
        index = index + 1;
    end
end

% 创建表头
colNames = cell(1, length(cases) * length(limits));
index = 1;
for i = 1:length(cases)
    for j = 1:length(limits)
        colNames{index} = [cases{i} '\' limits{j}];
        index = index + 1;
    end
end

% 将 cell 数组转换为表格，并设置表头
angleTable = array2table(angleData, 'VariableNames', colNames);
highTempTable = array2table(highTempData, 'VariableNames', colNames);


writetable(angleTable, [root_path '\angleTable.csv']);
writetable(highTempTable,[root_path '\highTempTable.csv']);


