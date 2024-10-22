function jsonEditorUI
    % 创建主界面
    f = figure('Position', [100, 100, 500, 400], 'MenuBar', 'none', 'Name', 'JSON Editor', 'NumberTitle', 'off');

    % 输入框标签和输入框
    uicontrol('Style', 'text', 'Position', [20, 340, 100, 20], 'String', 'Field Path:');
    fieldPathInput = uicontrol('Style', 'edit', 'Position', [120, 340, 350, 20]);

    uicontrol('Style', 'text', 'Position', [20, 310, 100, 20], 'String', 'New Value:');
    newValueInput = uicontrol('Style', 'edit', 'Position', [120, 310, 350, 20]);

    % 按钮
    uicontrol('Style', 'pushbutton', 'Position', [200, 260, 100, 30], 'String', 'Update', ...
              'Callback', @updateJson);

    % 加载 JSON 文件
    jsonFilePath = 'config.json'; % 替换为你的 JSON 文件路径
    jsonData = jsondecode(fileread(jsonFilePath));

    % 更新 JSON 文件
    function updateJson(~, ~)
        fieldPath = get(fieldPathInput, 'String');
        newValue = get(newValueInput, 'String');

        % 使用结构体路径更新值
        try
            % 将字段路径转换为结构体字段
            fieldNames = strsplit(fieldPath, '.');
            currentData = jsonData;
            for k = 1:length(fieldNames)-1
                currentData = currentData.(fieldNames{k});
            end
            
            % 处理不同类型的值
            if isnumeric(currentData)
                newValue = str2double(newValue);
            elseif iscell(currentData)
                newValue = strsplit(newValue, ','); % 允许用逗号分隔多个值
            end
            
            % 更新字段
            jsonData.(fieldNames{end}) = newValue;

            % 保存更新后的 JSON 数据
            fid = fopen(jsonFilePath, 'w');
            if fid == -1
                errordlg('Error opening file for writing.', 'File Error');
                return;
            end
            fprintf(fid, '%s', jsonencode(jsonData, 'PrettyPrint', true));
            fclose(fid);
            msgbox('JSON file updated successfully!', 'Success');
        catch
            errordlg('Invalid field path or value type.', 'Input Error');
        end
    end
end
