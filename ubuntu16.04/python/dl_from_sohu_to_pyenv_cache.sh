#!/bin/bash

# https://github.com/pyenv/pyenv/wiki/Common-build-problems
echo "On Debian stretch (and Ubuntu bionic), libssl-dev is OpenSSL 1.1.x, "
echo "but support for that was only added in Python 2.7.13, 3.5.3 and 3.6.0. "
echo "To install earlier versions, you need to replace libssl-dev with libssl1.0-dev. "
echo "This is being tracked in https://github.com/pyenv/pyenv/issues/945."

wget http://mirrors.sohu.com/python/$1/Python-$1.tar.xz -P ~/.pyenv/cache/