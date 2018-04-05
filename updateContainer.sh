dockerName=$(docker ps -a --format "{{.Image}}\t{{.Names}}" | grep "nanocurrency/nano" | awk '{ print $2}')
flgUpdate=false
currentDate=$(date +"%d.%m.%Y %H:%M:%S")
while getopts "n:u" OPTION
do
        case $OPTION in
                n)
                        printf "ContainerName set to $OPTARG"
                        dockerName=$OPTARG
                        ;;
                u)
                        printf "Enabled update forcefully"
                        flgUpdate=true
                        ;;
                \?)
                        printf "[-n {dockerConatinerName}] : update this container if outdated \n[-u] : force update and remove old container\n"
                        exit
                        ;;
        esac
done
#echo "DockerName : $dockerName \n Force Update: $forceUpdate"

currentDockerId=$(docker ps -a --filter "name=$dockerName" -q | xargs)
if  docker pull nanocurrency/nano | grep -q 'Image is up to date' ;
        then
         echo "No updates available for $dockerName (Container Id: $currentDockerId)"
        else
         flgUpdate=true
fi

if $flgUpdate -eq true ;
        then
         echo "Docker will be updated..."
          docker stop $currentDockerId
          docker rm $currentDockerId
          docker run -d -p 7075:7075/udp -p 7075:7075 -p [::1]:7076:7076 -v /home/nanonode/:/root --name $dockerName --restart unless-stopped nanocurrency/nano
          echo "$currentDate Docker Container ($dockerName) updated" >> /var/log/cron_nano_docker_updates.txt
else
          echo "$currentDate most recent version already installed" >> /var/log/cron_nano_docker_no_updates.txt
fi
exit 0
