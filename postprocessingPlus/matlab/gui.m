% main_gui.m
% MATLAB GUI 后处理程序

function main_gui()
    % 创建主窗口
    fig = figure('Name', 'CFD后处理系统', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 600, 450], ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Resize', 'off');
    
    % 设置颜色
    bg_color = [0.94 0.94 0.94];
    set(fig, 'Color', bg_color);
    
    % 添加标题
    uicontrol('Style', 'text', ...
              'String', 'CFD后处理系统', ...
              'Position', [150, 400, 300, 30], ...
              'FontSize', 18, ...
              'FontWeight', 'bold', ...
              'BackgroundColor', bg_color);
    
    % 配置文件信息显示
    config_info = uicontrol('Style', 'text', ...
                           'String', '配置文件: ./config.json', ...
                           'Position', [50, 350, 300, 25], ...
                           'HorizontalAlignment', 'left', ...
                           'FontSize', 10, ...
                           'BackgroundColor', bg_color);
    
    % 状态显示
    status_text = uicontrol('Style', 'text', ...
                           'String', '就绪', ...
                           'Position', [50, 320, 300, 25], ...
                           'HorizontalAlignment', 'left', ...
                           'FontSize', 10, ...
                           'BackgroundColor', bg_color);
    
    % 模式选择按钮组
    bg_mode = uibuttongroup('Title', '选择运行模式', ...
                           'Position', [0.05, 0.55, 0.9, 0.3], ...
                           'BackgroundColor', bg_color);
    
    % 单选按钮
    rb1 = uicontrol(bg_mode, 'Style', 'radiobutton', ...
                    'String', '1: 瞬态后处理 (unsteadyPost)', ...
                    'Position', [20, 80, 300, 25], ...
                    'FontSize', 11);
    
    rb2 = uicontrol(bg_mode, 'Style', 'radiobutton', ...
                    'String', '2: 稳态后处理 (multiSteadyPost)', ...
                    'Position', [20, 50, 300, 25], ...
                    'FontSize', 11);
    
    rb3 = uicontrol(bg_mode, 'Style', 'radiobutton', ...
                    'String', '3: 云图后处理 (multiContourPrint)', ...
                    'Position', [20, 20, 300, 25], ...
                    'FontSize', 11);
    
    % 配置文件操作按钮
    uicontrol('Style', 'pushbutton', ...
              'String', '加载配置文件', ...
              'Position', [50, 240, 120, 30], ...
              'FontSize', 11, ...
              'Callback', @load_config);
    
    uicontrol('Style', 'pushbutton', ...
              'String', '生成模板配置', ...
              'Position', [200, 240, 120, 30], ...
              'FontSize', 11, ...
              'Callback', @generate_template);
    
    uicontrol('Style', 'pushbutton', ...
              'String', '编辑配置文件', ...
              'Position', [350, 240, 120, 30], ...
              'FontSize', 11, ...
              'Callback', @edit_config);
    
    % 运行按钮
    run_btn = uicontrol('Style', 'pushbutton', ...
                       'String', '开始运行', ...
                       'Position', [150, 180, 120, 40], ...
                       'FontSize', 12, ...
                       'FontWeight', 'bold', ...
                       'BackgroundColor', [0.3 0.7 0.3], ...
                       'Callback', @run_processing);
    
    % 日志文本框
    log_label = uicontrol('Style', 'text', ...
                         'String', '运行日志:', ...
                         'Position', [50, 140, 100, 25], ...
                         'HorizontalAlignment', 'left', ...
                         'BackgroundColor', bg_color);
    
    log_text = uicontrol('Style', 'edit', ...
                        'String', '', ...
                        'Position', [50, 50, 500, 90], ...
                        'Max', 10, ...
                        'Min', 0, ...
                        'HorizontalAlignment', 'left', ...
                        'Enable', 'inactive', ...
                        'BackgroundColor', [1 1 1]);
    
    % 进度条
    progress_bar = uicontrol('Style', 'text', ...
                            'String', '', ...
                            'Position', [50, 40, 500, 8], ...
                            'BackgroundColor', [0.9 0.9 0.9]);
    
    % 存储GUI句柄
    handles = struct();
    handles.fig = fig;
    handles.status_text = status_text;
    handles.log_text = log_text;
    handles.progress_bar = progress_bar;
    handles.bg_mode = bg_mode;
    handles.rb1 = rb1;
    handles.rb2 = rb2;
    handles.rb3 = rb3;
    
    guidata(fig, handles);
    
    % 初始化加载配置文件
    load_config();
    
    % 回调函数
    function load_config(~, ~)
        handles = guidata(fig);
        jsonFileName = './config.json';
        
        if isfile(jsonFileName)
            try
                jsonText = fileread(jsonFileName);
                configData = jsondecode(jsonText);
                runMode = configData.runMode;
                
                % 更新单选按钮选择
                switch runMode
                    case 1
                        set(handles.bg_mode, 'SelectedObject', handles.rb1);
                    case 2
                        set(handles.bg_mode, 'SelectedObject', handles.rb2);
                    case 3
                        set(handles.bg_mode, 'SelectedObject', handles.rb3);
                end
                
                % 更新状态
                set(handles.status_text, 'String', sprintf('配置文件已加载 - 模式 %d', runMode));
                log_message(handles, '配置文件加载成功。');
                
            catch ME
                set(handles.status_text, 'String', '配置文件解析错误');
                log_message(handles, sprintf('错误: %s', ME.message));
            end
        else
            set(handles.status_text, 'String', '配置文件不存在');
            log_message(handles, '配置文件不存在，请生成模板。');
        end
    end
    
    function generate_template(~, ~)
        handles = guidata(fig);
        
        % 调用你的generate_config函数
        try
            generate_config();
            log_message(handles, '已生成模板配置文件。');
            set(handles.status_text, 'String', '模板已生成，请编辑后重新加载');
        catch ME
            log_message(handles, sprintf('生成模板失败: %s', ME.message));
        end
    end
    
    function edit_config(~, ~)
        handles = guidata(fig);
        jsonFileName = './config.json';
        
        if isfile(jsonFileName)
            try
                edit(jsonFileName);
                log_message(handles, '已在编辑器中打开配置文件。');
            catch
                winopen(jsonFileName); % Windows系统
                log_message(handles, '已打开配置文件。');
            end
        else
            log_message(handles, '配置文件不存在，请先生成模板。');
        end
    end
    
    function run_processing(~, ~)
        handles = guidata(fig);
        
        % 获取选择的模式
        selected_obj = get(handles.bg_mode, 'SelectedObject');
        
        if selected_obj == handles.rb1
            choice = 1;
        elseif selected_obj == handles.rb2
            choice = 2;
        elseif selected_obj == handles.rb3
            choice = 3;
        else
            log_message(handles, '错误: 请选择一个运行模式');
            return;
        end
        
        % 更新状态
        set(handles.status_text, 'String', sprintf('正在运行模式 %d...', choice));
        
        % 禁用运行按钮
        set(run_btn, 'Enable', 'off');
        
        % 开始运行
        try
            log_message(handles, '开始运行...');
            
            % 更新配置文件中的运行模式
            jsonFileName = './config.json';
            if isfile(jsonFileName)
                jsonText = fileread(jsonFileName);
                configData = jsondecode(jsonText);
                configData.runMode = choice;
                
                % 保存更新后的配置文件
                jsonText = jsonencode(configData, 'PrettyPrint', true);
                fid = fopen(jsonFileName, 'w');
                fprintf(fid, '%s', jsonText);
                fclose(fid);
                % 将configData保存到基础工作区，让脚本可以访问
                assignin('base', 'configData', configData);
            end
            
            % 运行相应的处理程序
            switch choice
                case 1
                    log_message(handles, '运行瞬态后处理...');
                    %evalin('base', 'unsteadyPost;');  % 假设脚本已转为函数
                    % 如果还是脚本，用这个：
                    evalin('base', 'run(''unsteadyPost.m'');');
            
                case 2
                    log_message(handles, '运行稳态后处理...');
                    %evalin('base', 'multiSteadyPost;');
                    evalin('base', 'run(''multiSteadyPost.m'');');
                case 3
                    log_message(handles, '运行云图后处理...');
                    %evalin('base', 'multiContourPrint;');
                    evalin('base', 'run(''multiContourPrint.m'');');
            end
            
            log_message(handles, '处理完成！');
            set(handles.status_text, 'String', '处理完成');
            
        catch ME
            log_message(handles, sprintf('运行出错: %s', ME.message));
            set(handles.status_text, 'String', '运行出错');
        end
        
        % 启用运行按钮
        set(run_btn, 'Enable', 'on');
    end
    
    function log_message(handles, message)
        current_time = datestr(now, 'HH:MM:SS');
        current_text = get(handles.log_text, 'String');
        
        if iscell(current_text)
            new_text = [{sprintf('[%s] %s', current_time, message)}; current_text];
        else
            new_text = {sprintf('[%s] %s', current_time, message)};
        end
        
        % 保持最多20条日志
        if length(new_text) > 20
            new_text = new_text(1:20);
        end
        
        set(handles.log_text, 'String', new_text);
        drawnow;
    end
end

% generate_config.m (如果你还没有的话)
function generate_config()
    % 生成默认的配置文件模板
    configData = struct();
    configData.runMode = 1; % 默认模式
    
    % 稳态后处理配置
    configData.multiSteadyPost = struct();
    configData.multiSteadyPost.root_path = "E:\\Desktop\\RDC\\caseRDC27\\result";
    configData.multiSteadyPost.cases = ["steady1", "steady2", "steady3"];
    configData.multiSteadyPost.limits = ["min", "max"];
    
    % 瞬态后处理配置
    configData.unsteadyPost = struct();
    configData.unsteadyPost.root_path = "E:\\Desktop\\RDC\\caseRDC29\\plane1.35";
    
    % 云图后处理配置
    configData.multiContourPrint = struct();
    configData.multiContourPrint.root_path = ["path1", "path2"];
    configData.multiContourPrint.titles = ["工况1", "工况2"];
    
    % 保存为JSON文件
    jsonText = jsonencode(configData, 'PrettyPrint', true);
    fid = fopen('./config.json', 'w');
    fprintf(fid, '%s', jsonText);
    fclose(fid);
    
    disp('已生成配置文件模板 config.json');
end