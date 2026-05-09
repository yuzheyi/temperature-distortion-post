% main_gui.m
% MATLAB GUI 后处理程序 - 宽敞版

function main_gui()
    % 创建主窗口（更大的窗口）
    fig = figure('Name', 'CFD后处理系统', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 800, 650], ... % 更大的窗口
                 'MenuBar', 'none', ...
                 'ToolBar', 'none');
    
    % 设置颜色
    bg_color = [0.94 0.94 0.94];
    set(fig, 'Color', bg_color);
    
    % ========== 标题区域 ==========
    title_panel = uipanel('Parent', fig, ...
                         'Title', '', ...
                         'Position', [0.02, 0.88, 0.96, 0.10], ...
                         'BackgroundColor', bg_color, ...
                         'BorderType', 'none');
    
    uicontrol('Parent', title_panel, ...
              'Style', 'text', ...
              'String', 'CFD后处理系统', ...
              'Position', [200, 10, 400, 40], ...
              'FontSize', 22, ...
              'FontWeight', 'bold', ...
              'ForegroundColor', [0.2 0.2 0.5], ...
              'BackgroundColor', bg_color);
    
    % ========== 配置文件区域 ==========
    config_panel = uipanel('Parent', fig, ...
                          'Title', '配置文件设置', ...
                          'Position', [0.02, 0.70, 0.96, 0.16], ...
                          'FontSize', 11, ...
                          'FontWeight', 'bold', ...
                          'BackgroundColor', bg_color);
    
    % 配置文件路径标签
    uicontrol('Parent', config_panel, ...
              'Style', 'text', ...
              'String', '配置文件路径:', ...
              'Position', [20, 65, 100, 25], ...
              'HorizontalAlignment', 'left', ...
              'FontSize', 10, ...
              'BackgroundColor', bg_color);
    
    % 配置文件路径显示框
    config_path_text = uicontrol('Parent', config_panel, ...
                                'Style', 'edit', ...
                                'String', './config.json', ...
                                'Position', [130, 65, 480, 25], ...
                                'FontSize', 10, ...
                                'HorizontalAlignment', 'left', ...
                                'BackgroundColor', [1 1 1]);
    
    % 浏览按钮
    uicontrol('Parent', config_panel, ...
              'Style', 'pushbutton', ...
              'String', '浏览...', ...
              'Position', [620, 65, 80, 25], ...
              'FontSize', 10, ...
              'Callback', @browse_config);
    
    % 配置文件操作按钮
    btn_y_positions = [25, 25, 25, 25];
    btn_width = 80;
    btn_height = 30;
    btn_spacing = 90;
    
    uicontrol('Parent', config_panel, ...
              'Style', 'pushbutton', ...
              'String', '加载配置', ...
              'Position', [20, btn_y_positions(1), btn_width, btn_height], ...
              'FontSize', 10, ...
              'Callback', @load_config);
    
    uicontrol('Parent', config_panel, ...
              'Style', 'pushbutton', ...
              'String', '生成模板', ...
              'Position', [20+btn_spacing, btn_y_positions(2), btn_width, btn_height], ...
              'FontSize', 10, ...
              'Callback', @generate_template);
    
    uicontrol('Parent', config_panel, ...
              'Style', 'pushbutton', ...
              'String', '编辑配置', ...
              'Position', [20+2*btn_spacing, btn_y_positions(3), btn_width, btn_height], ...
              'FontSize', 10, ...
              'Callback', @edit_config);
    
    uicontrol('Parent', config_panel, ...
              'Style', 'pushbutton', ...
              'String', '查看配置', ...
              'Position', [20+3*btn_spacing, btn_y_positions(4), btn_width, btn_height], ...
              'FontSize', 10, ...
              'Callback', @view_config);
    
    % ========== 模式选择区域 ==========
    mode_panel = uipanel('Parent', fig, ...
                        'Title', '运行模式选择', ...
                        'Position', [0.02, 0.52, 0.48, 0.16], ...
                        'FontSize', 11, ...
                        'FontWeight', 'bold', ...
                        'BackgroundColor', bg_color);
    
    % 模式选择按钮组
    bg_mode = uibuttongroup('Parent', mode_panel, ...
                           'Title', '', ...
                           'Position', [0.05, 0.05, 0.90, 0.90], ...
                           'BackgroundColor', bg_color, ...
                           'BorderType', 'none');
    
    % 单选按钮（垂直排列）
    rb1 = uicontrol(bg_mode, 'Style', 'radiobutton', ...
                    'String', '1: 瞬态后处理 (unsteadyPost)', ...
                    'Position', [20, 80, 250, 25], ...
                    'FontSize', 11);
    
    rb2 = uicontrol(bg_mode, 'Style', 'radiobutton', ...
                    'String', '2: 稳态后处理 (multiSteadyPost)', ...
                    'Position', [20, 50, 250, 25], ...
                    'FontSize', 11);
    
    rb3 = uicontrol(bg_mode, 'Style', 'radiobutton', ...
                    'String', '3: 云图后处理 (multiContourPrint)', ...
                    'Position', [20, 20, 250, 25], ...
                    'FontSize', 11);
    
    % ========== 并行池管理区域 ==========
    parallel_panel = uipanel('Parent', fig, ...
                            'Title', '并行计算设置', ...
                            'Position', [0.52, 0.52, 0.46, 0.16], ...
                            'FontSize', 11, ...
                            'FontWeight', 'bold', ...
                            'BackgroundColor', bg_color);
    
    % 并行池状态显示
    parallel_status_text = uicontrol('Parent', parallel_panel, ...
                                    'Style', 'text', ...
                                    'String', '并行池状态: 未创建', ...
                                    'Position', [20, 65, 250, 25], ...
                                    'HorizontalAlignment', 'left', ...
                                    'FontSize', 10, ...
                                    'BackgroundColor', bg_color);
    
    % 创建并行池按钮
    uicontrol('Parent', parallel_panel, ...
              'Style', 'pushbutton', ...
              'String', '创建并行池', ...
              'Position', [20, 25, 100, 30], ...
              'FontSize', 10, ...
              'Callback', @create_parallel_pool);
    
    % 关闭并行池按钮
    uicontrol('Parent', parallel_panel, ...
              'Style', 'pushbutton', ...
              'String', '关闭并行池', ...
              'Position', [140, 25, 100, 30], ...
              'FontSize', 10, ...
              'Callback', @delete_parallel_pool);
    
    % ========== 状态和运行区域 ==========
    status_panel = uipanel('Parent', fig, ...
                          'Title', '运行状态', ...
                          'Position', [0.02, 0.42, 0.96, 0.08], ...
                          'FontSize', 11, ...
                          'FontWeight', 'bold', ...
                          'BackgroundColor', bg_color);
    
    % 状态显示
    status_text = uicontrol('Parent', status_panel, ...
                           'Style', 'text', ...
                           'String', '系统就绪', ...
                           'Position', [20, 15, 400, 25], ...
                           'HorizontalAlignment', 'left', ...
                           'FontSize', 11, ...
                           'FontWeight', 'bold', ...
                           'ForegroundColor', [0 0.5 0], ...
                           'BackgroundColor', bg_color);
    
    % 运行按钮
    run_btn = uicontrol('Parent', status_panel, ...
                       'Style', 'pushbutton', ...
                       'String', '开始运行', ...
                       'Position', [600, 10, 120, 35], ...
                       'FontSize', 12, ...
                       'FontWeight', 'bold', ...
                       'BackgroundColor', [0.3 0.7 0.3], ...
                       'ForegroundColor', [1 1 1], ...
                       'Callback', @run_processing);
    
    % ========== 日志区域 ==========
    log_panel = uipanel('Parent', fig, ...
                       'Title', '运行日志', ...
                       'Position', [0.02, 0.05, 0.96, 0.35], ...
                       'FontSize', 11, ...
                       'FontWeight', 'bold', ...
                       'BackgroundColor', bg_color);
    
    % 日志清空按钮
    uicontrol('Parent', log_panel, ...
              'Style', 'pushbutton', ...
              'String', '清空日志', ...
              'Position', [650, 210, 80, 30], ...
              'FontSize', 10, ...
              'Callback', @clear_log);
    
    % 日志文本框
    log_text = uicontrol('Parent', log_panel, ...
                        'Style', 'listbox', ...
                        'String', '', ...
                        'Position', [20, 20, 750, 200], ...
                        'FontSize', 9, ...
                        'FontName', 'Consolas', ...
                        'BackgroundColor', [1 1 1]);
    
    % 存储GUI句柄
    handles = struct();
    handles.fig = fig;
    handles.config_path_text = config_path_text;
    handles.status_text = status_text;
    handles.parallel_status_text = parallel_status_text;
    handles.log_text = log_text;
    handles.bg_mode = bg_mode;
    handles.rb1 = rb1;
    handles.rb2 = rb2;
    handles.rb3 = rb3;
    handles.run_btn = run_btn;
    
    guidata(fig, handles);
    
    % 初始化更新并行池状态
    update_parallel_status(handles);
    
    % 初始化加载配置文件
    load_config();
    
    % ========== 回调函数 ==========
    function browse_config(~, ~)
        handles = guidata(fig);
        
        % 获取当前路径作为起始目录
        current_path = get(handles.config_path_text, 'String');
        [pathstr, ~, ~] = fileparts(current_path);
        
        % 打开文件选择对话框
        [filename, pathname] = uigetfile({'*.json', 'JSON配置文件'; '*.*', '所有文件'}, ...
                                         '选择配置文件', ...
                                         pathstr);
        
        if filename ~= 0
            % 用户选择了文件
            full_path = fullfile(pathname, filename);
            set(handles.config_path_text, 'String', full_path);
            log_message(handles, sprintf('已选择配置文件: %s', full_path));
        end
    end
    
    function load_config(~, ~)
        handles = guidata(fig);
        
        % 获取配置文件路径
        jsonFileName = get(handles.config_path_text, 'String');
        
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
                set(handles.status_text, 'ForegroundColor', [0 0.5 0]);
                log_message(handles, sprintf('配置文件加载成功: %s', jsonFileName));
                
            catch ME
                set(handles.status_text, 'String', '配置文件解析错误');
                set(handles.status_text, 'ForegroundColor', [0.8 0 0]);
                log_message(handles, sprintf('错误: %s', ME.message));
            end
        else
            set(handles.status_text, 'String', '配置文件不存在');
            set(handles.status_text, 'ForegroundColor', [0.8 0 0]);
            log_message(handles, sprintf('配置文件不存在: %s', jsonFileName));
        end
    end
    
    function generate_template(~, ~)
        handles = guidata(fig);
        
        try
            % 获取当前路径作为起始目录
            current_path = get(handles.config_path_text, 'String');
            [pathstr, ~, ~] = fileparts(current_path);
            
            % 获取保存路径
            [filename, pathname] = uiputfile({'*.json', 'JSON配置文件'}, ...
                                             '保存模板配置文件', ...
                                             fullfile(pathstr, 'config.json'));
            
            if filename ~= 0
                full_path = fullfile(pathname, filename);
                generate_config_template(full_path);
                
                % 更新配置文件路径显示
                set(handles.config_path_text, 'String', full_path);
                
                log_message(handles, sprintf('已生成模板配置文件: %s', full_path));
                set(handles.status_text, 'String', '模板已生成');
                set(handles.status_text, 'ForegroundColor', [0 0.5 0]);
            end
            
        catch ME
            log_message(handles, sprintf('生成模板失败: %s', ME.message));
        end
    end
    
    function edit_config(~, ~)
        handles = guidata(fig);
        jsonFileName = get(handles.config_path_text, 'String');
        
        if isfile(jsonFileName)
            try
                edit(jsonFileName);
                log_message(handles, '已在编辑器中打开配置文件。');
            catch
                try
                    winopen(jsonFileName);
                    log_message(handles, '已打开配置文件。');
                catch
                    log_message(handles, '无法打开配置文件编辑器。');
                end
            end
        else
            log_message(handles, '配置文件不存在。');
        end
    end
    
    function view_config(~, ~)
        handles = guidata(fig);
        jsonFileName = get(handles.config_path_text, 'String');
        
        if isfile(jsonFileName)
            try
                jsonText = fileread(jsonFileName);
                configData = jsondecode(jsonText);
                
                % 创建信息对话框
                info_fig = figure('Name', '配置信息', ...
                                 'NumberTitle', 'off', ...
                                 'Position', [350, 350, 500, 400], ...
                                 'MenuBar', 'none', ...
                                 'ToolBar', 'none');
                
                % 显示配置信息
                info_text = sprintf('配置文件: %s\n\n', jsonFileName);
                info_text = [info_text, sprintf('运行模式: %d\n\n', configData.runMode)];
                
                if isfield(configData, 'multiSteadyPost')
                    info_text = [info_text, '=== 稳态后处理配置 ===\n'];
                    info_text = [info_text, sprintf('根路径: %s\n', configData.multiSteadyPost.root_path)];
                    info_text = [info_text, sprintf('案例数: %d\n\n', length(configData.multiSteadyPost.cases))];
                end
                
                if isfield(configData, 'unsteadyPost')
                    info_text = [info_text, '=== 瞬态后处理配置 ===\n'];
                    info_text = [info_text, sprintf('根路径: %s\n\n', configData.unsteadyPost.root_path)];
                end
                
                if isfield(configData, 'multiContourPrint')
                    info_text = [info_text, '=== 云图后处理配置 ===\n'];
                    info_text = [info_text, sprintf('路径数: %d\n', length(configData.multiContourPrint.root_path))];
                end
                
                % 创建多行文本框显示信息
                uicontrol(info_fig, 'Style', 'edit', ...
                         'String', sprintf(info_text), ...
                         'Position', [10, 60, 480, 330], ...
                         'Max', 10, ...
                         'HorizontalAlignment', 'left', ...
                         'FontSize', 10, ...
                         'Enable', 'inactive');
                
                % 添加确定按钮
                uicontrol(info_fig, 'Style', 'pushbutton', ...
                         'String', '确定', ...
                         'Position', [220, 20, 60, 30], ...
                         'Callback', 'close(gcf)');
                
                log_message(handles, '已显示配置信息');
                
            catch ME
                log_message(handles, sprintf('查看配置失败: %s', ME.message));
            end
        else
            log_message(handles, '配置文件不存在');
        end
    end
    
    function create_parallel_pool(~, ~)
        handles = guidata(fig);
        
        try
            log_message(handles, '正在创建并行池...');
            
            % 获取可用CPU核心数
            num_cores = feature('numcores');
            
            % 询问用户要创建的工作进程数
            prompt = {sprintf('可用CPU核心数: %d\n请输入要创建的工作进程数:', num_cores)};
            dlgtitle = '创建并行池';
            dims = [1 50];
            definput = {sprintf('%d', min(4, num_cores))};
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            
            if ~isempty(answer)
                num_workers = str2double(answer{1});
                
                if isnan(num_workers) || num_workers < 1 || num_workers > num_cores
                    errordlg(sprintf('请输入1-%d之间的有效数字', num_cores), '输入错误');
                    return;
                end
                
                % 创建并行池
                if isempty(gcp('nocreate'))
                    parpool('local', num_workers);
                    log_message(handles, sprintf('已创建并行池，工作进程数: %d', num_workers));
                else
                    delete(gcp('nocreate'));
                    parpool('local', num_workers);
                    log_message(handles, sprintf('已重新创建并行池，工作进程数: %d', num_workers));
                end
                
                % 更新状态
                update_parallel_status(handles);
                set(handles.status_text, 'String', '并行池已创建');
                set(handles.status_text, 'ForegroundColor', [0 0.5 0]);
                
            end
            
        catch ME
            log_message(handles, sprintf('创建并行池失败: %s', ME.message));
            set(handles.status_text, 'String', '并行池创建失败');
            set(handles.status_text, 'ForegroundColor', [0.8 0 0]);
        end
    end
    
    function delete_parallel_pool(~, ~)
        handles = guidata(fig);
        
        try
            if ~isempty(gcp('nocreate'))
                pool = gcp('nocreate');
                num_workers = pool.NumWorkers;
                
                delete(gcp('nocreate'));
                
                log_message(handles, sprintf('已关闭并行池，释放了 %d 个工作进程', num_workers));
                update_parallel_status(handles);
                set(handles.status_text, 'String', '并行池已关闭');
                set(handles.status_text, 'ForegroundColor', [0 0.5 0]);
            else
                log_message(handles, '没有活动的并行池');
            end
            
        catch ME
            log_message(handles, sprintf('关闭并行池失败: %s', ME.message));
        end
    end
    
    function clear_log(~, ~)
        handles = guidata(fig);
        set(handles.log_text, 'String', '');
        log_message(handles, '日志已清空');
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
            set(handles.status_text, 'String', '请选择运行模式');
            set(handles.status_text, 'ForegroundColor', [0.8 0 0]);
            return;
        end
        
        % 获取配置文件路径
        jsonFileName = get(handles.config_path_text, 'String');
        
        % 检查文件是否存在
        if ~isfile(jsonFileName)
            log_message(handles, sprintf('错误: 配置文件不存在 - %s', jsonFileName));
            set(handles.status_text, 'String', '配置文件不存在');
            set(handles.status_text, 'ForegroundColor', [0.8 0 0]);
            return;
        end
        
        % 更新状态
        set(handles.status_text, 'String', sprintf('正在运行模式 %d...', choice));
        set(handles.status_text, 'ForegroundColor', [0 0 0.8]);
        
        % 禁用运行按钮
        set(handles.run_btn, 'Enable', 'off');
        set(handles.run_btn, 'String', '运行中...');
        set(handles.run_btn, 'BackgroundColor', [0.8 0.8 0.8]);
        
        % 开始运行
        try
            log_message(handles, '开始运行...');
            log_message(handles, sprintf('使用配置文件: %s', jsonFileName));
            
            % 读取并更新配置文件
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
            assignin('base', 'configFilePath', jsonFileName);
            
            log_message(handles, '配置文件已更新并传递到工作区');
            
            % 运行相应的处理程序
            switch choice
                case 1
                    log_message(handles, '运行瞬态后处理...');
                    evalin('base', 'run(''unsteadyPost.m'');');
                    
                case 2
                    log_message(handles, '运行稳态后处理...');
                    evalin('base', 'run(''multiSteadyPost.m'');');
                    
                case 3
                    log_message(handles, '运行云图后处理...');
                    evalin('base', 'run(''multiContourPrint.m'');');
            end
            
            log_message(handles, '处理完成！');
            set(handles.status_text, 'String', '处理完成');
            set(handles.status_text, 'ForegroundColor', [0 0.5 0]);
            
        catch ME
            log_message(handles, sprintf('运行出错: %s', ME.message));
            set(handles.status_text, 'String', '运行出错');
            set(handles.status_text, 'ForegroundColor', [0.8 0 0]);
            
            % 显示详细错误信息
            if ~isempty(ME.stack)
                err_msg = sprintf('错误位置: %s (行 %d)', ...
                                 ME.stack(1).name, ME.stack(1).line);
                log_message(handles, err_msg);
            end
        end
        
        % 启用运行按钮
        set(handles.run_btn, 'Enable', 'on');
        set(handles.run_btn, 'String', '开始运行');
        set(handles.run_btn, 'BackgroundColor', [0.3 0.7 0.3]);
    end
    
    function log_message(handles, message)
        current_time = datestr(now, 'HH:MM:SS');
        formatted_message = sprintf('[%s] %s', current_time, message);
        
        % 获取当前日志
        current_log = get(handles.log_text, 'String');
        
        if isempty(current_log)
            current_log = {formatted_message};
        elseif ischar(current_log)
            current_log = {current_log; formatted_message};
        else
            current_log = [current_log; formatted_message];
        end
        
        % 保持最多100条日志
        if length(current_log) > 100
            current_log = current_log(end-99:end);
        end
        
        set(handles.log_text, 'String', current_log);
        set(handles.log_text, 'Value', length(current_log)); % 滚动到最后
        
        % 强制刷新显示
        drawnow;
    end
    
    function update_parallel_status(handles)
        % 更新并行池状态显示
        if ~isempty(gcp('nocreate'))
            pool = gcp('nocreate');
            status_str = sprintf('并行池状态: 运行中 (%d 个工作进程)', pool.NumWorkers);
            set(handles.parallel_status_text, 'String', status_str);
            set(handles.parallel_status_text, 'ForegroundColor', [0 0.5 0]);
        else
            set(handles.parallel_status_text, 'String', '并行池状态: 未创建');
            set(handles.parallel_status_text, 'ForegroundColor', [0.5 0.5 0.5]);
        end
    end
end