function result = averageAngleVaribleGrid(xposition,yposition,varible,deltaAngled)
%TEMPERATUREANGLEGRID 此处显示有关此函数的摘要
%% 构造网格
run createMesh.m
load('circle_grid.mat')
endT=size(varible,2)
for t = 1:endT
    %% 构造一个时间尺度的网格
    zq = griddata(xposition(:,t), yposition(:,t), varible(:,t), xq, yq);
    %% 绘图部分
%     close;
%     figure;
%     colormap('jet');
%     % 绘制等高线图并去除等高线之间的线条
%     contour(xq, yq, zq, 'Fill', 'on');
%     axis equal;
%     % 添加标签和标题
%     xlabel('X-axis');
%     ylabel('Y-axis');
%     titleName=['Contour Plot at ' num2str(t)]
%     title(titleName);
%     caxis([min(min(varible)), max(max(varible))]);
% %     caxis([250, 900]);
%     colorbar;
%     % 更新图形
%     drawnow;
%     hold on;
    
    %%
    %计算角度
    averageTemperatureAreaVector=[]
    averageTemperatureVector=[]
    for theta=-180:deltaAngled:180-deltaAngled
        diffDistance = 0.001
        distance = 0:diffDistance:max(xposition(:,t))
        %设置采样数列
        x=cosd(theta)*distance
        y=sind(theta)*distance
        %%显示角度
%         plot(x, y, 'k-', 'LineWidth', 2);
        ZI = interp2(xq,yq,zq,x,y)%计算改路径下的插值数列    
        AAA=find(isnan(ZI));
        ZI(AAA) = [];%过滤Nan值
        distance(AAA) = [];
        %% 直接平均
        averageTemperature = mean(ZI)
        %% 径向平均温度，根据国标需要进行修改
        % area=ZI.*(distance.^2*deltaAngled*pi/180)
        area = max(xposition(:,t))^2*deltaAngled*pi/180
        deltaAngle=deltaAngled*pi/180
        % averageTemperatureArea = sum(area(2:length(area))-area(1:length(area)-1))/(max(distance)^2*deltaAngled*pi/180)
        averageTemperatureArea = deltaAngle*distance*ZI'*diffDistance/(max(distance)^2*deltaAngle*0.5)%pi*r*dr*对应的值/总面积

        %% 存储数据
        averageTemperatureAreaVector=[averageTemperatureAreaVector,averageTemperatureArea]
        averageTemperatureVector=[averageTemperatureVector,averageTemperature]
    end
        dataAverageV(:,t)= averageTemperatureVector'
        dataAverageVArea(:,t)=averageTemperatureAreaVector'
        angle=-180:deltaAngled:180-deltaAngled
end
result.dataAverageV=dataAverageV
result.dataAverageVArea=dataAverageVArea
result.angle=angle
end

    
    
   
 


