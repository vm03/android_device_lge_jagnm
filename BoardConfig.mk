#
# Copyright (C) 2014 The CyanogenMod Project
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
#


-include device/lge/g3s-common/BoardConfigCommon.mk

# Inline kernel building
BOARD_CUSTOM_BOOTIMG_MK := device/lge/jagnm/mkbootimg.mk
TARGET_KERNEL_CONFIG := jagnm_global_com_defconfig

# Nfc
BOARD_NFC_CHIPSET := pn547

# inherit from the proprietary version
-include vendor/lge/jagnm/BoardConfigVendor.mk
