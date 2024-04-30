#!/bin/bash

echo "############### Step 1: Setting up the machine ###############"
MACHINE=ucm-imx8m-plus
export MACHINE

echo "############### Step 2: Removing and recreating the compulab-nxp-bsp directory ###############"
sudo rm -r compulab-nxp-bsp &&
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp

echo "############### Step 3: Creating local_manifests directory and copying the manifest file ###############"
mkdir -p .repo/local_manifests
cp ../scripts/meta-bsp-imx8mp.xml .repo/local_manifests/

echo "############### Step 4: Initializing and syncing the repo ###############"
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-mickledore -m imx-6.1.55-2.2.0.xml
repo sync

sleep 1

echo "############### Step 5: Setting up the build environment ###############"
source compulab-setup-env -b build-${MACHINE}

echo "############### Step 6: Adding DRAM_CONF to local.conf ###############"
sed -i '$ a DRAM_CONF = "d2d4"' ${BUILDDIR}/conf/local.conf

echo "############### Step 7: Syncing the repo again ###############"
cd ..
repo sync

#Machine needs to be set again :/
MACHINE=ucm-imx8m-plus
export MACHINE
echo "############### Step 8: Setting up the environment again ###############"
source setup-environment build-${MACHINE}

echo "############### Step 9: Building the image ###############"
bitbake -k imx-image-full