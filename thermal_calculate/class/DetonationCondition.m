classdef DetonationCondition
    properties
        Length    % 长度（单位：米）
        Diameter  % 直径（单位：米）
        Number    % 数量
    end
    
    methods
        % 构造函数
        function obj = DetonationCondition(length, diameter, number)
            obj.Length = length;
            obj.Diameter = diameter;
            obj.Number = number;
        end
    end
end
