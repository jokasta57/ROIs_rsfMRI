% 7-julio-21
% Correlaciones PARCIALES IED y Scores (z_nodos_ROIs.csv), 

% CONTROLANDO POR LA VARIABLE EDAD!!!!!!!!!!

% ESTA NO HACE GRAFICAS Y SOLO SIRVE PARA OBTENER EN UN CSV LOS VALORES P Y R DE LAS CORRELACIONES DE PEARSON y SPEARMAN



clc, clear, close all

%13 controles con CANTAB; 19 pacientes con CANTAB (VALORES OBTENIDOS DE z_nodos_ROIs.csv)
%bd  = csvread('z_nodos_ROIs.csv'); %<--anterior
%bd  = csvread('z_nodos_ROIs_corrigiendo caudado_150LENG.csv');
bd  = csvread('z_nodos_ROIs_caudado_izq_v2_150LENG.csv');


pacientes =  bd(1:20,:);
pacientes(18,:) = []; %quitando la fila del paciente que no hizo las pruebas
pacientes(15,:) = []; %paciente 15 es un outlier en las correlaciones


%IED EDS errors,	IED Pre-ED errors,	IED Stages completed,	IED Total errors (adjusted),	IED Total trials (adjusted),	UHDRS motor,	MoCA,	CAG
scores_pat = [21 10 8 57 151 58 24 54;
    24 7 7 56 157 50 23 52;
    31 3 7 59 145 4 27 43;
    31 3 7 59 145 35 27 50;
    27 4 7 56 146 36 24 48;
    23 8 7 56 150 5 29 46;
    23 3 7 51 145 19 29 46;
    9 12 9 28 103 10 29 41;
    18 3 9 23 90 58 29 43;
    3 10 9 14 77 36 29 46;
    24 10 7 59 160 29 15 42;
    25 6 7 56 148 54 22 44;
    12 3 9 17 82 22 26 44;
    26 6 7 57 148 21 23 43;
    0 50 1 225 165 48 15 44;
    30 8 7 63 151 nan 19 44;
    30 5 7 60 150 3 23 41;
    30 10 7 65 155 64 22 40;
    30 15 7 70 159 34 22 42];

scores_pat(15, :) = [];%quitando al paciente 15 es un outlier en las correlaciones

% covariable
edad =[27
28
30
36
37
42
43
44
44
45
48
49
53
56
58
62
65
67];

%% Correlation

[fp,cp] = size(pacientes);
[fs,cs] = size(scores_pat);

% pat_pearson = [0];
pat_spearman = [0];

fin = 1;

for prueba = 1 : cs

    for sujeto = 1 : cp
        
%         %Pearson
%         [R,P] = corrcoef(scores_pat(:,prueba), pacientes(:,sujeto));
%         pat_pearson(sujeto,fin) = R(1,2);
%         pat_pearson(sujeto,fin+1) = P(1,2);
        
        %Spearman
        [R,P] = partialcorr(scores_pat(:,prueba), pacientes(:,sujeto), edad(:), 'type', 'Spearman');        
        pat_spearman(sujeto,fin) = R;
        pat_spearman(sujeto,fin+1) = P;
        
        
        
    end
    
    fin =  fin + 2;
end

%csvwrite('patHD_pearson_v2.csv',pat_pearson);
%csvwrite('patHD_spearman_v2.csv',pat_spearman);
%csvwrite('patHD_spearman_v3_correccion_caudado.csv',pat_spearman);
csvwrite('patHD_spearman_v3-caudado_izq_v2.csv',pat_spearman);


%% Obteniendo nombre de c/nodos

names = {'Right caudate', 'Left caudate', 'Right ventral striatum', 'Left ventral striatum', 'Right dorsolateral PFC', 'Left dorsolateral PFC', 'Right ventrolateral PFC', 'Left ventrolateral PFC'};  % <--- definir

nodos= {};

n_rois = 8;                                                                %<---- Definir

i  = 1;

combinaciones = (factorial(n_rois)/factorial(n_rois - 2))/2;

while i <= combinaciones % "28" es el no. de posibles combinaciones entre los 8 ROIs para este estudio  % <--- definir
    
    
    inicio = 1;
    
    fin = n_rois;
    
    k = 1;
    
    for f = 1 : fin
        
        for c = inicio+k : fin
            
            nom_nodos(i,1) = strcat(names(f),' - ', names(c));
            
            i = i + 1;
            
        end
        
        k = k + 1;
    end
    

end

nom_nodos



%% buscando nodos con correlacion significativa

score_names ={'IED EDS errors',	'IED Pre-ED errors','IED Stages completed','IED Total errors (adjusted)','IED Total trials (adjusted)','UHDRS motor','MoCA','CAG'};

% out_pearson = {};
% out_pearson = [nom_nodos num2cell(pat_pearson(:,:))];

out_spearman = {};
out_spearman = [nom_nodos num2cell(pat_spearman(:,:))];















