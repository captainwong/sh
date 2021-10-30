#/bin/bash

ver=$1
wget https://npm.taobao.org/mirrors/python/$ver/Python-$ver.tar.xz -P ~/.pyenv/cache/ && pyenv install $ver
