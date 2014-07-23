#!/bin/bash

# This script will download and install uboot

# usage message
usage() {
    echo "
Usage: `basename ${0}` <options>

   --target=TARGET  - target board
                      [${TARGETS}]
   --media=DEVICE   - media device file (/dev/[sdX|mmcblkX])
    -y              - Assumes yes, will not wait for confirmation
   --version        - Display version and exit

Example: `basename ${0}` --target=panda --media=/dev/mmcblk0"
}

# check the args
while [ $# -gt 0 ]; do
    case $1 in
        --debug)
            set -x
            ;;
        -h|--help)
            usage
            ;;
        --target*)
            if echo $1 | grep '=' >/dev/null ; then
                TARGET=`echo $1 | sed 's/^--target=//'`
            else
                TARGET=$2
                shift
            fi
            ;;
        --media*)
            if echo $1 | grep '=' >/dev/null ; then
                MEDIA=`echo $1 | sed 's/^--media=//'`
            else
                MEDIA=$2
                shift
            fi
            ;;
        --version)
            echo "`basename ${0}`-"$VERSION""
            exit 0
            ;;
        -y)
            NOASK=1
            ;;
        *)
            echo "`basename ${0}`: Error - ${1}"
            usage
            exit 1
            ;;
        esac
    shift
done

DIR=`dirname $0`
BOARDDIR=boards.d
TARGETS=`ls -1 ${DIR}/${BOARDDIR}`
TARGETS=`echo ${TARGETS} | sed -e 's/[[:space:]]/|/g'`

# check if media is a block device
if [[ ! -b $MEDIA ]] ; then
        echo "Missing media"
        usage
        exit 1
fi

if [[ $TARGET = '' ]] ; then
        echo "Missing target"
        usage
        exit 1
fi


sudo rm -rf /tmp/root &> /dev/null
mkdir /tmp/root

# get the latest uboot
pushd /tmp/root &> /dev/null
koji download-build --arch=armv7hl --latestfrom=f21 uboot-tools
#wget http://192.168.0.80/linux/development/rawhide/armhfp/os/u/uboot-images-armv7*
# unpack uboot
rpm2cpio uboot-images*.rpm | cpio -idv &> /dev/null
popd &> /dev/null

# determine uboot and write to disk 
if [ "$TARGET" = "" ]; then
        echo "= No U-boot will be written."
        TARGET="Mystery Board"
else
        . "${DIR}/${BOARDDIR}/${TARGET}"
fi

# mount boot partition and edit extlinux.conf to add fdtdir 
sudo rm -rf /tmp/boot &> /dev/null
mkdir /tmp/boot
sudo mount "$MEDIA"1 /tmp/boot &> /dev/null
KERVER=`cat /tmp/boot/extlinux/extlinux.conf | grep "default Fedora" | awk '{print $3}' | sed 's/(//g;s/)//g'`
echo "$KERVER"
sudo sed -i '/append /a       fdtdir   \/dtb-'$KERVER'\//' /tmp/boot/extlinux/extlinux.conf

echo "= Complete!"
