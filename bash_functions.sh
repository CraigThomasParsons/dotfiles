#!/bin/sh

TERM_GREEN="\033[1;32m"
TERM_BLUE="\033[1;34m"
TERM_NC="\033[0m"

################################################################################
# Docker Build and Run
################################################################################
docker-build-and-run() {
    # Find the current folder name.
    result=${PWD##*/}
    
    # Take result and turn it into a lowercase version
    containername=${result,,}
    
    # Remove all vowels
    shrtnm=${result//[aeiouy]}
    
    # Make sure its lower case
    lcshrtnm="${shrtnm,,}"
    
    if [[ -z "$@" ]]; then
        echo "
          Usage:
              docker-build-and-run BUILD_ARGS [-- RUN_ARGS] [-- RUN_COMMAND]
          Examples:
              docker-build-and-run . -- npm run test
              docker-build-and-run --file ./Dockerfile . -- -v ~/volume:/var/volume -- node server.js
        "
        return
    fi
    
    # Extract the segments between the dashes:
    BEFORE_THE_DASHES=
    while (( "$#" )); do
        if [[ "$1" = "--" ]]; then
            shift
            break
        fi
        BEFORE_THE_DASHES="$BEFORE_THE_DASHES $1"
        shift
    done
    SEGMENT_1=$BEFORE_THE_DASHES
    
    BEFORE_THE_DASHES=
    while (( "$#" )); do
        if [[ "$1" = "--" ]]; then
            shift
            break
        echo "No PPA's to be removed"
        fi
        BEFORE_THE_DASHES="$BEFORE_THE_DASHES $1"
        shift
    done
    SEGMENT_2=$BEFORE_THE_DASHES
    
    SEGMENT_3=$@
    
    BUILD_ARGS=$SEGMENT_1
    RUN_ARGS=$SEGMENT_2
    RUN_COMMAND=$SEGMENT_3
    if [ -z "$RUN_COMMAND" ]; then
        RUN_COMMAND=$RUN_ARGS
        RUN_ARGS=
    fi
    
    TEMP_TAG=${lcshrtnm}
    
    #Make a option for creating a container by interactive # echo "docker run --rm -it $RUN_ARGS --label $lcshrtnm $lcshrtnm $RUN_COMMAND"
    
    printf "${TERM_GREEN}Building Docker container (${TERM_BLUE}docker build $BUILD_ARGS${TERM_GREEN})${TERM_NC}\n"
    
    docker build --tag ${lcshrtnm} $BUILD_ARGS
    printf "${TERM_GREEN}Running Docker container (${TERM_BLUE}docker run $RUN_ARGS $RUN_COMMAND${TERM_GREEN})${TERM_NC}\n"
    
    echo "docker run -d $RUN_COMMAND --name ${containername} ${lcshrtnm}"
    docker run -d $RUN_COMMAND --name ${containername} ${lcshrtnm}
}

################################################################################
# Alias for docker, adds extra parameters and functionality
# Was designed to simply allow me to create a docker container quickly from
# a Dockerfile
################################################################################
dkr() {
    # Find the current folder name.
    result=${PWD##*/}
    
    # Take result and turn it into a lowercase version
    containername=${result,,}
    
    # Remove all vowels
    shrtnm=${result//[aeiouy]}
    
    # Make sure its lower case, I use this for the tag name.
    lcshrtnm="${shrtnm,,}"
    
    if [[ -z "$@" ]]; then
        
        echo "dkr [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default
                           "C:\\Users\\dude\\.docker")
  -c, --context string     Name of the context to use to connect to the
                           daemon (overrides DOCKER_HOST env var and
                           default context set with "docker context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level
                           ("debug"|"info"|"warn"|"error"|"fatal")
                           (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default
                           "C:\\Users\\dude\\.docker\\ca.pem")
      --tlscert string     Path to TLS certificate file (default
                           "C:\\Users\\dude\\.docker\\cert.pem")
      --tlskey string      Path to TLS key file (default
                           "C:\\Users\\dude\\.docker\\key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Commands:
  up          docker build -t ${lcshrtnm} . && docker run -d --name ${containername} ${lcshrtnm}
  ls          List containers
  ll          List all containers (active or not).
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
        wait        Block until one or more containers stop, then print their exit codes "
        return
    fi
    
    case "$1" in
        "rebuild")
            # Destory the container first, before calling up.
            echo "docker rm -f $containername"
            docker rm -f ${containername}
            shift;
            docker-build-and-run --file ./Dockerfile . -- $@
        ;;
        "up")
            # Use it to build a new container with a tagname of the current folder.
            # Remove first parameter from $@ array.
            shift;
            docker-build-and-run --file ./Dockerfile . -- $@
        ;;
        "help")
            docker --help
        ;;
        "ls")
            docker ps
        ;;
        "ll")
            docker ps --all
        ;;
        *)
            echo "docker $@"
            docker $@
        ;;
    esac
}


