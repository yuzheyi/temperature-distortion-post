clear all
exp_data_path = "E:\mywork\博士工作\脉冲爆震温度畸变装置\数据\旋转爆震实验数据\汽油_富氧空气试验 - 副本\700g_稳压.csv"
A = readmatrix(exp_data_path, 'OutputType', 'string');
A(1:2,:)=[]
%% 固有参数
mf_air= 0.7
D_thoath = 90e-3
gamma =1.33
Rg = 287
P_e = 101325
%% 导入参数
time = A(:,1)
P_air = A(:,2)
P_combustion= str2double(A(:,3)).*1e5 + P_e
P_thoath= str2double(A(:,4)).*1e5 + P_e
P_oil= A(:,5)
mf_oil= A(:,6)
T_air= A(:,7)

%% 出口是临界状态，根据静压可以算出总压，有了总压、质量流率(kg/s*m^2)、比热比和理想气体常数就可以算出总温。
%%计算总压
TP_air = 0
%%
A_thoath = pi*(D_thoath/2)^2
mfr = mf_air/A_thoath

T = gamma.*P_thoath.^2/(Rg*mfr^2)
T0 = T.*(1+(gamma-1)/2)

P0 = P_combustion
P =P_thoath
Ma = sqrt( ...
    ( ...
    (P0./P).^((gamma-1)/gamma) ...
    -1) ...
    *2/(gamma-1) ...
    )

AA(:,1)=Ma
AA(:,2)=P_combustion
AA(:,3)=T
