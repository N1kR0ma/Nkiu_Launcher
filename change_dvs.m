clear all
close all
format long

global sigma tau rho_crankshaft rho_prot 

%% Initial data

%%%%%%% Суффикс для обозначения нового расчёта 
%%%%%%% Я обычно ставил:
%%%%%%% MM --- для режима максимального момента
%%%%%%% MP --- для режима максимальной мощности
%%%%%%% (Если его не изменить предыдущие файлы перепишутся)
Skuffix = 'MM';

%%%%%%% Расчёт рабочего процесса оригинального двигателя (файл типа Dat)
file_ish = 'R4_P_MM_.DAT';

%%%% Частота вращения на дпнном режиме 
%%%% (не забывайте менять при смене режима) .П
w = 1000;

%%%%%%% Степень в которую возводится отношение числа циллиндров для сечений
%%%%%%% клапанов (При этом параметре мощности сходятся довольно точно)
%%%%%%% Меняйте если не кроются мощности
stepen_2 =  1;

%%%%%%% Папка с DosBox
Dos_box_dir = 'C:\Program^ Files^ ^(x86^)\DOSBox-0.74-3\DOSBOX.EXE';

%%%%%%% Cylinder diametr
D_first = 0.092;

%%%%%% Piston stroke
S_first = 0.092;

%%%%%% Conncting rod length
L_first = 0.159;

%%%% Effective cross-sectional area of ​​the intake valves
S_in_first = 0.00077;

%%%%% Effective cross-sectional area of ​​the exhaust valves
S_ex_first = 0.00070;


%%%%% Number of cylinders first
n_first = 4
%%%%% Number of cylinders second
n_second = 6;

%%%%% Number of cylinders third
n_third = 8;

%%%%%%% Материал коленчатого вала
%%%%%%% 1 ---
%%%%%%% 18 --- Сталь 40Х2Н2МА (308 1008 7800)
%%%%%%% 22 --- Чугун СЧ 35 
material_type = 22;

%%%%%%% Выбор типов двигателей (рядом сидящие вам kval не посчитает так что
%%%%%%% если у вас исходник такой то его нужно проводить как ещё
%%%%%%% 1 двигатель (да я знаю это гениально но не я автор))
%%%%%%% 0 - Рядный
%%%%%%% 1 - V-образный с рядом сидящими
%%%%%%% 2 - V-образный c прицепными
type_komp_first = 0;

type_komp_second = 2;

type_komp_third = 2;

%%%%%%% Тип исходного движка (в процессе создания новых файлов он 
%%%%%%% будет неизменен)
%%%%%%% 1 - Среднеоборотистый дизель
%%%%%%% 2 - Среднеоборотный форсированный дизель
%%%%%%% 3 - Высокооборотный дизель
%%%%%%% 4 - Авто. дизель с чугунными поршнями
%%%%%%% 5 - Авто. дизель с алюмин. поршнями
%%%%%%% 6 - Авто. двигатель с ВЭИ с чугунными поршнями
%%%%%%% 7 - Авто. двигатель с ВЭИ с алюмин. поршнями
type_dvs_first = 7;

%%%%%% Массы которые никто не знает как считать (лучше бериете 
%%%%%% в рамках диапазона для вашего движка не сильно большие)
mass_postup_first = 120;
mass_post_zil_first = 68;
massa_shatun_first = 120;
%%%%%% Параметр для V образных двигателей
massa_postup_boc_zil = 88;

%%%%%% Knee length
L_0_first = 0.120;

%%%%% Crankpin diametr (DK_naruzh)
Dk_sh_first = 0.064;

%%%%% Crankpin bore diametr (DK_vnutr)
Dk_sb_first = 0.03;

%%%%%% Main jornal diametr (Dsh_naruzh)
Ds_sh_first = 0.058;

%%%%%% Main jornal bore diametr (Dsh_vnutr)
Ds_sb_first = 0.033;

%%%%%% Cheek width
H_first = 0.09;

%%%%%%% Cheek thickness
B_first = 0.022;

%%%%%%% gltel
L_5_first = 0.02; 

%%%%%%% Радиус скругляения с щекой
R_galt_first = 2;

%%%%%%% Смещение оси противовеса 
L_6_first = 0.002;

