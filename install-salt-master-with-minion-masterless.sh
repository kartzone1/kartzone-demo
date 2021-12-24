#!/bin/bash
########################
# Program Name: install-salt-master-with-minion-masterless.sh
# Author: Kartnico
# Description: Install a Salt Master with a Salt Minion Masterless
#------
# Change log:
# Date		Programmer	Description
# 12.24.2021	kartnico	initial release
########################

# Variables
requiredpackages="git vim salt-minion sudo curl"
tmpsaltpillarpath="/srv/pillar"
saltpath="/srv/salt"
saltstatespath="/srv/salt/states"
saltpillarpath="/srv/salt/pillar"
saltpillarslspath="https://raw.githubusercontent.com/kartzone1/kartzone-demo/main/salt.sls"
saltpillarrepourl="https://github.com/kartzone1/kartzone-demo.git"

# Need to be root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# Script Core
echo "==> Update system"
apt-get update && apt-get -y upgrade

echo "==> Install packages"
apt-get -y install $requiredpackages

echo "==> Manage Salt conf file to Salt Masterless"
sed -i 's/\#file_client: remote/file_client: local/g' /etc/salt/minion
service salt-minion restart

echo "==> Create directories for Salt Masterless"
mkdir -p $saltpath $tmpsaltpillarpath
chmod 755 $saltpath
chmod 750 $tmpsaltpillarpath

echo "==> Clone official Salt formula"
cd $saltpath
git clone https://github.com/saltstack-formulas/salt-formula.git
mv $saltpath/salt-formula/salt $saltpath/
rm -rf $saltpath/salt-formula

echo "==> Configure states top.sls"
echo "base:
  '*':
    - salt.master
    - salt.formulas
" | tee $saltpath/top.sls

echo "==> Configure temp pillars"
rm -f $tmpsaltpillarpath/salt.sls
curl -o $tmpsaltpillarpath/salt.sls -s -O $saltpillarslspath
echo "base:
  '*':
    - salt
" | tee $tmpsaltpillarpath/top.sls

echo "==> Prepare pillar for Salt Master"
rm -rf $saltpillarpath
mkdir -p $saltpillarpath
git clone $saltpillarrepourl $saltpillarpath/

echo "==> Install Salt Master with Salt Masterless"
salt-call --local state.apply

echo "==> Clean Salt masterless files"
rm -rf $saltpath/salt $saltpath/top.sls $tmpsaltpillarpath
mkdir -p /etc/salt/gpgkeys $saltstatespath/win
chown -R salt /etc/salt /var/cache/salt /var/log/salt /var/run/salt $saltstatespath/win
chmod 755 $saltstatespath
chmod 750 $saltpillarpath
