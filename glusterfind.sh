#!/bin/bash
SESSION=$(glusterfind list --session backup | awk 'NR >= 3 {print $3}')
TIME=$(glusterfind list --session backup | awk 'NR >= 3 {print $4}' | tr -d ':')

echo "# Sessão atual:"
glusterfind list --session backup

echo " "

echo "Rodando o comando PRE para gerar lista de arquivos modificados de $SESSION-$TIME até $(date +%Y%m%d-%H%M%S)"
glusterfind pre backup volume /bricks/vol_dados/glusterfind/glusterfind_backup_$SESSION-$TIME.txt --output-prefix=/bricks/vol_dados/brick/

echo " "

echo "Gerando lista customizada para netbackup em /bricks/vol_dados/netbackup/glusterfind_backup_$SESSION-$TIME.txt"

cat /bricks/vol_dados/glusterfind/glusterfind_backup_$SESSION-$TIME.txt | awk '{print $2}' | awk 'length>80' > /bricks/vol_dados/netbackup/glusterfind_backup_$SESSION-$TIME.txt
echo "/bricks/vol_dados/netbackup/glusterfind_backup_$SESSION-$TIME.txt" >> /bricks/vol_dados/netbackup/glusterfind_backup_$SESSION-$TIME.txt

echo " "

echo "Atualizando a sessão usando comando POST"
glusterfind post backup vol_dados

echo " "

echo "# Sessão atual:"
glusterfind list --session backup
