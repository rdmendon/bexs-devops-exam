#!/bin/bash
#preparando a maquina
echo "Fazendo update, instalando docker,git e dando permissões necessárias"
sudo yum update -y
sudo yum install -y docker
sudo yum install git -y
sudo usermod -a -G docker ec2-user
sudo service docker start
sudo chkconfig docker on
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose



#baixando app
echo "Baixando a aplicação através do github e automatizando a criação e execução da aplicação"
cd /home/ec2-user
git clone https://bitbucket.org/bexstech/bexs-devops-exam.git
git clone https://github.com/rdmendon/bexs-devops-exam_aux
cd bexs-devops-exam_aux
mv Dockerfile_fe ../bexs-devops-exam/frontend/src/frontend/Dockerfile
sudo chmod 777 docker-compose.yml
mv docker-compose.yml docker-compose-start.sh ../bexs-devops-exam/

sudo chmod 777 ../bexs-devops-exam/frontend/src/frontend/*
mv Dockerfile_be ../bexs-devops-exam/backend/src/backend/Dockerfile
sudo chmod 777 ../bexs-devops-exam/backend/src/backend/*
cd ../bexs-devops-exam/frontend/src/frontend/
docker build --tag richard_fe:1.0 .
cd ../bexs-devops-exam/backend/src/backend/
docker build --tag richard_be:1.0 .
cd /home/ec2-user/bexs-devops-exam
sudo ./docker-compose-start.sh
sudo docker-compose up



