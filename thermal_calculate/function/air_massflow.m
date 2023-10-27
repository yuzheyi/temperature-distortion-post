%% 计算化学恰当比
%%% 输入参数
%燃油流量m_fuel(kg/s),无量纲数当量比phi，燃油类（fuel）
%%% 输出参数
%空气流量m_air（kg/s）
function m_air = air_massflow(m_fuel,phi,fuel)

M_o=16,M_n=14,M_h=1,M_c=12,R=8314 %%分子摩尔数
MW_fuel=fuel.CNumber*M_c+fuel.HNumber*M_h
a=fuel.CNumber+fuel.HNumber/4
A_F_s=a*(3.76*2*M_n+1*2*M_o)/(MW_fuel)

m_air = m_fuel*phi*A_F_s