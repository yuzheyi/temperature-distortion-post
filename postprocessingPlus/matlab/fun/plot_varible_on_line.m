function plot_varible_on_line(varible,axis_poision,angles)
    data = varible
    xi = min(axis_poision):0.01:max(axis_poision);  % 用于插值的新的x值
    legend_names = [];
        for i = 1:6:length(angles)
            figure(1)
            % 进行三次样条插值
            yi = interp1(axis_poision, data(i,:), xi, 'pchip');
            % 绘制原始数据和插值结果的图形
            %plot(axis_poision, data(i,:), '-o', xi, yi, '-');
            plot(axis_poision, data(i,:), '-o')
            xlabel('轴向距离');
            ylabel('变量');
            %title(['角度为' num2str(angles(i)) '°的轴向截面']);
            %legend('angle=' num2str(angles(i)));
            legend_names = [legend_names, {['angle=' num2str(angles(i))] }];
            legend('原始数据', '插值结果');
            hold on
        end
%     legend(legend_names);
%     saveas(figure(1), [file_path '截面分布图.png']);
%     close(figure(1))