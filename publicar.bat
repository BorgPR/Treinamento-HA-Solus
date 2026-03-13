@echo off
color 0A
echo ==================================================
echo      PUBLICACAO DE ARQUIVOS - SOLUS HA
echo ==================================================
echo.
echo Iniciando copia para o servidor de hospedagem...
echo Destino: \\172.16.80.15\WebTemp\infra\
echo.

copy /Y "index.html" "\\172.16.80.15\WebTemp\infra\"
copy /Y "visaogeral.html" "\\172.16.80.15\WebTemp\infra\"
copy /Y "glusterfs.html" "\\172.16.80.15\WebTemp\infra\"
copy /Y "Treinamento_Final_HA.html" "\\172.16.80.15\WebTemp\infra\"

echo.
echo ==================================================
echo PUBLICACAO CONCLUIDA COM SUCESSO!
echo ==================================================
echo Pressione qualquer tecla para fechar esta janela...
pause >nul