%%%%%%%% ЕСЛИ ХОТИТЕ ЧТОБЫ ПАРАМЕТР СТАВИЛСЯ ПО УМОЛЧАНИЮ КАК В ПРОГЕ
%%%%%%%% СТАВЬТЕ 0 ИНАЧЕ БУДЕТ ВВЕДЕНО ТО ЧТО НАПИСАНО (ТОЛЬКО ДЛЯ ТОГО ЧТО
%%%%%%%% НИЖЕ  Не забывайте что чугун не сталь

%%%%%%% Предел выносливости по расчяжению
sigma = 480;
%%%%%%% Предел выносливости по кручению
tau = 290;
%%%%%%% Плотность коленчатого вала
rho_crankshaft = 7200;
%%%%%%% Плотность противовесов
rho_prot =  7200;

%% Nev DVS_parametr
%%%%%%% Constant of the mechanism
lambda = S_first/L_first/2;

%%%%%%% New parametr second DVS
[D_second, S_second, L_second] = dvs_constant(D_first, S_first, L_first,...
                                 n_first, n_second);

%%%%%%% New parametr second DVS
[D_third, S_third, L_third] = dvs_constant(D_first, S_first, L_first,...
                                 n_first, n_third);

%%%%%%% Расчёт входных сечений клапанов 2, 3 DVS
S_in_second = S_in_first * (n_first / n_second)^stepen_2 ;
S_in_third= S_in_first * (n_first / n_third)^stepen_2;

%%%%%%% Расчёт выходных сечений клапанов 2, 3 DVS
S_ex_second = S_ex_first * (n_first / n_second)^stepen_2;
S_ex_third= S_ex_first * (n_first / n_third)^stepen_2;

%%%%%%% Степень для параметров коленчатого вала (ИМХО она оптимальная)
stepen_2 = 1/2;

%% Crancshaft parametrs

%%%%%%% Crank radiusKafirst 
R_first  = S_first/2;

%%%%%% Чтобы массы отличаличались (возможно это надо как-то переписать)
if n_first>n_second
    mass_postup_second = mass_postup_first+2;
    mass_post_zil_second = mass_post_zil_first+2;
    massa_shatun_second = mass_post_zil_first+2;
else
    mass_postup_second = mass_postup_first-2;
    mass_post_zil_second = mass_post_zil_first-2;
    massa_shatun_second = mass_post_zil_first-2;
end

if n_first>n_third
    mass_postup_third = mass_postup_first+2;
    mass_post_zil_third = mass_post_zil_first+2;
    massa_shatun_third = mass_post_zil_first+2;
else
    mass_postup_third = mass_postup_first-2;
    mass_post_zil_third = mass_post_zil_first-2;
    massa_shatun_third = mass_post_zil_first-2;
end

%% New crankshaft 2

%%%%%%% Crank radius
R_second  = S_second/2;

%%%%%% Knee length
L_0_second = L_0_first * (n_first / n_second)^stepen_2;

%%%%% Crankpin diametr (DK_naruzh)
Dk_sh_second = Dk_sh_first * (n_first / n_second)^stepen_2;

%%%%% Crankpin bore diametr (DK_vnutr)
Dk_sb_second = Dk_sb_first * (n_first / n_second)^stepen_2;

%%%%%% Main jornal diametr (Dsh_naruzh)
Ds_sh_second = Ds_sh_first * (n_first / n_second)^stepen_2;

%%%%%% Main jornal bore diametr (Dsh_vnutr)
Ds_sb_second = Ds_sb_first * (n_first / n_second)^stepen_2;

%%%%%% Cheek width
H_second = H_first * (n_first / n_second)^stepen_2;

%%%%%%% Cheek thickness
B_second = B_first * (n_first / n_second)^stepen_2;

%%%%%%% gltel
L_5_second = L_5_first * (n_first / n_second)^stepen_2;

if type_komp_first==1
    L_4 = (L_0_second - 2*L_5_second - ...
        2*B_second - 4 * R_galt_first/1000)/2;
    B_second = B_second/1.25;
    L_5_second = L_5_second/1.5;
    L_0_second = L_5_second*2 + B_second*2 + L_4 + 4 * R_galt_first/1000;
end

%% New crankshaft 3

%%%%%%% Crank radius
R_third  = S_third/2;

%%%%%% Knee length
L_0_third = L_0_first * (n_first / n_third)^stepen_2;

%%%%% Crankpin diametr (DK_naruzh)
Dk_sh_third = Dk_sh_first * (n_first / n_third)^stepen_2;

%%%%% Crankpin bore diametr (DK_vnutr)
Dk_sb_third = Dk_sb_first * (n_first / n_third)^stepen_2;

%%%%%% Main jornal diametr (Dsh_naruzh)
Ds_sh_third = Ds_sh_first * (n_first / n_third)^stepen_2;

%%%%%% Main jornal bore diametr (Dsh_vnutr)
Ds_sb_third = Ds_sb_first * (n_first / n_third)^stepen_2;

%%%%%% Cheek width
H_third = H_first * (n_first / n_third)^stepen_2;

%%%%%%% Cheek thickness
B_third = B_first * (n_first / n_third)^stepen_2;

%%%%%%% gltel
L_5_third = L_5_first * (n_first / n_third)^stepen_2;

if type_komp_first==1
    L_4 = (L_0_third - 2*L_5_third - ...
        2*B_third - 4 * R_galt_first/1000)/2;
    B_third = B_third/1.25;
    L_5_third = L_5_third/1.5;
    L_0_third = L_5_third*2 + B_third*2 + L_4 + 4 * R_galt_first/1000;
end

%% Блок создания и записи данных в файлы kval
%%%%Создание текстового файла с новыми двигателями 
% %%%(пс лучше меняйте название)

%%%%%% Определение конечного пути для сохранения файлов расчёта
way = fileparts(which(mfilename));
way = way + "\!Result";

%% Исходный двигатель
Name_first = kval_function(type_dvs_first,...
    w,...
    mass_postup_first,...
    mass_post_zil_first,...
    massa_shatun_first, ...
    n_first,...
    type_komp_first,...
    ... Параметры коленчатого вала
    D_first,...
    L_first,...
    R_first,...
    L_0_first,...
    Dk_sb_first,...
    Dk_sh_first,...
    Ds_sh_first,...
    Ds_sb_first,...
    H_first,...
    B_first,...
    L_5_first,...
    L_6_first,...
    R_galt_first,...
    way,...
    Skuffix,...
    material_type);

copyfile(Name_first, way);

Name_NKIU_first = erase(Name_first, '.KVL');

NKIU_file_generate(file_ish, ... % Файсл с расчётом оригинала
    Name_NKIU_first, ... %%% Название нового файла
    Dos_box_dir,... %%% Директория с DOSBOX прогой
    D_first,... %%% Диаметр циллиндра нового двигателя
    S_in_first, ... %%% Площадь сечения впускных клапанов
    S_ex_first, ...
    S_first,... %%%% Ход поршня
    n_first, ... %%%% Число циллиндров
    lambda);   %%% Постоянаая механизма

Name_NKIU_first_DAT = Name_NKIU_first + '.DAT';
Name_NKIU_first_DIA = Name_NKIU_first + '.DIA';
Name_NKIU_first_REZ = Name_NKIU_first + '.REZ';

copyfile(Name_NKIU_first_DAT, way);
copyfile(Name_NKIU_first_DIA, way);
copyfile(Name_NKIU_first_REZ, way);

%%% Удаляем файлы из папки матлаб чтобы не захламлять её
delete(Name_NKIU_first_DAT, Name_NKIU_first_DIA, Name_NKIU_first_REZ);

%% Первая альтернатива
Name_second = kval_function(type_dvs_first,...
    w,...
    mass_postup_second,...
    mass_post_zil_second,...
    massa_shatun_second, ...
    n_second,...
    type_komp_second,...
    ... Параметры коленчатого вала
    D_second,...
    L_second,...
    R_second,...
    L_0_second,...
    Dk_sb_second,...
    Dk_sh_second,...
    Ds_sh_second,...
    Ds_sb_second,...
    H_second,...
    B_second,...
    L_5_second,...
    L_6_first,...
    R_galt_first,...
    way,...
    Skuffix, ...
    material_type);

copyfile(Name_second, way);

Name_NKIU_second = erase(Name_second, '.KVL');

NKIU_file_generate(file_ish, ... % Файсл с расчётом оригинала
    Name_NKIU_second, ... %%% Название нового файла
    Dos_box_dir,... %%% Директория с DOSBOX прогой
    D_second,... %%% Диаметр циллиндра нового двигателя
    S_in_second, ... %%% Площадь сечения впускных клапанов
    S_ex_second, ...
    S_second,... %%%% Ход поршня
    n_second, ... %%%% Число циллиндров
    lambda);   %%% Постоянаая механизма

Name_NKIU_second_DAT = Name_NKIU_second + '.DAT';
Name_NKIU_second_DIA = Name_NKIU_second + '.DIA';
Name_NKIU_second_REZ = Name_NKIU_second + '.REZ';

copyfile(Name_NKIU_second_DAT, way);
copyfile(Name_NKIU_second_DIA, way);
copyfile(Name_NKIU_second_REZ, way);

%%% Удаляем файлы из папки матлаб чтобы не захламлять её
delete(Name_NKIU_second_DAT, Name_NKIU_second_DIA, Name_NKIU_second_REZ);
%% Треться альтернатива
Name_third = kval_function(type_dvs_first,...
    w,...
    mass_postup_third,...
    mass_post_zil_third,...
    massa_shatun_third, ...
    n_third,...
    type_komp_third,...
    ... Параметры коленчатого вала
    D_third,...
    L_third,...
    R_third,...
    L_0_third,...
    Dk_sb_third,...
    Dk_sh_third,...
    Ds_sh_third,...
    Ds_sb_third,...
    H_third,...
    B_third,...
    L_5_third,...
    L_6_first,...
    R_galt_first,...
    way,...
    Skuffix, ...
    material_type);

copyfile(Name_third, way);

Name_NKIU_third = erase(Name_third, '.KVL');

NKIU_file_generate(file_ish, ... % Файсл с расчётом оригинала
    Name_NKIU_third, ... %%% Название нового файла
    Dos_box_dir,... %%% Директория с DOSBOX прогой
    D_third,... %%% Диаметр циллиндра нового двигателя
    S_in_third, ... %%% Площадь сечения впускных клапанов
    S_ex_third, ...
    S_third,... %%%% Ход поршня
    n_third, ... %%%% Число циллиндров
    lambda);   %%% Постоянаая механизма

Name_NKIU_third_DAT = Name_NKIU_third + '.DAT';
Name_NKIU_third_DIA = Name_NKIU_third + '.DIA';
Name_NKIU_third_REZ = Name_NKIU_third + '.REZ';

copyfile(Name_NKIU_third_DAT, way);
copyfile(Name_NKIU_third_DIA, way);
copyfile(Name_NKIU_third_REZ, way);

%%% Удаляем файлы из папки матлаб чтобы не захламлять её
delete(Name_NKIU_third_DAT, Name_NKIU_third_DIA, Name_NKIU_third_REZ);

%% Если исходный с рядом сидящими расчёт его с прицепными
if type_komp_first == 1 

%%%% Изменение суффикса для обособления файла
Skuffix = Skuffix + "p"; 

%%%% Переопределение некоторых длин для того чтобы оно было похоже на
%%%% правду
    L_4 = (L_0_first - 2*L_5_first - ...
        2*B_first - 4 * R_galt_first/1000)/2;
    B_first = B_first/1.25;
    L_5_first = L_5_first/1.5;
    L_0_first = L_5_first*2 + B_first*2 + L_4 + 4 * R_galt_first/1000;


Name_first = kval_function(type_dvs_first,...
    w,...
    mass_postup_first,...
    mass_post_zil_first,...
    massa_shatun_first, ...
    n_first,...
    2,...
    ... Параметры коленчатого вала
    D_first,...
    L_first,...
    R_first,...
    L_0_first,...
    Dk_sb_first,...
    Dk_sh_first,...
    Ds_sh_first,...
    Ds_sb_first,...
    H_first,...
    B_first,...
    L_5_first,...
    L_6_first,...
    R_galt_first,...
    way,...
    Skuffix, ...
    material_type);

copyfile(Name_first, way);

Name_NKIU_first = erase(Name_first, '.KVL');

NKIU_file_generate(file_ish, ... % Файсл с расчётом оригинала
    Name_NKIU_first, ... %%% Название нового файла
    Dos_box_dir,... %%% Директория с DOSBOX прогой
    D_first,... %%% Диаметр циллиндра нового двигателя
    S_in_first, ... %%% Площадь сечения впускных клапанов
    S_ex_first, ...
    S_first,... %%%% Ход поршня
    n_first, ... %%%% Число циллиндров
    lambda);   %%% Постоянаая механизма

Name_NKIU_first_DAT = Name_NKIU_first + '.DAT';
Name_NKIU_first_DIA = Name_NKIU_first + '.DIA';
Name_NKIU_first_REZ = Name_NKIU_first + '.REZ';

copyfile(Name_NKIU_first_DAT, way);
copyfile(Name_NKIU_first_DIA, way);
copyfile(Name_NKIU_first_REZ, way);


%%% Удаляем файлы из папки матлаб чтобы не захламлять её
delete(Name_NKIU_first_DAT, Name_NKIU_first_DIA, Name_NKIU_first_REZ);
end
fclose('all')

delete('*.KVL')

%% Создание файла сравнения для фанав латеха

fileID = fopen('change_dvs.txt','w');

fmt = '& $ %f $ ';

n = [n_first, n_second, n_third];
D = [D_first, D_second, D_third];
L = [L_first, L_second, L_third];
S = [S_first, S_second, S_third];
Lambda = S./(2*L);
S_in = [S_in_first, S_in_second, S_in_third];
S_ex = [S_ex_first, S_ex_second, S_ex_third];
R = [R_first, R_second, R_third];
L_0 = [L_0_first, L_0_second, L_0_third];
Dk_sh = [Dk_sh_first, Dk_sh_second, Dk_sh_third];
Dk_sb = [Dk_sb_first, Dk_sb_second, Dk_sb_third];
DsSh = [Ds_sh_first, Ds_sh_second, Ds_sh_third];
Ds_sb = [Ds_sb_first, Ds_sb_second, Ds_sb_third];
H = [H_first, H_second, H_third];
B = [B_first, B_second, B_third];
L_5 = [L_5_first, L_5_second, L_5_third];

fprintf(fileID, '\\hline \n Число цилиндров $n$ & $\\text{м}$');

fprintf(fileID,fmt, n);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Диаметр поршня $D$  & $\\text{м}$');

fprintf(fileID,fmt, D)

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Ход поршня $S$  & $\\text{м}$');
fprintf(fileID,fmt, S);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Длина шатуна $L$ & $\\text{м}$');

fprintf(fileID,fmt, L);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Постоянная механизма R//L & $\\text{м}$');

fprintf(fileID,fmt, Lambda);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Сечение впускных клапанов $S_{in}$ & $\\text{м}^2$');

fprintf(fileID,fmt, S_in);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Сечение выпускных клапанов $S_{ex}$ & $\\text{м}^2$');

fprintf(fileID,fmt, S_ex);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Радиус колена $R_k$ & $\\text{м}$');

fprintf(fileID,fmt, R);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Длина колена $L_0$ & $\\text{м}$');

fprintf(fileID,fmt, L_0);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Диаметр коренной шейки $Dk_{sh}$ & $\\text{м}$');

fprintf(fileID,fmt, Dk_sh);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Диаметр отверстия в коренной шейке $Dk_{sb}$ & $\\text{м}$');

fprintf(fileID,fmt, Dk_sb);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Диаметр шатунной шейки $Ds_{sh}$ & $\\text{м}$');

fprintf(fileID,fmt, DsSh);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Диаметр отверстия в шатунной шейке $Ds_{sb}$& $\\text{м}$');

fprintf(fileID,fmt, Ds_sb);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Ширина щеки $H$ & $\\text{м}$');

fprintf(fileID,fmt, H);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Толщина щеки $B$ & $\\text{м}$');

fprintf(fileID,fmt, B);

fprintf(fileID, '\\');
fprintf(fileID, '\\ \n');

fprintf(fileID, '\\hline \n Полудлина коренной шейки $L_5$ & $\\text{м}$');

fprintf(fileID,fmt, L_5);

%% Окончание

fprintf('Работа сделана')
%% Function section

% Функция центрирования текста (сам в шоке что такое потребовалось писать)
function [] = text_center(text, fid, line_width)    
    % Вычисляем отступы
    text_length = length(text);
    left_spaces = floor((line_width - text_length) / 2);
    right_spaces = line_width - text_length - left_spaces;
    
    % Записываем центрированный текст
    fprintf(fid, '%s%s%s\n', ...
        repmat(' ', 1, left_spaces), ...
        text, ...
        repmat(' ', 1, right_spaces));
end

% Функция перерасчёта диаметра циллиндра, хода поршня и длины шатуна
function [D, S, L] = dvs_constant(D_1, S_1, L_1, n_1, n)

koef = (n_1/n)^(1/3);

D = D_1 * koef;

S = S_1 * koef;

L = L_1 * koef;

end

% Функция для создания файлов kval автоматически
function [Name] = kval_function(type_dvs,...
    w,...
    mass_postup,...
    mass_post_zil,...
    massa_shatun,...
    number_zil_sec,...
    type_komp,...
    ... Параметры коленчатого вала
    D,... 
    L_shat,... 
    R_kriv,...
    L_0,...
    Dk_sb,...
    Dk_sh,...
    Ds_sh,...
    Ds_sb,...
    H,...
    B,... 
    L_5,...
    L_6,...
    R_galt,...
    way2DIA,...
    Skuffix, ...
    material_type);

global sigma tau rho_crankshaft rho_prot 

%%%% Поряк раюоты циллиндров в зависимости от их числа и типа двигателя

zil_zajig_R = ["0", '0-360', '0-240-480', '0-360-540-180',...
    '0-144-432-576-288', '0-480-240-600-120-360',...
    '0-130-309-514-617-411-206',...
    '0-450-90-360-630-180-540-270', '0', '0', '0', '0'];

zil_zajig_V = ["0", '0-180', '0', '0-90-270-540', '0',...
    '0-240-120-480-360-600', '0', '0-630-180-450-270-360-90-450',...
    '0', '0-360-288-648-72-432-144-504-216-576', '0',...
    '0-660-240-420-120-540-300-360-60-600-180-480'];

%%% 
if type_komp ~= 0
    section = number_zil_sec/2;
    Name_0  = "V";
    alpha = 360/section;
    %%%%% Функция множественного выбора в матлаб

    switch number_zil_sec
        case 2
        alpha_zil = zil_zajig_V(1,2);
        case 4
        alpha_zil = zil_zajig_V(1,4);
        case 6
        alpha_zil = zil_zajig_V(1,6);
        case 8
        alpha_zil = zil_zajig_V(1,8);
        case 10
        alpha_zil = zil_zajig_V(1,10);
        case 12
        alpha_zil = zil_zajig_V(1,12);
        otherwise
        'Who are u warrior?'
    end
else
    section = number_zil_sec;
    Name_0  = "R";
    alpha = 0;
        switch number_zil_sec
        case 1
        alpha_zil = zil_zajig_R(1,1);
        case 2
        alpha_zil = zil_zajig_R(1,2);
        case 3
        alpha_zil = zil_zajig_R(1,3);
        case 4
        alpha_zil = zil_zajig_R(1,4);
        case 5
        alpha_zil = zil_zajig_R(1,5);
        case 6
        alpha_zil = zil_zajig_R(1,6);
        case 7
        alpha_zil = zil_zajig_R(1,7);
        case 8
        alpha_zil = zil_zajig_R(1,8);
        case 9
        alpha_zil = zil_zajig_R(1,9);
        case 10
        alpha_zil = zil_zajig_R(1,10);
        otherwise
        'Who are u warrior?'
        end
end

%%% Выбор стали и её параметров

switch material_type
    case 18
        sigma_1 = 1008;
        tau_1 = 308;
        rho_crankshaft_1 = 7800;
        Name_material = 'Сталь 40Х2Н2МА';
        Name_type_material = 'Легированная'
    case 22
        sigma_1 = 480;
        tau_1 = 290;
        rho_crankshaft_1 = 7200;
        Name_material = 'Чугун СЧ 35'; 
        Name_type_material = 'Углеродистая'
end

chuguni = [22, 23];
%%%%% Если пользователь что-то ввёл то то надо ли что-то записвать
if sigma ~= 0
    sigma_1 = sigma;
end

if tau ~= 0
    tau_1 = tau;
end

if ~any(material_type == chuguni) && rho_crankshaft_1 ~=7800
    fprintf(['Вы уверены в плотности которую назначили \n вы выбрали сталь' ...
        ' а  плотность не та'])
end

if any(material_type == chuguni) && rho_crankshaft_1 ~=7200
    fprintf(['Вы уверены в плотности которую назначили \n вы выбрали чугун' ...
        ' а  плотность не та'])
end

if rho_crankshaft ~= 0
    rho_crankshaft_1 = rho_crankshaft;
end



%%%% Имена файлов коленчатых валов
Name_1 = Name_0 + string(number_zil_sec)+ "_" + Skuffix +'.KVL'

%%% Определение пути до файла с расчётами ДВС
way2DIA =way2DIA + '\'+ Name_0 + string(number_zil_sec)+...
    '_' + Skuffix + '.DIA';

switch type_dvs
        case 1
    Name_type_DVS = 'Среднеоборотистый дизель';
        case 2
    Name_type_DVS = 'Среднеоборотный форсированный дизель';
        case 3
    Name_type_DVS = 'Высокооборотный дизель';
        case 4
    Name_type_DVS = 'Авто. дизель с чугунными поршнями';
        case 5
    Name_type_DVS = 'Авто. дизель с алюмин. поршнями';
        case 6
    Name_type_DVS = 'вто. двигатель с ВЭИ с чугунными поршнями';
        case 7
    Name_type_DVS = 'Авто. двигатель с ВЭИ с алюмин. поршнями';
end

%%%%%%%%%% Здесь и далее если что-то меняете то учитывайте что:
%%%%%%%%%% 1) \n в конце каждой строки для переноса строки если его убрать
%%%%%%%%%% то может нихрена не сработать
%%%%%%%%%% Если удалить fclose("all") то будет выдавать ошибку 32
%%%%%%%%%% Дополняйте и оптимизируйте это говно т.к. написано оно на похуй
fileID = fopen(Name_1,'w');
fprintf(fileID, 'ClearForm.kvl \n');
%%%%%%% Путь к файлу с расчётом двигателя
fprintf(fileID,'%s\n' ,way2DIA);
...%%%%%%% 1 - Среднеоборотистый дизель
...%%%%%%% 2 - Среднеоборотный форсированный дизель
...%%%%%%% 3 - Высокооборотный дизель
...%%%%%%% 4 - Авто. дизель с чугунными поршнями
...%%%%%%% 5 - Авто. дизель с алюмин. поршнями
...%%%%%%% 6 - Авто. двигатель с ВЭИ с чугунными поршнями
...%%%%%%% 7 - Авто. двигатель с ВЭИ с алюмин. поршнями
fprintf(fileID,'%d\n', type_dvs);
%%%%% Название типа двигателя
 fprintf(fileID,'%s\n', Name_type_DVS);
