% 30- nov 21 (FUNCIONA SOLO PARA LOS 18 CONTROLES CON CANTAB, DE ESTE EXPERIMENTO)
%
% ENTRADA: solo actualizar la ruta de la matriz 4D de
% (resultsROI_Condition001.mat), de la carpeta de resultados de primer
% nivel; al ejecutarlo, analizar? las 8 redes can?nicas segun CONN. 
%     p. ej. load('/Users/gus/Documents/MATLAB/conectomas_Huntington/conn_project01/results/firstlevel/prueba_03/resultsROI_Condition001.mat');
%
%
%Tambien definir el numero de sujetos: controles y pacientes.
%
% P. ej.
%    inicio_sujetos = 1;
%    fin_sujetos = 40;
%
% y en los boxplots:
%     aux(1,:) = media_conectividad(i,21:40); %controles
%     aux(2,:) = media_conectividad(i,1:20); %pacientes
%
%
%SALIDA: Conectividad promedio entre las 8 redes canonicas (8 redes canonicas x No.sujetos)
% y matriz de conectividad de combinaciones de todos nodos (No.sujetos x 55 nodos);
% ademas, boxplot, media_conectividad.csv, z_nodos.csv y ?nombre de combinaciones entre nodos?

% Gustavo P. R

clc, clear


load('/Users/gus/Documents/MATLAB/Conn_SCA10/conn_sca10_v2/results/firstlevel/SBC_01/resultsROI_Condition001.mat')    % <--- definir


% Indice de inicio y fin de cada grupo
inicio_sujetos = 1;                                                         % <--- definir
fin_sujetos = 52;                                                           % <--- definir

% INDICE DE LAS REDES: p. ej. DMN inicia en 1 y finaliza en 4
redes = [1,4,5,7,8,11,12,18,19,22,23,26,27,30,31,32];


%% pruebas: para obtener promedio de conectividad
z_nodo = [];

aux = [];

for sujeto = inicio_sujetos : fin_sujetos
    
    i = 1;
    
    i_nodo  = 1;
    
    while i <= length(redes)
        
        % INDICE DE LAS REDES: p. ej. DMN inicia en 1 y finaliza en 4
        inicio = redes(i);
        fin = redes(i+1);
        
        
        paciente = triu(Z(inicio:fin, inicio:fin, sujeto));
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
        
        % guardando conectividad por nodos (valores_z)
        
        aux = [aux valores_z(:)'];
        
        
        media_conectividad(i_nodo, sujeto) = mean(valores_z); %valores z, contiene los valores de arriba de la diagonal
        
        i_nodo = i_nodo + 1;
        
        valores_z = [];
        
        z_nodo(sujeto,1:length(aux)) = aux';
        
        i = i + 2; %i-redes
        
    end
    
    aux = [];
    
end

%paciente
z_nodo
%csvwrite('z_nodos.csv',z_nodo)

media_conectividad'
csvwrite('media_conectividad_redescanonicasSCA10.csv',media_conectividad)



%% Obteniendo nombre de las combinaciones de c/nodos

% nodos= {};
% i  = 1;
% i_nodo = 1;
% 
% while i <= length(z_nodo)
%     
%     % INDICE DE LAS REDES: p. ej. DMN inicia en 1 y finaliza en 4
%     inicio = redes(i_nodo);
%     fin = redes(i_nodo+1);
%     
%     k = 1;
%     
%     for f = inicio : fin
%         
%         for c = inicio+k : fin
%             
%             nom_nodos(i) = strcat(names(f),' -Vs- ', names(c));
%             
%             i = i + 1;
%         
%         end
%         
%         k = k + 1;
%     end
%     
%     i_nodo = i_nodo + 2; %i-redes
%     
% end
% 
% nom_nodos'
%csvwrite('combinacion_nodos.csv',nom_nodos)



%% Analisis estadistico - Promedio de Actividad por red
aux = [];

redes_HD = {'DMN', 'SensoriMotor', 'Visual', 'Salience', 'DorsalAttention', 'FrontoPariental', 'Lenguage', 'Cerebellar'};

groups = {'Ctrl', 'SCA10'};

inic_ctrl = 27;
fin_ctrl = 52;
inic_pat = 1;
fin_pat = 26;

for i = 1 : (length(redes)/2) %recorriendo las 8 redes
    
    % t-test
    [h,p,ci,stats] = ttest2(media_conectividad(i,inic_pat:fin_pat),media_conectividad(i,inic_ctrl:fin_ctrl));
    
    p_sig(i) = p;
    
    %plot
    aux(1,:) = media_conectividad(i,inic_ctrl:fin_ctrl); %controles                      % <--- definir
    aux(2,:) = media_conectividad(i,inic_pat:fin_pat); %pacientes                       % <--- definir
    
    
    subplot(2,((length(redes)/2)/2),i),boxplot(aux', groups,'Notch','on'), ylabel('Conectividad Promedio'),title([redes_HD(i),' p-value = ', num2str(p_sig(i))]),
    hold on
    scatter(ones(size(media_conectividad(i,inic_ctrl:fin_ctrl))).*(1+(rand(size(media_conectividad(i,inic_ctrl:fin_ctrl)))-0.5)/10),media_conectividad(i,inic_ctrl:fin_ctrl),'r','filled')
    hold on
    scatter(ones(size(media_conectividad(i,inic_ctrl:fin_ctrl))).*(2+(rand(size(media_conectividad(i,inic_pat:fin_pat)))-0.5)/10),media_conectividad(i,inic_pat:fin_pat),'g','filled')

end