#######################################################################################
# Runs a lint on modified files
#######################################################################################
phplint() {
    (
        cd $(git rev-parse --show-toplevel)
        if [ -n "$(git status --porcelain)" ]
        then
            find $(git status --porcelain | awk '{ print $2; }') -exec php -1 {} \;
        fi
    )
}

#######################################################################################
# Connect to work pc remotely.
#######################################################################################
workconnect() {
    #/sbin/ifconfig | grep DEVICE_NAME > /dev/null
    
    VPNUSER=secretusername
    VPNURL=myvpn.domain.com
    VPNGRP=domaingroupname
    
    sudo openvpn --mktun --dev tun1 && \
    sudo ifconfig tun1 up && \
    #sudo openconnect -s /etc/vpnc/vpnc-script $VPNURL --user=$VPNUSER --authgroup=$VPNGRP --interface=tun1
    
    #PASSWORD_FILE_PATH="$HOME/.openconnect"
    #sudo openconnect  -s /etc/vpnc/vpnc-script $VPNURL --user=$VPNUSER --interface=tun1 --background --pid-file=/home/adm/openconnect.pid
    sudo openconnect myvpn.somewhere.com --interface=tun1 --user dude.myvpn --background --pid-file=$HOME/openconnect.pid --reconnect-timeout 10000 --passwd-on-stdin < $PASSWORD_FILE_PATH
}

#######################################################################################
# Remote desktop into desktop computer
#######################################################################################
rdp() {
    path="$HOME/.local/share/remmina"
    #Sort list and then reverse
    filename=$(ls -l $path |  grep remmina -m1 --include=*.remmina | rev | cut -d' ' -f1 | rev)
    fullPathAndFilename="$path/$filename"
    remmina --connect="$fullPathAndFilename"
}

########################################################################################
# Restart everything you can to try to get the internet working again.
#######################################################################################
restarttheinternet() {
    nmcli radio wifi off && sleep 5 && nmcli radio wifi on
    sudo /etc/init.d/networking restart
}

##########################################################################################
# Bash function to remove annoying  404 missing repository issues
##########################################################################################
pparemove(){
    sudo rm /tmp/update.txt; tput setaf 6; echo "Initializing.. Please Wait"
    sudo apt-get update >> /tmp/update.txt 2>&1; awk '( /W:/ && /launchpad/ && /404/ ) { print substr($5,26) }' /tmp/update.txt > /tmp/awk.txt; awk -F '/' '{ print $1"/"$2 }' /tmp/awk.txt > /tmp/awk1.txt; sort -u /tmp/awk1.txt > /tmp/awk2.txt
    tput sgr0
    if [ -s /tmp/awk2.txt ]
    then
        tput setaf 1
        printf "PPA's going to be removed\n%s\n" "$(cat /tmp/awk2.txt)"
        tput sgr0
        while read -r line; do echo "sudo add-apt-repository -r ppa:$line"; done < /tmp/awk2.txt > out
        bash out
    else
        tput setaf 1
        echo "No PPA's to be removed"
        tput sgr0
    fi
}
