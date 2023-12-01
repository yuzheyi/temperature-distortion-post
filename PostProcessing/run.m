clear all
% 使用 uigetdir 函数弹出对话框，让用户选择文件夹
selected_folder = uigetdir();

% 检查用户是否点击了取消按钮
if selected_folder == 0
    disp('用户取消了选择文件夹。');
else
    % 如果用户选择了文件夹，则输出所选文件夹路径
    disp(['用户选择的文件夹路径为：' selected_folder]);
    % 在这里可以继续对所选文件夹进行其他操作
    % ...
path_fold=selected_folder
file_path=fullfile(path_fold, 'average.mat');
% 检查文件是否存在
    if exist(file_path, 'file')
    % 如果文件存在，则加载文件
        load(file_path);
    
    % 在这里添加其他操作，对加载的数据进行处理  
    else
    % 如果文件不存在，输出提示信息或进行其他处理
        disp('文件 average.mat 不存在，正在加载数据。');
        T = face_distrubution(path_fold,'T')
        P = face_distrubution(path_fold,'P')
        file_path=fullfile(path_fold, 'average.mat');
        save(file_path, 'T', 'P');
    end
temperture_on_line(path_fold,T)
temperture_on_line(path_fold,P)
results =  range(path_fold)
P_divation(path_fold)
T_divation(path_fold)
% temperture_on_line(path_fold,T)
end


