#!/sbin/sh
# Copyright VillainROM 2011. All Rights Reserved
# cleanup from last time
[ -d /sdcard/vrtheme-backup ] && rm -r /sdcard/vrtheme-backup

# we need to first go through each file in the "app" folder, and for each one present, apply the modified theme to the APK
# let us copy each original APK here first. 
echo "Processing /system/priv-app/SystemUI"
busybox mkdir -p /sdcard/vrtheme-backup/system/priv-app/SystemUI/
busybox mkdir -p /sdcard/vrtheme/apply/system/priv-app/SystemUI/
cd /sdcard/vrtheme/system/priv-app/SystemUI/
for f in $(ls)
do
  echo "Processing $f"
  cp /system/priv-app/SystemUI/$f /sdcard/vrtheme/apply/system/priv-app/SystemUI/
  cp /system/priv-app/SystemUI/$f /sdcard/vrtheme-backup/system/priv-app/SystemUI/
done
echo "Backups done for SystemUI"

#
# for each of the system apps needing processed 
cd /sdcard/vrtheme/apply/system/priv-app/SystemUI/
for f in $(ls)
do
  echo "Working on $f"
  cd /sdcard/vrtheme/system/priv-app/SystemUI/$f/
  /sdcard/vrtheme/zip -r /sdcard/vrtheme/apply/system/priv-app/SystemUI/$f *
done
echo "Patched system files"


# and now time to zipalign
cd /sdcard/vrtheme/apply/system/priv-app/SystemUI/
busybox mkdir aligned
for f in $(ls)
do
  echo "Zipaligning $f"
  /sdcard/vrtheme/zipalign -f 4 $f ./aligned/$f
done

# time to now move each new app back to its original location
cd /sdcard/vrtheme/apply/system/priv-app/SystemUI/aligned/
cp * /system/priv-app/SystemUI
chmod 644 /system/priv-app/SystemUI/*
cd /sdcard/vrtheme/apply/system/app/aligned/
fi

# Do not remove the credits from this, it's called being a douche
echo "VillainTheme is done"
# we are all done now