%%%%% Номер материала
 fprintf(fileID,'%d\n', material_type);
%%%%% Название Стали
 fprintf(fileID,'%s\n', Name_material);
%%%%% Тип материала стали
 fprintf(fileID,'%s\n', Name_type_material);
... %%%%%%% Предел выносливости касательные
...%%%%%%% но я не уверен значения странные
 fprintf(fileID,'%f\n', tau_1);
... %%%%%%% Предел выносливости нормлаьные
...%%%%%%% но я не уверен значения странные
 fprintf(fileID,'%f\n', sigma_1);
... %%%%%%% Плотность стали
 fprintf(fileID,'%f\n', rho_crankshaft_1);
... %%%%%%% Плотность противовесов
 fprintf(fileID,'%f\n', rho_prot);
... %%%%%%% Частота вращения вала в данном режиме
 fprintf(fileID,'%f\n', w);
 ... %%%%%%% Масса поступательно движущихся частей
 fprintf(fileID,'%f\n', mass_postup);
... %%%%%%% Масса поступательно движ частей бок циллидра
 fprintf(fileID,'%f\n',  mass_post_zil);
... %%%%%%% Масса вращательно движущейся части шатуна
 fprintf(fileID,'%f\n',  massa_shatun);
... %%%%%%% Расчётные величины можно не трогать
 fprintf(fileID,['80.07\n'...
... %%%%%%% Расчётные величины можно не трогать
'328.07\n']);
... %%%%%%% Число секций
 fprintf(fileID,'%d\n', section);
