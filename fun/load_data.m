function load_data(path)
path_fold=path
T = face_distrubution(path_fold,'T')
P = face_distrubution(path_fold,'P')
file_path=fullfile(path_fold, 'average.mat');
save(file_path, 'T', 'P');