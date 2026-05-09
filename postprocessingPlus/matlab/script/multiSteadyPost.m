% 访问 JSON 数据
root_path = configData.multiSteadyPost.root_path  
cases = configData.multiSteadyPost.cases;
limits = configData.multiSteadyPost.limits;
% 初始化存储 angle 和 highAverageTemperature 的 cell 数组
angleData = [];
highTempData = [];
% 创建并行池
%parpool(4);
index = 1;
for ii = 1:length(cases)
%% 
    for j = 1:length(limits)
        
        path = [root_path '\' cases{ii} '\' limits{j}];
        % run('steadyPost.m');
        run('steadyPostParallel.m');
        delete(h);
        close(2);
        angleData(:,index+1) = angleRange.angle';
        highTempData(:,index+1) = angleRange.highAverageTemperature';
        hotPointTempeartureData(:,index+1) = averageData.hot_point_tempearture';
        index = index + 1;
    end
end
% 设置angleData、highTempData、hotPointTempeartureData的第一列为轴向位置的值
angleData(:,1) = averageData.axis_poision';
highTempData(:,1) = averageData.axis_poision';
hotPointTempeartureData(:,1) = averageData.axis_poision';
% 结束并行池
%delete(gcp('nocreate'));
% 创建表头
colNames = cell(1, length(cases) * length(limits)+1);
index = 1;
colNames{1} = ['axis_position']
for i = 1:length(cases)
    for j = 1:length(limits)
        colNames{index+1} = [cases{i} '\' limits{j}];
        index = index + 1;
    end
end

% 将 cell 数组转换为表格，并设置表头
angleTable = array2table(angleData, 'VariableNames', colNames);
highTempTable = array2table(highTempData, 'VariableNames', colNames);
hotPointTempTable = array2table(hotPointTempeartureData, 'VariableNames', colNames);

writetable(angleTable, [root_path '\angleTable.csv']);
writetable(highTempTable,[root_path '\highTempTable.csv']);
writetable(hotPointTempTable,[root_path '\hotPointTempTable.csv']);

