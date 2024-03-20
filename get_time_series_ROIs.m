% 20 - agosto- 21

% DE LOS TXT DE FSLMATHS

% [Matriz de conectividad funcional entre nodos para c/usuario, base de
% datos armada de las series de tiempo desde FSLEyes].
%
%ENTRADA: las direcciones de los txt generados por cada ROIs desde FSLmeants
%
% Ademas, definir el numero de ROIs que se seleccionaron en particular para el estudio
% p. ej.     n_rois = 8;

% No. de posibles combinaciones entre los 8 ROIs para este estudio
%

%SALIDA: matriz de conectividad funcional c/ combinaciones de todos nodos (No.sujetos x N nodos), dependiendo de los ROIs definidos;
% z_nodos_ROIs.csv y nombre de combinaciones entre ROIs


% Gustavo P. R

%%
clc, clear

n_sujetos = 52;                                                              %<---- Definir

n_rois = 5;                                                                  %<---- Definir

tam_serietiempo = 150;                                                       %<---- Definir

for roi = 1 : n_rois
    
    roi
    
    switch roi %cada carpeta contiene las series de tiempo de todos los sujetos (pat y ctrl)
        
        case 1
            cd('/Users/gus/Documents/MATLAB/Conn_SCA10/conn_sca10_v2/results/preprocessing/nii/cerebello_left')
            ultimo = 1;
        case 2
            cd('/Users/gus/Documents/MATLAB/Conn_SCA10/conn_sca10_v2/results/preprocessing/nii/cerebello_rigth')
            ultimo = ultimo + tam_serietiempo;            
        case 3
            cd('/Users/gus/Documents/MATLAB/Conn_SCA10/conn_sca10_v2/results/preprocessing/nii/fusiform_cortex')
            ultimo = ultimo + tam_serietiempo;
        case 4
            cd('/Users/gus/Documents/MATLAB/Conn_SCA10/conn_sca10_v2/results/preprocessing/nii/middle_cerebellar')
            ultimo = ultimo + tam_serietiempo;
        case 5
            cd('/Users/gus/Documents/MATLAB/Conn_SCA10/conn_sca10_v2/results/preprocessing/nii/rigth_cerebral_cortex')
            ultimo = ultimo + tam_serietiempo;
    end
    
    listing = dir('niftiDATA*');
    
    for i = 1 : n_sujetos % solo leera los archivos del numero de sujetos que se deseen!
        
        filetext = fileread(listing(i).name); %150 (volumen) x n_sujetos x N (rois)
        
        string = strsplit(filetext,' ');
        
        fila = ultimo;
        
        % sacando los valores del archivo leido
        %for k = 1 : tam_serietiempo
        for k = 1 : length(string)-1 % averiguar pq cuando 150 de longitud marca error de singleton
            
            matriz(fila, i) = str2num(cell2mat(string(k))); 
            
            fila = fila + 1; 
            
        end
        
    end
    
end


%% Calculando la conectividad funcional 

[f, no_sujetos] = size(matriz);

for subj = 1 : no_sujetos
    
    x = 1;
    
    inicio =  0;
    
    for roi = 1 : n_rois
        
        fin = tam_serietiempo; % numero total de volumenes                              %<---- Definir
        
        while inicio < f
            
            y = 1;
            
            i = 0;
            
            while i < f
                
                R = corrcoef(matriz(inicio+1 : fin, subj),matriz(i+1 : i+tam_serietiempo, subj)); %Pearson R (1,2) los primeros 150 por los siguientes 150, por cada sujeto
                
                Z(x, y, subj) = atanh(R(1,2)); %transformacion de Fisher
                
                i = i + tam_serietiempo;
                
                y = y + 1;
                
            end
            
            x = x + 1;
            
            inicio = inicio + tam_serietiempo;
            
            fin = fin + tam_serietiempo;
            
        end
        
    end
    
end



%% Generando Base de datos de NxN por cada sujeto

% Indice de inicio y fin de cada grupo
inicio_sujetos = 1;
fin_sujetos = n_sujetos;


for sujeto = inicio_sujetos : fin_sujetos
    
    paciente = triu(Z(:,:,sujeto));
    
    n = length(paciente);
    
    k = 1;
    
    f = 1;
    
    c = 2;
    
    % obteniendo valores arriba de la diagonal
    while f <= n-1
        
        while c <= n
            
            % valores z
            valores_z(k) = paciente(f,c);
            
            k = k + 1;
            
            c = c + 1;
            
        end
        
        c = f + 2;
        f = f + 1;
        
    end
    
    z_nodo(sujeto,1:length(valores_z)) = valores_z;
    
    valores_z = [];
    
    
end


%Matriz valores de conectividad funcional (Z)
z_nodo;
csvwrite(['z_nodos_ROIs_SCA10_',num2str(tam_serietiempo),'.csv'],z_nodo)





%% Obteniendo nombre de c/nodos
names = {'cerebello_left', 'cerebello_rigth', 'fusiform_cortex', 'middle_cerebellar', 'rigth_cerebral_cortex'};  % <--- definir

nodos= {};
i  = 1;

[sujetos,combinaciones] = size(z_nodo);

while i <= combinaciones % EL no. de posibles combinaciones entre los N ROIs para este estudio  % <--- definir
    
    
    inicio = 1;
    
    fin = n_rois;
    
    k = 1;
    
    for f = 1 : fin
        
        for c = inicio+k : fin
            
            nom_nodos(i) = strcat(names(f),' -Vs- ', names(c));
            
            i = i + 1;
            
        end
        
        k = k + 1;
    end

end

nom_nodos'
%csvwrite('combinacion_nodos_ROIs.csv',nom_nodos)







