sudo cat /var/lib/jenkins/secrets/initialAdminPassword
pwd
cd /etc
ls
cd /var/lib/jenkins/workspace
ls
cd PetClinic
ls
cd target/
ls
yum install awscli
sudo yum install awscli
aws configure
pwd
ls
aws s3 cp ./spring-petclinic-2.1.0.BUILD-SNAPSHOT.war s3://provision-cf-tf/application/Petclinic.war --dryrun
aws s3 cp ./spring-petclinic-2.1.0.BUILD-SNAPSHOT.war s3://provision-cf-tf/application/Petclinic.war
exit
