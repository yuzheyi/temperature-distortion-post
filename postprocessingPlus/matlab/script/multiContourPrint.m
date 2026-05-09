% 设置文件路径
filePaths = configData.multiContourPrint.root_path
titles = configData.multiContourPrint.titles
figure()
% 计算子图的行数和列数
numPlots = length(filePaths);
numRows = ceil(numPlots / 3); % 每行3个子图
% 设置颜色栏注释
colorbarLabel = 'Temperature (K)'; % 设置颜色栏的注释
% 循环绘制子图
for i = 1:numPlots
    
    subplot(numRows, 3, i);
    testPicture(filePaths{i});
    colormap(jet);
    caxis([300 1200]); % 设置颜色栏的范围
    title('Temperature');
    % 如果标题数组存在且当前索引有定义标题，则设置标题
    if exist('titles', 'var') && i <= length(titles) && ~isempty(titles{i})
        title(titles{i}, 'FontSize', 14);
    end
    % 添加标签和标题
    xlabel('X(m)');
    ylabel('Y(m)');
    % 设置颜色栏注释
    c = colorbar;
    c.Label.String = colorbarLabel;
end