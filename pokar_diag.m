%%%%%%%%%%% Import matrix from kval?
%%%%%%%%%%% Ye потомучто забагованно!
%%%%%%%%%%% Число строк в массиве
clear all
close all

%% Установка некоторых настроек графиков по умолчанию

% Change default axes fonts.
set(groot,'DefaultAxesFontName', 'Times New Roman');
set(groot,'DefaultAxesFontSize', 14);

% Change default text fonts.
set(groot,'DefaultTextFontname', 'Times New Roman');
set(groot,'DefaultTextFontSize', 14);

set(groot,'defaultFigureColor','w');

set(groot,'defaultLineLineWidth',2);

set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');


set(groot,'defaultFigurePosition', [0, 0, 1500, 1500]);
%%

%%% numbering of column on screenshot
m = 5;
%%%% number of column parametr
n = 5;

fileID = fopen('One.txt','r');
    part_one = fscanf(fileID, '%f');
    part_one  =  transp(reshape_array(part_one, m));
fclose(fileID);

fileID = fopen('Two.txt','r');
    part_two = fscanf(fileID, '%f');
    part_two  =  transp(reshape_array(part_two, m));
fclose(fileID);

Mass = cat(1, part_one, part_two);

l_0 = find(Mass(:,1)==180); 
l = find(Mass(:,1)==360);
Mass_n = zeros(4*l,1);
Mass_n(1:length(Mass(:,n)),1) = Mass(:,n);
for i = 1:l-1
        Wear(i,1) = Mass_n(i,1)* (Mass_n(i,1)>0)...
            + Mass_n(i+l_0,1)* (Mass_n(i+l_0,1)<0)...
            +Mass_n(i+l,1)* (Mass_n(i+l,1)>0)...
            +Mass_n(i+l+l_0-1,1)* (Mass_n(i+l+l_0-1,1)<0);
end
Wear(l,1) = Wear(1,1);

Mass(:,1) = Mass(:,1)*pi/180;
%%%%%%%% Оставлено в дань уважения предкам
% Mass(:,n+1) = Mass(:,n) .* cos(Mass(:,1))*K;
% Mass(:,n+2) = Mass(:,n) .* sin(Mass(:,1))*K;

%% Plot place
figure
polarplot(Mass(:,1), Mass(:,n));
saveas(gcf,'Polar_force','jpg')

figure
polarplot(Mass(1:l,1), Wear(:,1));
saveas(gcf,'Polar_wear','jpg')

%% Function section

function output_array = reshape_array(input_array, m)
% Преобразует массив 1×n в массив m×k
% Если m или k равно 0, размер вычисляется автоматически
%
% Входные параметры:
%   input_array - исходный массив размером 1×n
%   m - количество строк в выходном массиве
%   k - количество столбцов в выходном массиве
%
% Выходные параметры:
%   output_array - преобразованный массив размером m×k

    % Проверка входных данных
    if ~isvector(input_array)
        error('Входной массив должен быть вектором');
    end
    
    % Преобразование в вектор-строку если необходимо
    input_array = input_array(:)';
    
    n = length(input_array);
    
    % Автоматическое определение размеров
    if m == 0
        error('Необходимо указать хотя бы один размер (m или k)');
    end
    
% % %     Проверка совместимости размеров
    if isinteger(n/m) == 1
        error('Невозможно преобразовать массив длины %d в массив %d×%d', n, m);
    end
    
    % Преобразование массива
    output_array = reshape(input_array, m, n/m);
end