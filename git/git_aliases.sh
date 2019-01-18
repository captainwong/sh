#!/bin/bash

git config --global alias.st 'status'
git config --global alias.aa 'add --all'
git config --global alias.cm 'commit -m'
git config --global alias.cb 'checkout -b'
git config --global alias.last 'log -1'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.po 'push origin master'
git config credential.helper 'cache --timeout=3600'
