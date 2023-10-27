clear all
%% 定义参数
%%% fuel = FuelProperties(heatValue, cNumber, hNumber);
fuel = FuelProperties(43070, 8, 18)
%%% airInlet = = AirInletParameters(temperature, pressure, temperatureChange, flowRate,highTemperatureFlowRate, specificHeatCP)
airInlet = AirInletParameters(300, 87*10^3, 300, 70,70/4,1.004)
%%实际当量比
phi=1
%%% 爆震管参数DetonationDesign(length,diameter)
%%detonationCondition(length,diameter,number)单位使用毫米（mm）
detonation = DetonationCondition(2000,80,8)

%% 计算过程(实验工况)
Q = energy(airInlet)%对应第一步
m_fuel = fuel_massflow(Q,fuel)%对应第二步
m_air = air_massflow(m_fuel,phi,fuel)%对应第三步
frequency = detonationFrequency(m_air,detonation)%对应第4.2步

