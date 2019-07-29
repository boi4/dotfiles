#!/usr/bin/env bash

vm=$(VBoxManage list vms | awk '{ print $1 }' |tr -d \" | dmenu -i)

VBoxManage startvm "$vm"
