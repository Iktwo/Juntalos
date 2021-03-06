QT += qml quick widgets svg

android {
    QT += androidextras gui-private
}

TEMPLATE = app

SOURCES += \
    src/main.cpp \
    src/uivalues.cpp

HEADERS += \
    src/uivalues.h

OTHER_FILES += \
    qml/*.qml \
    android/AndroidManifest.xml \
    android/src/com/iktwo/juntalos/Juntalos.java

RESOURCES += resources.qrc

include(deployment.pri)

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
