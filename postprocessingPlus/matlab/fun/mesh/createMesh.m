
% 定义圆的半径
% 定义圆的半径
radius = 0.375;
% 创建一个网格
[xq, yq] = meshgrid(linspace(-radius, radius, 500), linspace(-radius, radius, 500));
% 计算每个点到原点的距离
distance = sqrt(xq.^2 + yq.^2);
% 创建一个圆形的网格
circle_grid = distance <= radius;
save('circle_grid.mat','circle_grid','xq','yq','distance');

% % 创建一个新的图形窗口
% figure;
% 
% % 显示黑白网格线
% contour(xq, yq, circle_grid, [0.5 0.5], 'k', 'LineWidth', 1);  % 'k' 表示黑色
% 
% % 设置图形的显示属性
% axis equal;  % 保持比例
% xlabel('X');
% ylabel('Y');
% title('圆形网格线');
% 
% % 显示网格
% grid on;