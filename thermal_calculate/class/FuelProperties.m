%% 这是一个燃油的参数库
classdef FuelProperties
    properties
        HeatValue   % 热值（单位：kj/kg）
        CNumber     % C数
        HNumber     % H数
    end
    methods
        % 构造函数
        function obj = FuelProperties(heatValue, cNumber, hNumber)
            obj.HeatValue = heatValue;
            obj.CNumber = cNumber;
            obj.HNumber = hNumber;
        end
    end
end