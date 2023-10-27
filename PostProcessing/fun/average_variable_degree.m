%%%读取文件求平均值

function result = average_variable_degree(filename)

fileID = fopen(filename);
% 逐行读取文件中的文本
dataArray = {};
while ~feof(fileID)
    line = fgetl(fileID);
    dataArray{end+1} = line;
end
dataArray=dataArray'
fclose(fileID);
line=length(dataArray)
i=1
i=1
ii=1
iii=1
data={}
while i<=line
x{i,:}=strsplit(dataArray{i,1})% 使用 strsplit 函数将字符串按照空格分隔为单独的字符串单元格
 if numel(x{i,1}{1,1}) >= 1&&isstrprop(x{i,1}{1,1}(1), 'alpha')
     iii=iii+1
     ii=1
     data{1,iii}=x{i,1}
 elseif isstrprop(x{i,1}{1,1}, 'digit')
     data{ii+1,iii} =str2double(x{i,1})% 使用 str2double 函数将字符串单元格转换为数值
     ii=ii+1
 
 end
i=i+1
end
x(1:4,:)=[]
x(length(x),:)=[]
%%求平均
i=1
k=0
while i<=length(x)
k = str2double(x{i,1}{1,2})+k
i=i+1
end
result= k/length(x)