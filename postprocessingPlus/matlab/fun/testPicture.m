function testPicture(path)
%PICTURE 此处显示有关此函数的摘要
%   此处显示详细说明
    load('circle_grid.mat')
    AA= readtable(path, 'FileType', 'text')
    % 添加标签和标题
    xlabel('X-axis');
    ylabel('Y-axis');

    % titleName=['Contour Plot at ' num2str(planeData.time(t)*1000) ' ms']
    % title(titleName);
    % caxis([min(min(AA.total_temperature)), max(max(AA.total_temperature))]);

    % 修改插值方法
    method = 'linear'; % 可选 'linear', 'nearest', 'cubic'
    zq = griddata(AA.x_coordinate, AA.y_coordinate, AA.total_temperature, xq, yq, method);
    zq = smooth2a(zq,10,10)
    % 设置jet色阶
    colormap('jet');
    % 绘制等高线图并去除等高线之间的线条
    % 绘制等值线图，指定等值线密度
    numContours = 30;  % 等值线的数量
    contourLevels = linspace(min(zq(:)), max(zq(:)), numContours);  % 等值线密度
    contour(xq, yq, zq,contourLevels, 'Fill', 'on');




    % 调整图像比例
    axis equal;
    colorbar;  % 添加颜色条

    axis equal;
    % % 添加标签和标题
    % xlabel('X-axis');
    % ylabel('Y-axis');
    % title("2");
    caxis([min(AA.temperature), max(AA.temperature)]);
    mean(AA.total_temperature)
    % colorbar;
    % colormap(jet);
    % 
    % caxis([300 1300]); % 设置颜色栏的范围
end

