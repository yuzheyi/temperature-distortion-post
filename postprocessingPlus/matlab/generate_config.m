function generate_config()
    % 定义模板数据

    %% 稳态后处理参数
    config.multiSteadyPost.root_path = 'E:\Desktop\RDC\caseRDC27\result';
    config.multiSteadyPost.cases = {'steady1', 'steady11', 'steady2', 'steady3', 'steady4', 'steady5'};
    config.multiSteadyPost.limits = {'min', 'mid1', 'max'};    

    %% 瞬态后处理参数
    config.unsteadyPost.root_path = 'E:\Desktop\RDC\caseRDC27\result';

    %% 输出云图参数
    %%%文件路径
    config.multiContourPrint.root_path = {
    "E:\Desktop\RDC\caseRDC19\result\steady1\max\planexy1.2",
    "E:\Desktop\RDC\caseRDC19\result\steady1\mid1\planexy1.2",
    "E:\Desktop\RDC\caseRDC19\result\steady11\max\planexy1.2",
    "E:\Desktop\RDC\caseRDC19\result\steady3\max\planexy1.2",
    "E:\Desktop\RDC\caseRDC19\result\steady5\min\planexy1.2"
};
    %%%云图名称
    config.multiContourPrint.titles = {
    '工况3',
    '工况2',
    '工况6',
    '工况12',
    '工况16',
};



    %%
    % 将模板数据转换为 JSON 字符串
    jsonStr = jsonencode(config);

    % 增加换行符和缩进
    jsonStrPretty = format_json(jsonStr);
    
    % 将 JSON 字符串写入文件
    fid = fopen('config.json', 'w');
    if fid == -1
        error('无法创建 JSON 文件');
    end
    fwrite(fid, jsonStrPretty, 'char');
    fclose(fid);
    
    disp('模板已生成并保存到 "config.json" 文件中');
end

function prettyJson = format_json(jsonStr)
    % 使用 jsondecode 和 jsonencode 处理缩进
    jsonData = jsondecode(jsonStr);
    prettyJson = jsonencode(jsonData, 'PrettyPrint', true);
end
