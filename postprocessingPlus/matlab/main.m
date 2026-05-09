function main()
    jsonFileName = './config.json';
    % 检查是否存在 template.json 文件
    if isfile(jsonFileName)
        % 读取 JSON 文件内容
        jsonText = fileread(jsonFileName);
        % 解析 JSON 内容
        configData = jsondecode(jsonText);
        % 提示用户选择模式
        % disp('选择运行模式：');
        % disp('1: 运行瞬态后处理 unsteadyPost');
        % disp('2: 运行稳态后处理 multiSteadyPost');
        % disp('3: 运行云图后处理 multiContourPrint');
        % choice = input('请输入模式编号 (1, 2，3): ');
        
        
        %% 构造网格
        meshType= configData.general.meshType(1)
        switch meshType
            case 1
                circleMesh= configData.general.meshType
                createCircleMesh(circleMesh(2),circleMesh(3))
            otherwise
                disp('无效选择，确认网格类型。');
        end
        % 根据用户选择运行相应的脚本
        choice = configData.general.runMode
        switch choice
            case 1
                disp('1: 运行瞬态后处理 unsteadyPost');
                run('unsteadyPost.m');               
            case 2
                % 创建并行池
                parpool(4);
                disp('2: 运行稳态后处理 multiSteadyPost');
                run('multiSteadyPost.m');
                % 结束并行池
                delete(gcp('nocreate'));
            case 3
                disp('3: 运行云图后处理 multiContourPrint');
                run('multiContourPrint.m');
            otherwise
                disp('无效选择，runMode只能为 1, 2 或 3。');
        end
    else
        % 如果文件不存在，生成模板
        generate_config()
    end
    % close all;
end