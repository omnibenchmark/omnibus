#!/bin/bash
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

~/soft/python3/Python-3.9.2/bin/virtualenv omb

## activate virtenv  #####################################################################

source ~/virtenvs/omb/bin/activate 

## dependencies; here without pinning the version

pip3 install omnibenchmark==0.0.41
pip3 install renku==1.10.0
