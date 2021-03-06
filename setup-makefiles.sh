#!/bin/bash

VENDOR=lge
DEVICE=jagnm
OUTDIR=vendor/$VENDOR/$DEVICE
MAKEFILE=../../../$OUTDIR/$DEVICE-vendor-blobs.mk
VENDOR_MAKEFILE=../../../$OUTDIR/$DEVICE-vendor.mk
COMMON_OUTDIR=vendor/$VENDOR/$COMMON_DEVICE
COMMON_MAKEFILE=../../../$COMMON_OUTDIR/$COMMON_DEVICE-vendor-blobs.mk
COMMON_VENDOR_MAKEFILE=../../../$COMMON_OUTDIR/$COMMON_DEVICE-vendor.mk
YEAR=`date +"%Y"`

(cat << EOF) > $MAKEFILE
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

#Prebuilt libraries that are needed to build open-source libraries

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`wc -l device-proprietary-files.txt | awk {'print $1'}`
DISM=`egrep -c '(^#|^$)' device-proprietary-files.txt`
COUNT=`expr $COUNT - $DISM`
for FILE in `egrep -v '(^#|^$)' device-proprietary-files.txt`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ] && [ -f ../$COMMON_DEVICE/proprietary-files.txt ]; then
    LINEEND=" \\"
  elif [ $COUNT = "0" ]; then
  LINEEND=""
  fi
  # Split the file from the destination (format is "file[:destination]")
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  if [[ ! "$FILE" =~ ^-.* ]]; then
    FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
    DEST=${PARSING_ARRAY[1]}
    if [ -n "$DEST" ]; then
        FILE=$DEST
    fi
    echo "    $OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
  fi
done

if [ -f ../$COMMON_DEVICE/proprietary-files.txt ]; then
LINEEND=" \\"
COUNT=`wc -l ../$COMMON_DEVICE/proprietary-files.txt | awk {'print $1'}`
DISM=`egrep -c '(^#|^$)' ../$COMMON_DEVICE/proprietary-files.txt`
COUNT=`expr $COUNT - $DISM`
for FILE in `egrep -v '(^#|^$)' ../$COMMON_DEVICE/proprietary-files.txt`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
  # Split the file from the destination (format is "file[:destination]")
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  if [[ ! "$FILE" =~ ^-.* ]]; then
    FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
    DEST=${PARSING_ARRAY[1]}
    if [ -n "$DEST" ]; then
        FILE=$DEST
    fi
    echo "    $OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
  fi
done
fi

(cat << EOF) > ../../../$OUTDIR/BoardConfigVendor.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh
USE_CAMERA_STUB := false
EOF