... %%%%%%% 0 - Рядный
... %%%%%%% 1 - V-образный с рядом сидящими
... %%%%%%% 2 - V-образный с рядом прицепными
 fprintf(fileID,'%d\n',type_komp);
... %%%%%%% Угол развала 
... %%%%%%% Рядный 0
... %%%%%%% V-образный 8 - 90
... %%%%%%% V - образный 6 - 120
 fprintf(fileID,'%d\n',alpha);
... %%%%%%% 0 - Порядок работы циллиндров
... %%%%%%% 1 - Угол работы циллиндров
 fprintf(fileID,'1\n');
... %%%%%%% Углы работы циллиндров
fprintf(fileID,alpha_zil);
fprintf(fileID,'\n');
... %%%%%%% Угол наклона маслянной канавки влияет ли он на что-то?
fprintf(fileID,'90\n');
... %%%%%%% Диаметр циллиндра D
 fprintf(fileID,'%f\n',D);
... %%%%%%% Длина шатуна L
 fprintf(fileID,'%f\n',L_shat);
... %%%%%%% Радиус кривошипа R
 fprintf(fileID,'%f\n',R_kriv);
... %%%%%%% Длина колена L_0
 fprintf(fileID,'%f\n',L_0);
... %%%%%%% Отверстие в коренной шейке Dk_sb
 fprintf(fileID,'%f\n', Dk_sb);
