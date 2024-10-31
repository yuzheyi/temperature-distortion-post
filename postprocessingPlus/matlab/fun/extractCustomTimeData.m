function extractCustomTimeData(path) 
    % 读取文件内容
    filename = fullfile(path, 'averagedata');
    fileContent = fileread(filename);
    lines = splitlines(fileContent);
    
    % 定义变量名和列表
    varible_names = {'custom-time'};
    numbers_list = containers.Map;
    
    % 查找包含变量名的行并提取数字
    for i = 1:length(varible_names)
        varible_name = varible_names{i};
        % 找出包含变量名的行
        index = find(contains(lines, varible_name));
        selected_lines = cell(size(index));  % 用于存储选定行的数据
    
        % 遍历 index 矩阵中的每个索引
        for i = 1:numel(index)
            % 检查索引是否超出 lines 的范围
            if index(i) <= numel(lines)
                % 选择 lines 中的对应行，并存储到 selected_lines 中
                selected_lines{i} = lines{index(i)+2};
            else
                % 处理索引超出范围的情况
                warning('Index %d is out of range.', index(i));
                % 或者你可以选择跳过这个索引
                selected_lines{i} = '';  % 或者设为空字符串
            end
        end
        
        % 初始化一个 cell 数组来存储提取的数值
        numbers = cell(size(selected_lines));
        
        % 遍历每一行，提取数值
        for i = 1:length(selected_lines)
            % 按空格分割字符串
            parts = strsplit(strtrim(selected_lines{i}));
            
            % 查找包含数值的部分
            for j = 1:length(parts)
                num = str2double(parts{j});
                if ~isnan(num)
                    numbers{i} = num;
                    break;
                end
            end
        end
    
    % 将 cell 数组转换为数值数组
    numbers = cell2mat(numbers);
    
    end
    
    % 获取变量数据
    
    % % 创建目标目录（如果不存在）
    % output_dir = fullfile(path, 'planedata');
    % if ~exist(output_dir, 'dir')
    %     mkdir(output_dir);
    % end
    
    % 写入 CSV 文件
    output_file = fullfile(path, 'time.csv');
    writematrix(numbers, output_file);