if [ -d ../../../$OUTDIR/proprietary/app ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/app/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/app/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/app/Android.mk
echo "# Prebuilt APKs" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$OUTDIR/proprietary/app/*.apk | wc -l`
for APK in `ls ../../../$OUTDIR/proprietary/app/*apk`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    apkname=`basename $APK`
    apkmodulename=`echo $apkname|sed -e 's/\.apk$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/app/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $apkmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $apkname
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $apkmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "" >> $VENDOR_MAKEFILE
echo "endif" >> ../../../$OUTDIR/proprietary/app/Android.mk
fi

if [ -d ../../../$OUTDIR/proprietary/framework ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/framework/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/framework/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/framework/Android.mk
echo "# Prebuilt jars" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$OUTDIR/proprietary/framework/*.jar | wc -l`
for JAR in `ls ../../../$OUTDIR/proprietary/framework/*jar`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    jarname=`basename $JAR`
    jarmodulename=`echo $jarname|sed -e 's/\.jar$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/framework/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $jarmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $jarname
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := \$(COMMON_JAVA_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $jarmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "" >> $VENDOR_MAKEFILE
echo "endif" >> ../../../$OUTDIR/proprietary/framework/Android.mk
fi

if [ -d ../../../$OUTDIR/proprietary/priv-app ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/priv-app/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/priv-app/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/priv-app/Android.mk
echo "# Prebuilt privileged APKs" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$OUTDIR/proprietary/priv-app/*.apk | wc -l`
for PRIVAPK in `ls ../../../$OUTDIR/proprietary/priv-app/*apk`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    privapkname=`basename $PRIVAPK`
    privmodulename=`echo $privapkname|sed -e 's/\.apk$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/priv-app/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $privmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $privapkname
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_CLASS := APPS
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $privmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "" >> $VENDOR_MAKEFILE
echo "endif" >> ../../../$OUTDIR/proprietary/priv-app/Android.mk
fi

LIBS=`cat device-proprietary-files.txt | grep '\-lib' | cut -d'-' -f2 | head -1`

if [ -f ../../../$OUTDIR/proprietary/$LIBS ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/lib/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/lib/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/lib/Android.mk
echo "# Prebuilt libs needed for compilation" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`cat device-proprietary-files.txt | grep '\-lib' | wc -l`
for LIB in `cat device-proprietary-files.txt | grep '\-lib' | cut -d'/' -f2`;do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    libname=`basename $LIB`
    libmodulename=`echo $libname|sed -e 's/\.so$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/lib/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $libmodulename
LOCAL_MODULE_OWNER := $VENDOR
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $libname
LOCAL_MODULE_PATH := \$(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include \$(BUILD_PREBUILT)

EOF

echo "    $libmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "" >> $VENDOR_MAKEFILE
echo "endif" >> ../../../$OUTDIR/proprietary/lib/Android.mk
fi

VENDORLIBS=`cat device-proprietary-files.txt | grep '\-vendor\/lib' | cut -d'-' -f2 | head -1`

if [ -f ../../../$OUTDIR/proprietary/$VENDORLIBS ]; then
(cat << EOF) > ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

echo "ifeq (\$(TARGET_DEVICE),$DEVICE)" >> ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
echo ""  >> ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
echo "# Prebuilt vendor/libs needed for compilation" >> $VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`cat device-proprietary-files.txt | grep '\-vendor\/lib' | wc -l`
for VENDORLIB in `cat device-proprietary-files.txt | grep '\-vendor\/lib' | cut -d'/' -f3`;do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    vendorlibname=`basename $VENDORLIB`
    vendorlibmodulename=`echo $vendorlibname|sed -e 's/\.so$//gi'`
    (cat << EOF) >> ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $vendorlibmodulename
LOCAL_MODULE_OWNER := $VENDOR
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $vendorlibname
LOCAL_MODULE_PATH := \$(TARGET_OUT_VENDOR_SHARED_LIBRARIES)
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include \$(BUILD_PREBUILT)

EOF

echo "    $vendorlibmodulename$LINEEND" >> $VENDOR_MAKEFILE
done
echo "endif" >> ../../../$OUTDIR/proprietary/vendor/lib/Android.mk
fi


# Start extraction of common files

if [ ! -z $COMMON_DEVICE ]; then
(cat << EOF) > $COMMON_MAKEFILE
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$COMMON_DEVICE/setup-makefiles.sh

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`wc -l ../$COMMON_DEVICE/common-proprietary-files.txt | awk {'print $1'}`
DISM=`egrep -c '(^#|^$)' ../$COMMON_DEVICE/common-proprietary-files.txt`
COUNT=`expr $COUNT - $DISM`
for FILE in `egrep -v '(^#|^$)' ../$COMMON_DEVICE/common-proprietary-files.txt`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
  # Split the file from the destination (format is "file[:destination]")
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  if [[ ! "$FILE" =~ ^-.* ]]; then
    FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
    DEST=${PARSING_ARRAY[1]}
    if [ -n "$DEST" ]; then
        FILE=$DEST
    fi
    echo "    $COMMON_OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $COMMON_MAKEFILE
  fi
done

(cat << EOF) > $COMMON_VENDOR_MAKEFILE
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$COMMON_DEVICE/setup-makefiles.sh

# Pick up overlay for features that depend on non-open-source files

\$(call inherit-product, vendor/$VENDOR/$COMMON_DEVICE/$COMMON_DEVICE-vendor-blobs.mk)

EOF

(cat << EOF) > ../../../$COMMON_OUTDIR/BoardConfigVendor.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$COMMON_DEVICE/setup-makefiles.sh
EOF

if [ -d ../../../$COMMON_OUTDIR/proprietary/app ]; then
(cat << EOF) > ../../../$COMMON_OUTDIR/proprietary/app/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$COMMON_DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

if [ ! -z $BOARD_VENDOR ]; then
  echo "ifeq (\$(BOARD_VENDOR),$BOARD_VENDOR)" >> ../../../$COMMON_OUTDIR/proprietary/app/Android.mk
fi
echo "ifeq (\$(TARGET_BOARD_PLATFORM),$TARGET_BOARD_PLATFORM)" >> ../../../$COMMON_OUTDIR/proprietary/app/Android.mk
echo ""  >> ../../../$COMMON_OUTDIR/proprietary/app/Android.mk
echo "# Prebuilt APKs" >> $COMMON_VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $COMMON_VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$COMMON_OUTDIR/proprietary/app/*.apk | wc -l`
for APK in `ls ../../../$COMMON_OUTDIR/proprietary/app/*apk`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    apkname=`basename $APK`
    apkmodulename=`echo $apkname|sed -e 's/\.apk$//gi'`
    (cat << EOF) >> ../../../$COMMON_OUTDIR/proprietary/app/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $apkmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $apkname
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $apkmodulename$LINEEND" >> $COMMON_VENDOR_MAKEFILE
done
echo "" >> $COMMON_VENDOR_MAKEFILE
echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/app/Android.mk
if [ ! -z $BOARD_VENDOR ]; then
  echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/app/Android.mk
fi
fi

if [ -d ../../../$COMMON_OUTDIR/proprietary/framework ]; then
(cat << EOF) > ../../../$COMMON_OUTDIR/proprietary/framework/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$COMMON_DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

if [ ! -z $BOARD_VENDOR ]; then
  echo "ifeq (\$(BOARD_VENDOR),$BOARD_VENDOR)" >> ../../../$COMMON_OUTDIR/proprietary/framework/Android.mk
fi
echo "ifeq (\$(TARGET_BOARD_PLATFORM),$TARGET_BOARD_PLATFORM)" >> ../../../$COMMON_OUTDIR/proprietary/framework/Android.mk
echo ""  >> ../../../$COMMON_OUTDIR/proprietary/framework/Android.mk
echo "# Prebuilt jars" >> $COMMON_VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $COMMON_VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$COMMON_OUTDIR/proprietary/framework/*.jar | wc -l`
for JAR in `ls ../../../$COMMON_OUTDIR/proprietary/framework/*jar`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    jarname=`basename $JAR`
    jarmodulename=`echo $jarname|sed -e 's/\.jar$//gi'`
    (cat << EOF) >> ../../../$COMMON_OUTDIR/proprietary/framework/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $jarmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $jarname
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := \$(COMMON_JAVA_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $jarmodulename$LINEEND" >> $COMMON_VENDOR_MAKEFILE
done
echo "" >> $COMMON_VENDOR_MAKEFILE
echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/framework/Android.mk
if [ ! -z $BOARD_VENDOR ]; then
  echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/framework/Android.mk
fi
fi

if [ -d ../../../$COMMON_OUTDIR/proprietary/priv-app ]; then
(cat << EOF) > ../../../$COMMON_OUTDIR/proprietary/priv-app/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$COMMON_DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

if [ ! -z $BOARD_VENDOR ]; then
  echo "ifeq (\$(BOARD_VENDOR),$BOARD_VENDOR)" >> ../../../$COMMON_OUTDIR/proprietary/priv-app/Android.mk
fi
echo "ifeq (\$(TARGET_BOARD_PLATFORM),$TARGET_BOARD_PLATFORM)" >> ../../../$COMMON_OUTDIR/proprietary/priv-app/Android.mk
echo ""  >> ../../../$COMMON_OUTDIR/proprietary/priv-app/Android.mk
echo "# Prebuilt privileged APKs" >> $COMMON_VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $COMMON_VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`ls -1 ../../../$COMMON_OUTDIR/proprietary/priv-app/*.apk | wc -l`
for PRIVAPK in `ls ../../../$COMMON_OUTDIR/proprietary/priv-app/*apk`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    privapkname=`basename $PRIVAPK`
    privmodulename=`echo $privapkname|sed -e 's/\.apk$//gi'`
    (cat << EOF) >> ../../../$COMMON_OUTDIR/proprietary/priv-app/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $privmodulename
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $privapkname
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_CLASS := APPS
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)

EOF

echo "    $privmodulename$LINEEND" >> $COMMON_VENDOR_MAKEFILE
done
echo "" >> $COMMON_VENDOR_MAKEFILE
echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/priv-app/Android.mk
if [ ! -z $BOARD_VENDOR ]; then
  echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/priv-app/Android.mk
fi
fi

LIBS=`cat ../$COMMON_DEVICE/common-proprietary-files.txt | grep '\-lib' | cut -d'-' -f2 | head -1`

if [ -f ../../../$COMMON_OUTDIR/proprietary/$LIBS ]; then
(cat << EOF) > ../../../$COMMON_OUTDIR/proprietary/lib/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$COMMON_DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

if [ ! -z $BOARD_VENDOR ]; then
  echo "ifeq (\$(BOARD_VENDOR),$BOARD_VENDOR)" >> ../../../$COMMON_OUTDIR/proprietary/lib/Android.mk
fi
echo "ifeq (\$(TARGET_BOARD_PLATFORM),$TARGET_BOARD_PLATFORM)" >> ../../../$COMMON_OUTDIR/proprietary/lib/Android.mk
echo ""  >> ../../../$COMMON_OUTDIR/proprietary/lib/Android.mk
echo "# Prebuilt libs needed for compilation" >> $COMMON_VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $COMMON_VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`cat ../$COMMON_DEVICE/common-proprietary-files.txt | grep '\-lib' | wc -l`
for LIB in `cat ../$COMMON_DEVICE/common-proprietary-files.txt | grep '\-lib' | cut -d'/' -f2`;do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    libname=`basename $LIB`
    libmodulename=`echo $libname|sed -e 's/\.so$//gi'`
    (cat << EOF) >> ../../../$COMMON_OUTDIR/proprietary/lib/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $libmodulename
LOCAL_MODULE_OWNER := $VENDOR
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $libname
LOCAL_MODULE_PATH := \$(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include \$(BUILD_PREBUILT)

EOF

echo "    $libmodulename$LINEEND" >> $COMMON_VENDOR_MAKEFILE
done
echo "" >> $COMMON_VENDOR_MAKEFILE
echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/lib/Android.mk
if [ ! -z $BOARD_VENDOR ]; then
  echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/lib/Android.mk
fi
fi

VENDORLIBS=`cat ../$COMMON_DEVICE/common-proprietary-files.txt | grep '\-vendor\/lib' | cut -d'-' -f2 | head -1`

if [ -f ../../../$COMMON_OUTDIR/proprietary/$VENDORLIBS ]; then
(cat << EOF) > ../../../$COMMON_OUTDIR/proprietary/vendor/lib/Android.mk
# Copyright (C) $YEAR The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$COMMON_DEVICE/setup-makefiles.sh

LOCAL_PATH := \$(call my-dir)

EOF

if [ ! -z $BOARD_VENDOR ]; then
  echo "ifeq (\$(BOARD_VENDOR),$BOARD_VENDOR)" >> ../../../$COMMON_OUTDIR/proprietary/vendor/lib/Android.mk
fi
echo "ifeq (\$(TARGET_BOARD_PLATFORM),$TARGET_BOARD_PLATFORM)" >> ../../../$COMMON_OUTDIR/proprietary/vendor/lib/Android.mk
echo ""  >> ../../../$COMMON_OUTDIR/proprietary/vendor/lib/Android.mk
echo "# Prebuilt vendor/libs needed for compilation" >> $COMMON_VENDOR_MAKEFILE
echo "PRODUCT_PACKAGES += \\" >> $COMMON_VENDOR_MAKEFILE

LINEEND=" \\"
COUNT=`cat ../$COMMON_DEVICE/common-proprietary-files.txt | grep '\-vendor\/lib' | wc -l`
for VENDORLIB in `cat ../$COMMON_DEVICE/common-proprietary-files.txt | grep '\-vendor\/lib' | cut -d'/' -f3`;do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
    vendorlibname=`basename $VENDORLIB`
    vendorlibmodulename=`echo $vendorlibname|sed -e 's/\.so$//gi'`
    (cat << EOF) >> ../../../$COMMON_OUTDIR/proprietary/vendor/lib/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $vendorlibmodulename
LOCAL_MODULE_OWNER := $VENDOR
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $vendorlibname
LOCAL_MODULE_PATH := \$(TARGET_OUT_VENDOR_SHARED_LIBRARIES)
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
include \$(BUILD_PREBUILT)

EOF

echo "    $vendorlibmodulename$LINEEND" >> $COMMON_VENDOR_MAKEFILE
done
echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/vendor/lib/Android.mk
if [ ! -z $BOARD_VENDOR ]; then
  echo "endif" >> ../../../$COMMON_OUTDIR/proprietary/vendor/lib/Android.mk
fi
fi

fi