... %%%%%%% Диаметр коренной шейки Dk_sh
 fprintf(fileID,'%f\n',Dk_sh);
... %%%%%%% Отверстие в шатунной шейке Ds_Sh
 fprintf(fileID,'%f\n', Ds_sb);
... %%%%%%% Диаметр шатунной шейки Ds_sb
 fprintf(fileID,'%f\n',Ds_sh);
... %%%%%%% Ширина щеки H
 fprintf(fileID,'%f\n',H);
... %%%%%%% Тощина щеки B
fprintf(fileID,'%f\n',B);
... %%%%%%%  Расстояние до щеки галтели L_5 (1/2 длины коренной шейки- R)
fprintf(fileID,'%f\n',L_5);
... %%%%%%% Смещение оси противовеса L_6 
fprintf(fileID,'%f\n',L_6);
... %%%%%%% Эксцентриситет облеч отв
fprintf(fileID,'0\n');
... %%%%%%% Радиус галтели какойто из шеек
fprintf(fileID,'%f\n',R_galt);
... %%%%%%% Радиус галтели какойто из шеек
fprintf(fileID,'%f\n',R_galt);
... %%%%%%% Радиус центра тяжести щеки
fprintf(fileID,['0.002\n'...
'0.048634\n'...
'131\n'...
'0.042\n'...
'0.0768\n'...
... %%%%%%% Включённность авторасчёта противовеса
'TRUE\n'...
... %%%%%%% Часть вывода программы гениально разместить это здесь
'2.204\n'...
'1.904\n'...
'2.1905\n'...
'1.0387\n'...
'1.0178\n'...
'1\n'...
'0.7408\n'...
'0.9568\n'...
'0.752\n'...
'1.7415\n'...
'1.8108\n'...
'1.0002\n'...
'1.811\n'...
'1.4621\n'...
'1.2258\n'...
'0.9704\n'...
'1\n'...
'0.8687\n'...
'1.5108\n'...
'1.6414\n'...
'1.4893\n'...
'1.0543\n'...
'1\n'...
'0.9821\n'...
'2.5311\n'...
'0.7855\n'...
'0.757\n'...
'0.74\n'...
'0.2889\n'...
'0.1591\n'...
'0.0796\n'...
'5\n'...
'1.21\n'...
'88\n']);
if type_komp ~=0
fprintf(fileID,'%f\n',floor((mass_postup+mass_post_zil+massa_shatun)/3));
end

