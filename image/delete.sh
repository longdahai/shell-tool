docker rmi `docker images|awk '{print $3}'|tail -n +2`
