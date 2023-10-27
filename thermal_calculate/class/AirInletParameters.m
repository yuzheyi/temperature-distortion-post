classdef AirInletParameters
    properties
        Temperature % 温度（单位：摄氏度）
        Pressure    % 压力（单位：帕斯卡）
        TemperatureChange % 温升率（单位：摄氏度/秒）
        FlowRate    % 流量（单位：立方米/秒）
        HighTemperatureFlowRate      % 高温区流量（单位：立方米/秒）
        SpecificHeatConstantPressure % 定压比热（单位：千焦耳/（千克·摄氏度））
    end
    
    methods
        % 构造函数
        function obj = AirInletParameters(temperature, pressure, temperatureChange, flowRate,highTemperatureFlowRate,specificHeatConstantPressure)
            obj.Temperature = temperature;
            obj.Pressure = pressure;
            obj.TemperatureChange = temperatureChange;
            obj.FlowRate = flowRate;
            obj.HighTemperatureFlowRate = highTemperatureFlowRate
            obj.SpecificHeatConstantPressure = specificHeatConstantPressure
        end
    end
end
