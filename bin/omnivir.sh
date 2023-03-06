#!/bin/bash
# Adjusted from Izaskun Mallona

usage(){
    echo ""
    echo "Usage: bash ""$(basename "$0")"""
    echo "OBS: Please read the README before running."
    echo " -a       Activate environment instead of installing"
    echo ""
}

while [ "$1" != "" ]; do
    case $1 in
        -a) ACTIVATE=true
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

mkdir -p ~/virtenvs ~/soft/python ~/omb
cd $_

# Install important dependency
apt-get install libbz2-dev

# Install python
wget https://www.python.org/ftp/python/3.9.2/Python-3.9.2.tgz
tar xzvf Python-3.9.2.tgz
cd Python-3.9.2

./configure prefix=~/soft/python/Python-3.9.2
make prefix=~/soft/python/Python-3.9.2
make install prefix=~/soft/python/Python-3.9.2

## not even exporting the PATH, here
~/soft/python/Python-3.9.2/bin/pip3 install virtualenv

## create virtualenv for omnibenchmark  ##################################################

cd ~/virtenvs

~/soft/python/Python-3.9.2/bin/virtualenv omb

## activate virtenv  #####################################################################

source ~/virtenvs/omb/bin/activate 

## dependencies

~/soft/python/Python-3.9.2/bin/pip3 install omnibenchmark==0.0.41
~/soft/python/Python-3.9.2/bin/pip3 install renku==1.10.0

cat "Exit environment with command 'deactivate'"
cat "Reactivate with command 'source ~/virtenvs/omb/bin/activate'"
cat "Run 'omnivir -a' to print the activation command"


