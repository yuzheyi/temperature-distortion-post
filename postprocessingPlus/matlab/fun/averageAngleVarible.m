%%输入初始矩阵，将笛卡尔坐标转化为极坐标
%%对角度进行平均积分，得出每个角度下的平均值
%% 输入参数
%%% xposition,yposition为笛卡尔坐标系
%%% varible为变量如温度或者压力
%%% deltaAngled为角度制对应的角度步长（比如5度平均一次）
%% 输出参数
%%% result.dataAverageV为角度下对应的平均值
%%% result.angleRange为角度制对应的角度

function result = averageAngleVarible(xposition,yposition,varible,deltaAngled)
    deltadetaAngled=deltaAngled
%AVERAGEANGLEVARIBLE 此处显示有关此函数的摘要
    % 主要输出参数planeData包含x，y的笛卡尔坐标和对于的时间物理参数
    position(:,1)=mean(xposition,2)
    position(:,2)=mean(yposition,2)
    [dataPol(:,1), dataPol(:,2)] = cart2pol(position(:,1), position(:,2));%转化为极坐标
    mergedMatrixV = [dataPol, varible];
    dataPol = sortrows(mergedMatrixV, 1);%进行弧度排序从-pi到pi
% 已经按照弧度大小进行排序，现在从0开始选取积分范围比如代表5度的平均范围在2.5~7.5之间
% 假设你的矩阵是 A，你想选取第5列的值在300和400之间的所有行
    dataAverageV = []
    angleRange = []
    for angled=-180:deltadetaAngled:180-deltadetaAngled
        angle= angled/180*pi%转化为弧度
        deltadetaAngle = deltadetaAngled/180*pi
        minRange = angle;
        maxRange = angle + deltadetaAngle;
        selected_rows = mergedMatrixV(mergedMatrixV(:, 1) >= minRange & mergedMatrixV(:, 1) <= maxRange, :);
        selected_rows = sortrows(selected_rows, 2);%%按弧长大小排列
    %     近似求面积从第二行开始减去第一行
        aera = zeros(1, size(selected_rows,1));  % 初始化 aera 数组
        laera(1)=selected_rows(1,2)
        for i = 2:size(selected_rows,1)%矩阵的行
            aera(i) = selected_rows(i, 2) - selected_rows(i-1, 2);
            varible=selected_rows( :,3:size(selected_rows,2));
            averageT=aera*varible./sum(aera)
        end
        dataAverageV = cat(1,dataAverageV,[averageT]);
        angleRange=cat(1,angleRange,angled);
    end
    result.dataAverageV=dataAverageV
    result.angleRange=angleRange
end

