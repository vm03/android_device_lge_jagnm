# Boot animation
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1280

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/lge/g3s-common/device.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_DEVICE := jagnm
PRODUCT_RELEASE_NAME := LG G3s
PRODUCT_NAME := cm_jagnm
PRODUCT_BRAND := LG
PRODUCT_MODEL := G3s
PRODUCT_MANUFACTURER := LGE

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=jagnm_global_com \
    BUILD_FINGERPRINT=lge/jagnm_global_com/jagnm:5.1.1/LMY48M/2167285:user/release-keys \
    PRIVATE_BUILD_DESC="jagnm_global_com-user 5.0.1 5.1.1 LMY48M 2167285 release-keys"

$(call inherit-product, vendor/lge/jagnm/jagnm-vendor.mk)
