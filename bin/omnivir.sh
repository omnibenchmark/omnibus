#!/bin/bash
# Adjusted from Izaskun Mallona

usage(){
    echo ""
    echo "Usage: bash ""$(basename "$0")"""
    echo "OBS: Please read the README before running."
    echo " -a       Activate environment instead of installing"
    echo " -l       Install locally instead of in virtualenv"
    echo ""
}

while [ "$1" != "" ]; do
    case $1 in
        -a) ACTIVATE=true
                                ;;
        -l) LOCAL=true
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ $ACTIVATE ]; then
    echo "source ~/virtenvs/omb/bin/activate"
    exit
fi
## start here if you'd like to get a renku+omb virtual environment      #################
##    compiling your own python   #######################################################


## compile python 3.9.2  ################################################################
if [ $LOCAL = false ]; then
    mkdir -p ~/virtenvs
fi

mkdir -p ~/soft/python ~/omb
cd ~/soft/python

# Install important dependency
apt-get install --no-install-recommends libssl-dev libbz2-dev libncurses5-dev  libreadline-dev libgdbm-dev libnss3-dev libffi-dev libsqlite3-dev

# Install python
wget https://www.python.org/ftp/python/3.9.2/Python-3.9.2.tgz
tar xzvf Python-3.9.2.tgz
cd Python-3.9.2



## Install and run virtual environment
if [ $LOCAL = false ]; then

    ./configure prefix=$prefix
    make prefix=~/soft/python/Python-3.9.2
    make install prefix=~/soft/python/Python-3.9.2

    ~/soft/python/Python-3.9.2/bin/pip3 install virtualenv

    ## create virtualenv for omnibenchmark  ##################################################

    cd ~/virtenvs

    ~/soft/python/Python-3.9.2/bin/virtualenv omb

    ## activate virtenv  #####################################################################

    source ~/virtenvs/omb/bin/activate

    ## dependencies 
    ~/soft/python/Python-3.9.2/bin/pip3 install omnibenchmark==0.0.41
    ~/soft/python/Python-3.9.2/bin/pip3 install --use-feature=2020-resolver renku==1.10.0

else
    ## Compile python3.9.2
    ./configure
    make
    make install

    ## dependencies
    pip3 install omnibenchmark==0.0.41
    pip3 install --use-feature=2020-resolver renku==1.10.0
fi

cd ~/omb

echo "An '~/omb' directory has been created to store your benchmarks"



if [ $LOCAL = false ]; then
    cat "Exit environment with command 'deactivate'"
    cat "Reactivate with command 'source ~/virtenvs/omb/bin/activate'"
    cat "Run './bin/omnivir.sh -a' to print the activation command"
fi


