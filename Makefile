DEBUG = 0
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.0

INSTALL_TARGET_PROCESSES = MobileSMS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MsgSwap

MsgSwap_FILES = MsgSwapFooter.x Tweak.x
MsgSwap_PRIVATE_FRAMEWORKS = ChatKit
MsgSwap_CFLAGS = -fobjc-arc -Wno-unguarded-availability-new # since can't use @available on Linux

include $(THEOS_MAKE_PATH)/tweak.mk
