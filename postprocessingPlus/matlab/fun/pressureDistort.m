function result = pressureDistort(path,pressure_correction,deltaAngled)
%PRESSUREDISTORT 此处显示有关此函数的摘要
%   输入数据文件路径
%   输出
%       averagePressure: AIP的平均压力
%    highAveragePressure: 高压区的平均压力
%           deltaSigma_0: 面平均紊流度
%              varpsilon: 压力不均匀度
    path = ([path '\'])
    if exist([path 'resultaveragePressure.mat'], 'file')
        load([path 'resultaveragePressure.mat'],'resultaverage');
    else
        load([path 'planeData.mat'])
        time= planeData.time
        planeData.pressure=planeData.pressure + pressure_correction %绝对压力
        resultaverage = averageAngleVaribleGrid(planeData.xposition,planeData.yposition,planeData.pressure,deltaAngled)
        resultaverage.time=planeData.time;
        save([path 'resultaveragePressure.mat'],'resultaverage');
    end
    pressuredata = resultaverage.dataAverageVArea
    deltaT = resultaverage.time(2)- resultaverage.time(1)
    ts = resultaverage.time(size(pressuredata,2)) - resultaverage.time(1) 
    %% 面平均紊流度
    %%AIP总压脉动均方根
    P_t=mean(pressuredata, 2);%%某一个角度的平均时均压力
    P_t2=P_t-P_t + mean(P_t)%%或者说P_t2=P_t，但是两者差别并不多
    diff_square = P_t2 - P_t2
    for i = 1:size(pressuredata,2)
        diff_square = diff_square + (P_t2 - pressuredata(:,i)).^2 .* deltaT
    end
    deltaP_RMS = sqrt(diff_square./ts)
    varpsilon = deltaP_RMS./P_t2
    %varpsilon_av = mean(varpsilon)
    %% 畸变强度
    P_t0 = mean(pressuredata(:,1),1)
    sigma_av = mean(pressuredata,1)
    highAveragePressure=[]
    Varible = pressuredata
    for i=1:size(Varible,2)
        VaribleCol=[]
        averagePressure=mean(Varible(:,i))
        %%拟合角度-温度函数
        angle=-180:deltaAngled:180%x轴
        VaribleCol=[Varible(:,i)' Varible(1,i)];%y轴
        %%样条插值
        xx=-180:0.1:180
        f_varible=spline(angle,VaribleCol,xx)
        xId=xx(find(f_varible > averagePressure))
        yId=f_varible(find(f_varible > averagePressure))
        num_x = length(xId);%%查找大于平均值x的个数
        angleResult(i)=0.1*num_x%%使用积分的思想，角度范围大于y值的角度乘变化步长
%         close;
%         figure;
%         plot(xx,f_varible,'l',angle,VaribleCol)
        highAveragePressure(i) = mean(yId)
        averagePressureC(i)=averagePressure; 
    end
    
    deltaSigma_0 = 1 - highAveragePressure./sigma_av
    %%result.angle = angleResult;
    %% 输出参数
    result.averagePressure = averagePressureC
    result.highAveragePressure = highAveragePressure
    result.deltaSigma_0 = deltaSigma_0;
    result.varpsilon = varpsilon




end

