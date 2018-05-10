#Set Default Values
currentDate=$(date +"%d.%m.%Y %H:%M:%S")
flgUpdate=false
dockerImage=nanocurrency/nano
dockerName="nanoNode"
nanoFolderPath=~

#overwrite Default from script input flags
while getopts "n:ump:" OPTION
do
        case $OPTION in
                n)
                        printf "ContainerName set to $OPTARG \n"
                        dockerName=$OPTARG
                        ;;
                u)
                        printf "Enabled update forcefully \n"
                        flgUpdate=true
                        ;;
                m)
                        printf "get master branch instead of official release \n"
                        dockerImage=nanocurrency/nano:master
                        ;;
                p)
                        printf "set custom path to $OPTARG \n"
                        nanoFolderPath=$OPTARG
                        ;;
                \?)
                        printf "[-n {dockerConatinerName}] : update this container if outdated \n[-u] : force update and remove old container\n"
                        exit
                        ;;
        esac
done
##Count docker containers with a nano instance "nanocurrency/nano..."
#containerCount=$(docker ps | grep "nanocurrency/nano" | awk '{ print $1 }' | wc -l)

if docker pull $dockerImage | grep -q 'Image is up to date' ; then
          echo "No updates available for $dockerName (Container Id: $dockerId)\n"
         else
          flgUpdate=true
fi
if $flgUpdate -eq true ;
        then
         echo "Docker will be updated..."
                 for containerId in $(docker ps | grep "nanocurrency/nano" | awk '{ print $1 }'); do
                        dockerName=$(docker ps -a --format "{{.Image}}\t{{.Names}}" | grep $dockerImage | awk '{ print $2}')
                        docker stop $containerId
                        docker rm $containerId
                        echo "$containerId Removed"
                 done
         if ! docker run -d -p 7075:7075/udp -p 7075:7075 -p [::1]:7076:7076 -v $nanoFolderPath:/root --name $dockerName --restart unless-stopped $dockerImage ; then
              docker run -d -p 7075:7075/udp -p 7075:7075 -p 127.0.0.1:7076:7076 -v $nanoFolderPath:/root --name $dockerName --restart unless-stopped $dockerImage
          fi
          echo "$currentDate Docker Container ($dockerName) updated with Image ($dockerImage)" >> /var/log/cron_nano_docker_updates.txt else
          echo "$currentDate most recent version already installed" >> /var/log/cron_nano_docker_no_updates.txt
fi
exit 0
