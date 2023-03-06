#!/bin/bash
# Adjusted from Izaskun Mallona

usage(){
    echo ""
    echo "Usage: bash ""$(basename "$0")"""
    echo "OBS: Please read the README before running."
    echo ""
}

while [ "$1" != "" ]; do
    case $1 in
        -h | --help )          usage
                               exit
                               ;;
        * )                    usage
                               exit 1
    esac
    shift
done

## start here if you'd like to get a renku+omb virtual environment      #################
##    compiling your own python   #######################################################


## compile python 3.9.2  ################################################################

mkdir -p ~/virtenvs ~/soft/python ~/omb
cd $_

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
~/soft/python/Python-3.9.2/bin/python3 -m pip install --user pipx
pipx ensurepath
pipx install --force renku==0.10.0
