#!/bin/zsh

# android studio
# alias list_avd_devices="ls /home/khalil/.android/avd"
# alias launch_avd_device='/home/khalil/Android/Sdk/emulator/emulator -avd Pixel_XL_API_31 -writable-system '
# alias androidStudio="/home/khalil/android-studio/bin/studio"
alias adb_root="adb shell setprop persist.sys.root_access 3 && adb root"
alias list_android_devices="gmtool admin list"
alias launch_android_device="/opt/genymotion/player  --vm-name 'Samsung Galaxy S23'"
