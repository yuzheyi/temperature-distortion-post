function zq = interpolate_to_grid(position,varible,filePath)
    load(filePath)
    % 提取x坐标、y坐标和z值
    x = position(:, 1);
    y = position(:, 2);
    % 将离散点插值到网格中
    zq = griddata(x, y, varible, xq, yq);
end


