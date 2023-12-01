clear all
figure;
%% 选取文件路径
%使用 uigetdir 函数弹出对话框，让用户选择文件夹
selected_folder = uigetdir();
%检查用户是否点击了取消按钮
if selected_folder == 0
    disp('用户取消了选择文件夹。');
else
    % 如果用户选择了文件夹，则输出所选文件夹路径
    disp(['用户选择的文件夹路径为：' selected_folder]);
    % 在这里可以继续对所选文件夹进行其他操作
    % ...
    path = ([selected_folder '\'])
end
load([path '\planeData.mat']);
load('circle_grid.mat')
% 创建 VideoWriter 对象
outputVideo = VideoWriter('interpolation_animation.mp4', 'MPEG-4');
outputVideo.FrameRate = 10;
open(outputVideo);
% 遍历时间步长
varible=planeData.temperature
for t = 1:length(planeData.time)
    % 对网格上的点进行插值
    zq = griddata(planeData.xposition(:,t), planeData.yposition(:,t), varible(:,t), xq, yq);
    % 设置jet色阶
    colormap('jet');
    % 绘制等高线图并去除等高线之间的线条
    contour(xq, yq, zq, 'Fill', 'on');
    axis equal;
    % 添加标签和标题
    xlabel('X-axis');
    ylabel('Y-axis');
    titleName=['Contour Plot at ' num2str(planeData.time(t)*1000) ' ms']
    title(titleName);
    caxis([min(min(varible)), max(max(varible))]);
%     caxis([250, 900]);
    colorbar;
    % 更新图形
    drawnow;
    % 写入当前图形帧到视频文件
    writeVideo(outputVideo, getframe(gcf));
end

close(outputVideo);