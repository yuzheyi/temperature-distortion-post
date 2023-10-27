clear all
% 空气参数环境压力，环境温度，空气中氧气的质量分数
Q=80/4*100/0.9*1*1000
P=1.01*10^5,T=300,fraction_o=0.21
%爆震管参数
l=2,d=0.08,f=20
% 燃油参数燃油流量，燃油与氧气反应的恰当比，碳氢燃料的碳数和H数
mf_f=Q/(4.29*10^7),C=11.57,H=21.99
phi=1

%%根据碳氢燃料方程计算氧气摩尔数
a=C+H/4
%%计算氧气质量,根据质量分数反推燃料-氧化剂恰当比
%% M=28,R=314,P=1.01*10^5,T=300
M_o=16,M_n=14,M_h=1,R=8314
mass_ox=a*M_o/fraction_o
mass_fuel=C*M_o+H*M_h
F_A=mass_fuel/mass_ox
%% 根据化学恰当比和当量比计算氧化剂质量流量
mf_ox=mf_f/(phi*F_A)

%%% 计算氧化剂密度
R_g_o=R/(M_o*2)
R_g_n=R/(M_n*2)
rho_ox=fraction_o*P/(T*R_g_o)+(1-fraction_o)*P/(T*R_g_n)


%计算氧化剂体积流量
V_t=mass_ox/rho_ox

% 计算单根爆震燃烧室总流量
V_det=f*l*(d/2)^2*pi

% 计算数量
n=V_t/V_det

