# NanoNodeScripts (used on Ubuntu 16.04)
Useful Scripts to setup and manage Representative nodes

Representative Node: [xrb_3msc38fyn67pgio16dj586pdrceahtn75qgnx7fy19wscixrc8dbb3abhbw6](http://http://nanorep.club/)


## updateContainer.sh
Script that will update your Nano Docker container to the latest version
### Parameters
| Flag  | Parameter | Description  |
| ----- |-----------| :------------ |
| -n    | {containerName} | the name of the docker container that will be updated |
| -u    |  | force the update, even if you had downloaded the latest version of the docker container before  |
 


### Example of how to use it
`sudo ./updateContainer.sh -n {containerName} -u`


### Set up a cronjob (every 30 minutes)

`$ sudo crontab -e`

Add the following line to the crontab job list:

`0,30 * * * * /home/{userName}/{pathToTheScript}/updateContainer.sh`

### Log files

Every new download is logged here : /var/log/cron_nano_docker_updates.txt

Every cron execution is logged here : /var/log/cron_nano_docker_no_updates.txt
