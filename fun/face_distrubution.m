%% 根据输出文件生成mat文件
%%%获得矩阵的平局值
function result = face_distrubution(path_fold,varible)
axis_i=1
degree = 0;
while degree < 360
    V{2 + degree/5, axis_i} = ['d=' num2str(degree) '°'];
    degree = degree + 5;
end
axis_position=0.1 
% 定义要检查的文件路径
file_to_check = [path_fold '\P' num2str(axis_position) '_0']
while exist(file_to_check, 'file') == 2
	V{1,axis_i+1}=['axis=' num2str(axis_position) 'm'];
	degree = 0;
        while degree <360
            filename =  [path_fold '\' varible num2str(axis_position) '_' num2str(degree)];
            V{2+degree/5,axis_i+1}=average_variable_degree(filename)
            degree = degree+5
        end
	axis_i=1+axis_i
	axis_position=axis_position + 0.1
	file_to_check = [path_fold '\P' num2str(axis_position) '_0']
end
result = V
