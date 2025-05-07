#!/bin/bash
start_time=$(date +%s)
ssh -i ~/.ssh/id_rsa ubuntu@64.181.178.127 << 'EOF'
cd ~/Empire_Of_Azeitanaro || exit
git pull
sudo cp -r appweb/* /var/www/html/
EOF

if [ $? -ne 0 ]; then
  echo "Erro: Não foi possível acessar a VM via SSH."
  exit 1
fi

end_time=$(date +%s)
duration=$((end_time - start_time))

echo "Deploy concluído com sucesso!"
echo "Time: ${duration}s"
