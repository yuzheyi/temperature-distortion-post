%% 函数通过空气参数，计算所需加热量
%%% 输入参数 
%m_in为空气流量kg/s，delta_T为加热量(K),inti_T为加热前的空气温度(K)
%%% 输出参数
%Q为加热量（kj）
%%% 改进指南
%%改函数假定空气的比热不随温度发生变化（后续修改可以对比热进行进一步修正）
%%
function Q = energy(airInlet)
 %单位kj/(kg*K),假设加热前后的空气压力保持不变（流入与流出的压力保持不变）
 n=0.9%定义一个燃烧效率
Q_inti = airInlet.TemperatureChange*airInlet.HighTemperatureFlowRate*airInlet.SpecificHeatConstantPressure
Q = Q_inti/n
