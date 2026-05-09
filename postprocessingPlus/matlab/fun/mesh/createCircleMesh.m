function createCircleMesh(radius,dpi)
%CREATEMESH undefined
%   undefined

% 定义圆的半径radius
% 网格分辨率dpi

% 创建一个网格
[xq, yq] = meshgrid(linspace(-radius, radius, dpi), linspace(-radius, radius, dpi));
% 计算每个点到原点的距离
distance = sqrt(xq.^2 + yq.^2);
% 创建一个圆形的网格
circle_grid = distance <= radius;
save('circle_grid.mat','circle_grid','xq','yq','distance');



end