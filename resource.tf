resource "aws_instance" "terraform" {
  ami           = var.ec2_ami_id
  instance_type = var.aws_instance_type
  subnet_id = var.subnet_id
  key_name = var.aws_key_pair
  

  user_data = <<-EOF
            #!/bin/bash
             #docker install 
            yum update -y 
            #yum install docker-ce docker-ce-cli containerd.io -y
            amazon-linux-extras install docker -y

            #Add the ec2-user to the docker group
            usermod -a -G docker ec2-user

            #docker compose 
            curl -s -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

            #make docker compose executbale and create link 
            chmod +x /usr/local/bin/docker-compose
            ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

            #create partition 
            mkfs.xfs /dev/sdb
            systemctl stop docker 
            mkdir /var/lib/docker/volumes
            echo "/dev/sdb /var/lib/docker/volumes  xfs  defaults,noatime  1  1" >> /etc/fstab
            mount -a 

            #starting and enabling docker 
            systemctl enable docker 
            systemctl start docker 

            #setting system paramters 
            echo "vm.max_map_count=524288" >> /etc/sysctl.d/99-sysctl.conf
            echo "fs.file-max=131072" >> /etc/sysctl.d/99-sysctl.conf
            sysctl -p

            mkdir /root/docker-sonarqube 
            
            #lets start the contains 
            cd /root/docker-sonarqube && docker-compose up -d
          else 
             #docker install 
              yum update -y 
              #yum install docker-ce docker-ce-cli containerd.io -y
              amazon-linux-extras install docker -y
              #Add the ec2-user to the docker group
              usermod -a -G docker ec2-user

              #setting system paramters 
              echo "vm.max_map_count=524288" >> /etc/sysctl.d/99-sysctl.conf
              echo "fs.file-max=131072" >> /etc/sysctl.d/99-sysctl.conf
              sysctl -p

              #starting and enabling docker 
              systemctl enable docker 
              systemctl start docker

              #docker volumes crearting
              docker volume create --name sonarqube_data
              docker volume create --name sonarqube_logs
              docker volume create --name sonarqube_extensions
              #running docker
              docker run  -d  --ulimit nofile=8192:8192 --ulimit nproc=8192 -p 9000:9000  --restart always  -v sonarqube_data:/opt/sonarqube/data   -v sonarqube_extensions:/opt/sonarqube/extensions  -v sonarqube_logs:/opt/sonarqube/logs  sonarqube 
              EOF













    tags = {
                  Name = "terraform_Sonar_Qube"
                  
                  }
				  
				  
				  
				  
				  
}
