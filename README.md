Pasos:
1.- Hacer las ROIs esféricas con los comandos de FSL, y seguir los pasos del archivo EXCEL, "ROIs_comandos_FSL.xlsx", donde se ejecutan los comandos FSLMEANTS; 
los resultados se guardan en archivos TXT. Colocar todo en carpetas por separado, y el script del paso 2, 
va buscando dichos archivos por carpeta, para facilitar su lectura y orden.  
Usar las imágenes NifTI llamados "niftiDATA_Subject001_Condition**.nii.gz"; primero hay que convertir esos archivos *matc y *.mat a NifTI, desde Matlab usando: conn_matc2nii

2.- Una vez hecho el preprocesamiento desde CONN, ejecutar el archivo "get_time_series_ROIs.m", que leerá los archivos TXT. Luego, 
va a generar los Z-values (los guarda en un archivo CSV). Se colocan en la carpeta «Results» de CONN, como se puede observar en la imagen.

![Screen Shot 2024-03-18 at 22 36 53](https://github.com/jokasta57/ROIs_rsfMRI/assets/16157859/fa6f34e4-019c-424b-ad56-ba863f0fadfc)


3.- Ejecutar el "correlaciones_IED_conectividad_funcional_v3.m"; para el cálculo de Spearman de los Z-values y alguna prueba cognitiva, en este caso IED de CANTAB, controlando por la edad.
