#!/usr/bin/env bash

set -eux

base="$HOME/Programs/qemu"
# Parameters.
id=ubuntu-16.04.6-server-amd64
disk_img="$base/disks/${id}.img.qcow2"
disk_img_snapshot="$base/snapshots/${id}.snapshot.qcow2"
iso="$base/isos/${id}.iso"


# Go through installer manually.
if [ ! -f "$disk_img" ]; then
  qemu-img create -f qcow2 "$disk_img" 1T
  qemu-system-x86_64 \
    -cdrom "$iso" \
    -drive "file=${disk_img},format=qcow2" \
    -enable-kvm \
    -m 2G \
    -smp 2 \
  ;
fi

# Snapshot the installation.
if [ ! -f "$disk_img_snapshot" ]; then
  qemu-img \
    create \
    -b "$disk_img" \
    -f qcow2 \
    "$disk_img_snapshot" \
  ;
fi

# Run the installed image.
qemu-system-x86_64 \
  -drive "file=${disk_img_snapshot},format=qcow2" \
  -net user,hostfwd=tcp::10022-:22 \
  -net nic \
  -cpu qemu64 \
  -enable-kvm \
  -m 2G \
  -soundhw hda \
  -vga virtio \
  -s \
  "$@" \
;