Name = Name_1;
end
% #region My section
function [] = NKIU_file_generate(file_ish, ... % Файсл с расчётом оригинала
    Name_0, ... %%% Название нового файла
    Dos_box_dir,... %%% Директория с DOSBOX прогой
    D_zil,... %%% Диаметр циллиндра нового двигателя
    S_in, ... %%% Площадь сечения впускных клапанов
    S_ex, ... %%%% Площадь сечения выпускных клапанов
    S,... %%%% Ход поршня
    numb_zil, ... %%%% Число циллиндров
    lambda)   %%% Постоянаая механизма
%%%% Функция для создания альтернативных файлов с расчётом ДВС
%%%% 
%% Входные данные чтобы потом было удобнее переделывать в функцию
way = fileparts(which(mfilename));
File_ish = file_ish;
Name_1 = Name_0+".DAT";
Name_2 = Name_0 +".REZ";
way2dosbox = Dos_box_dir;
way2work_folder = way;

%% Преобразование путей и имён фалов
%%%% Не менять местамми а то имя будет дюже не красивое
%%%% Задаёт число пробелов
spaces = string(repmat(' ', 1, 12)); 
%%%% Это вариант генерации 
Variant = " 01";
%%%% Создание подзаголовка файла
zagolovok = strcat(Variant,spaces,Name_1);
Name =strcat(way2work_folder,'\',Name_1);
way2NKIU = way + "\NKIU";
wayNKIU = way + "\NKIU\NKIU.EXE"

%% Блок кода для создания файла входных данных
%%%%%% Считывание всех строк в файле исходнике
lines = readlines(File_ish);

%%%%% Скипаем тупой заголовок и выписываем данные из 1й строки
Line_4(1,:) = textscan(lines(4,1),'%s %s %s %s %s %s','Delimiter',...
    ' ','MultipleDelimsAsOne',1);
for i = 1:6
    Line_4_1(1,i) = str2num(cell2mat(Line_4{i}));
end

clear Line_4

%%%%% Скипаем заголовок и первую строку и считываем данные 5- 14 строки
for i = 1:10
    Line_5(i,:) = textscan(lines(i+4,1),'%s %s %s %s %s','Delimiter',...
    ' ','MultipleDelimsAsOne',1);
    for j = 1:5
        Line_5_1(i,j) = str2num(cell2mat(Line_5{i,j}));
    end
end

clear Line_5

%%%%% осторожно файлы закрываются
fclose('all')

%%%%% Блок переопределения значений в первой строчке
Line_4_1(1,1) = D_zil;
Line_4_1(1,2) = S;
Line_4_1(1,4) = lambda;

%%%%% Блок переопределения значаний 
Line_5_1(1,1) = numb_zil;
Line_5_1(4,1) = S_ex;
Line_5_1(5,1) = S_in;
Line_5_1(9,3) = 10;

%% Запись новых данных в файл нового двигателя
fid = fopen(Name_1,'w')

format_writer = '%12.6f %12.6f %12.6f %12.6f %12.6f\r\n'
 fprintf(fid,'------------------------------------------------------------ \n')  
 text_center('MГТУ им.Н.Э.Баумана каф.ДВС',fid, 70)  
 text_center(zagolovok,fid, 44) %%% Здесь нужно будет сделать тестовую переменную
 fprintf(fid,'%12.5f %12.6f %12.6f %12.6f %12.6f %12.6f\r\n',Line_4_1);
 fprintf(fid,format_writer,Line_5_1(1,:));
 fprintf(fid,format_writer,Line_5_1(2,:));
 fprintf(fid,format_writer,Line_5_1(3,:));
 fprintf(fid,format_writer,Line_5_1(4,:));
 fprintf(fid,format_writer,Line_5_1(5,:));
 fprintf(fid,format_writer,Line_5_1(6,:)); 
 fprintf(fid,format_writer,Line_5_1(7,:));
 fprintf(fid,format_writer,Line_5_1(8,:));
 fprintf(fid,format_writer,Line_5_1(9,:));
 fprintf(fid,'%d   %d   %d   %d   %d\r\n',Line_5_1(10,:));

type(Name_1)
%%% Конвертация в формат понятный для ms-dos
convertToMSDOS(Name, Name)
 
%% Копирование файла в папку NKIU
% Использование fullfile для кросс-платформенных путей
source = Name;
destination = way2NKIU;

% Создание целевой папки, если её нет
if ~exist(destination, 'dir')
    mkdir(destination)
end

copyfile(source, destination)
%%%%% осторожно файлы закрываются
fclose('all');

%% Создание скрипта для генерации нового фала
skript =  sprintf(['%s' ... %%%Выбор путя с досбоксом
    ' -c "mount c %s"' ... %%% Монтирования рабочего диска
    ' -c "C:"' ... %%% Выбор смонтированного в качестве рабочего
    ' -c "%s' ... %%% Путь из рабочей папки к проге NKIU
    ' %s' ...   %%% Файл с исходными данными
    ' %s"' ...  %%% Файл в который записывать расчёт
     '-c "exit"'], ... 
    way2dosbox, ...
    way2work_folder, ...
    'NKIU\NKIU.EXE', ...
    Name_1, ...
    Name_2);
%%  И все страдания были ради этой строчкидзж
system(skript);

%%%% Копирование файла в директорию с результатами
% Использование fullfile для кросс-платформенных путей
source = Name;
destination = way2NKIU;

% Создание целевой папки, если её нет
if ~exist(destination, 'dir')
    mkdir(destination)
end

copyfile(source, destination)

end

%%%%% Функция для перекодировки полученных матлабом файлов в понятную
%%%%% MS-DOS собственно от вас требуется 2 вещи:
%%%%% 1) Указать путь к фозданному файлу с его названием и кодировкой
%%%%% 2) Указать путь к файлу с новой желаемой кодировкой
%%%%% Поздравляю вы великолепны
%%%%% Написано Deepseek так что наверное это лучшая часть "моего" кода
function [] = convertToMSDOS(inputFile, outputFile)
% CONVERTTOMSDOS Конвертирует текстовый файл в кодировку MS-DOS (CP866)
%
% Синтаксис:
%   convertToMSDOS(inputFile, outputFile)
%   convertToMSDOS(inputFile)  - создаст файл с суффиксом '_dos.txt'
%
% Примеры:
%   convertToMSDOS('input.txt', 'output_dos.txt')
%   convertToMSDOS('document.txt')
%
% Поддерживаемые кодировки исходного файла:
%   UTF-8, Windows-1251, ASCII

    % Проверка количества аргументов
    if nargin < 1
        error('Необходимо указать входной файл');
    end
    
    % Если выходной файл не указан, создаем имя автоматически
    if nargin < 2
        [path, name, ext] = fileparts(inputFile);
        outputFile = fullfile(path, [name '_dos' ext]);
    end
    
    % Проверяем существование входного файла
    if ~exist(inputFile, 'file')
        error('Входной файл "%s" не найден', inputFile);
    end
    
    % Пытаемся определить кодировку исходного файла
    try
        % Пробуем прочитать файл в различных кодировках
        encodings = {'UTF-8', 'windows-1251', 'ISO-8859-1', 'US-ASCII'};
        
        for i = 1:length(encodings)
            try
                % Открываем файл с указанной кодировкой
                fid = fopen(inputFile, 'r', 'n', encodings{i});
                textData = fread(fid, '*char')';
                fclose(fid);
                
                fprintf('Файл успешно прочитан в кодировке: %s\n', encodings{i});
                break;
            catch
                if i == length(encodings)
                    error('Не удалось определить кодировку файла');
                end
            end
        end
        
    catch ME
        error('Ошибка при чтении файла: %s', ME.message);
    end
    
    % Конвертируем текст в кодировку MS-DOS (CP866)
    try
        % Для версий MATLAB с поддержкой iconv
        if exist('unicode2native', 'file') && exist('native2unicode', 'file')
            % Преобразуем текст в байты кодировки CP866
            bytes = unicode2native(textData, 'CP866');
            
            % Записываем в файл с кодировкой CP866
            fid = fopen(outputFile, 'w', 'n', 'CP866');
            fwrite(fid, bytes, 'uint8');
            fclose(fid);
            
        else
            % Альтернативный метод для старых версий MATLAB
            fprintf('Используется альтернативный метод конвертации...\n');
            
            % Попробуем использовать Java для конвертации
            try
                % Преобразуем строку в байты CP866 через Java
                bytes = uint8(textData);
                
                % Простая замена для кириллицы (Windows-1251 → CP866)
                % Это базовое преобразование для наиболее частых символов
                bytes = simpleEncodingConvert(bytes);
                
                fid = fopen(outputFile, 'wb');
                fwrite(fid, bytes, 'uint8');
                fclose(fid);
                
            catch
                % Самый простой метод - сохранить как есть
                warning('Используется прямое сохранение. Кодировка может быть некорректной.');
                fid = fopen(outputFile, 'w', 'n', 'windows-1251');
                fprintf(fid, '%s', textData);
                fclose(fid);
            end
        end
        
        fprintf('Файл успешно конвертирован и сохранен как: %s\n', outputFile);
        fprintf('Кодировка: MS-DOS (CP866)\n');
        
    catch ME
        error('Ошибка при конвертации: %s', ME.message);
    end
end
