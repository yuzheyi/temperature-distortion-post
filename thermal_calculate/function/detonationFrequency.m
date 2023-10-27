%% 根据已有的
%%% 输入参数
%空气质量流量m_air，爆震管类detonation（包括长度、管径、数量）
%%% 输出参数
%工作频率frequency
function frequency = detonationFrequency(m_air,detonation)
%%计算单次爆震容量（m^3）
diameter=detonation.Diameter*10^(-3);
length=detonation.Length*10^(-3);
volume=detonation.Number*pi*(diameter)^2/4*length
%%计算质量容量（单位kg）
rho=1.2
m_det=volume*rho;
%%计算频率s^-1
frequency=m_air/m_det
