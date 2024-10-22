% clear all
% %% 选取文件路径
% %使用 uigetdir 函数弹出对话框，让用户选择文件夹
% selected_folder = uigetdir();
% %检查用户是否点击了取消按钮
% if selected_folder == 0
%     disp('用户取消了选择文件夹。');
% else
%     % 如果用户选择了文件夹，则输出所选文件夹路径
%     disp(['用户选择的文件夹路径为：' selected_folder]);
%     % 在这里可以继续对所选文件夹进行其他操作
%     % ...
%     path = ([selected_folder '\'])
% end
% 
% %% 读取plane的数据
% % if exist([path 'planeData.mat'], 'file')
% %     load([path 'planeData.mat'],'planeData');
% % else
%     time=readtable([path 'time.csv'])
%     colMax=max(find(any(time.x < 0.05, 2)))
%     time=time.x((find(any(time.x < 0.05, 2))))
%     planeData.time=time
%     for i = 1:colMax
%         %读取数据
%         count=100+(i-1)*50
%         filePath=[path 'planexy' num2str(count)]
%         data = readtable(filePath);
%         planeData.xposition(:,i)=data.x_coordinate
%         planeData.yposition(:,i)=data.y_coordinate
%         planeData.pressure(:,i)=data.pressure
%         planeData.temperature(:,i)=data.temperature
%         planeData.xvelocity(:,i)=data.x_velocity
%         planeData.yvelocity(:,i)=data.y_velocity
%         judge.x(i)=sum(planeData.xposition(:,i)-mean(planeData.xposition,2))
%         judge.y(i)=sum(planeData.yposition(:,i)-mean(planeData.yposition,2))
%     end
%     save([path 'planeData.mat'],'planeData');
% % end
% 
% 
% 
% % load([path '\planeData.mat']);
load('circle_grid.mat')
% % 创建 VideoWriter 对象
outputVideo = VideoWriter('interpolation_animation.mp4', 'MPEG-4');
outputVideo.FrameRate = 10;
open(outputVideo);
% % 遍历时间步
% varible1=planeData.xvelocity
% varible2=planeData.yvelocity
% varible=planeData.temperature
for t = 1:length(planeData.time)
    % 对网格上的点进行插值
    yv = griddata(planeData.xposition(:,t), planeData.yposition(:,t), varible1(:,t), xq, yq);
    xv = griddata(planeData.xposition(:,t), planeData.yposition(:,t), varible2(:,t), xq, yq);
    zq = griddata(planeData.xposition(:,t), planeData.yposition(:,t), varible(:,t), xq, yq);
    % 绘制等高线图并去除等高线之间的线条
    scale=0;
    quiver(xq, yq,xv,yv);
    startx = [0.866025404	0.707106781	0.5	0.258819045	0];
    starty = [0.5	0.707106781	0.866025404	0.965925826	1];
    
    startx = [0.707106781	0.866025404	0.965925826	1	0.965925826	0.866025404	0.707106781	0.5	0.258819045	0	-0.258819045	-0.5	-0.707106781	-0.866025404	-0.965925826]
    starty = [-0.707106781	-0.5	-0.258819045	6.12574E-17	0.258819045	0.5	0.707106781	0.866025404	0.965925826	1	0.965925826	0.866025404	0.707106781	0.5	0.258819045]

    streamline(xq, yq,xv,yv, startx.*0.18, starty.*0.18)
%     hold on
%     colormap('jet');
%     contour(xq, yq, zq, 'Fill', 'on');
%     caxis([min(min(varible)), max(max(varible))]);
% %     caxis([250, 900]);
%     colorbar;
    axis equal;    % 添加标签和标题
    xlabel('X-axis');
    ylabel('Y-axis');
    titleName=['Contour Plot at ' num2str(planeData.time(t)*1000) ' ms']
    title(titleName);

    % 更新图形
    drawnow;
    % 写入当前图形帧到视频文件
    writeVideo(outputVideo, getframe(gcf));
end

close(outputVideo);

