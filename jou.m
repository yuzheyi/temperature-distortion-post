% 指定文本文件路径(ti-menu-load-string (format #F "    " myPath))
file_path = 'C:\Users\YUJJ\Desktop\project\calculate_model\case1\case1commands.jou';
long=2.1


delete(file_path); % 删除文件
filePath = '~a/result/';
% 打开文本文件以进行写入
file_id = fopen(file_path, 'w');
fprintf(file_id, '!mkdir result\n(define myPath (getenv "PWD"))\n');
for axis_position = 0.1:0.1:long
    degree=0
 line_name = ['line' num2str(axis_position) '_' num2str(degree)];
    x1 = cosd(0.1);
    y1 = sind(0.1);
    x2 = axis_position;
    y2 = 0;
    z2 = 0;
    z1 = axis_position;
    
    cmd = ['/surface/line-surface ' line_name ' ' num2str(x1) ' ' num2str(y1) ' ' num2str(x2) ' ' num2str(y2) ' ' num2str(z2) ' ' num2str(z1)];
    
    % 将命令写入文本文件
    fprintf(file_id, '%s\n', cmd);
for degree = 5:5:355
    line_name = ['line' num2str(axis_position) '_' num2str(degree)];
    x1 = cosd(degree);
    y1 = sind(degree);
    x2 = axis_position;
    y2 = 0;
    z2 = 0;
    z1 = axis_position;
    
    cmd = ['/surface/line-surface ' line_name ' ' num2str(x1) ' ' num2str(y1) ' ' num2str(x2) ' ' num2str(y2) ' ' num2str(z2) ' ' num2str(z1)];
    
    % 将命令写入文本文件
    fprintf(file_id, '%s\n', cmd);
end

commandPrefix = '(ti-menu-load-string (format #F "/plot/plot yes ';
commanddelete = '/surface/delete-surface '
for i = 0:5:355
    % 构建完整的命令字符串
    fileName = ['line' num2str(axis_position) '_'  num2str(i)];
    command = [commandPrefix filePath  'T' num2str(axis_position) '_'  num2str(i) ' ok yes no no total-temperature no yes no ' fileName ' () " myPath))'];
    % 将命令写入文件
    fprintf(file_id, '%s\n', command);
    fileName = ['line' num2str(axis_position) '_'  num2str(i)];
    command = [commandPrefix filePath  'P' num2str(axis_position) '_'  num2str(i) ' ok yes no no pressure no yes no ' fileName ' () " myPath))'];
    % 将命令写入文件
    fprintf(file_id, '%s\n', command);

end

for i = 0:5:355
    % 构建完整的命令字符串
    fileName = ['line' num2str(axis_position) '_'  num2str(i)];
    delcommand = ['/surface/delete-surface ' fileName];
    % 将删除命令写入文件
    fprintf(file_id, '%s\n', delcommand')
end
end

% 关闭文件
fclose(file_id);



disp('命令已成功写入到文本文件。');
