#-------------------------------------------------
# L103 关节电机调试上位机 (CH32L103 + DRV8313 FOC)
#   UART 控制台 + CAN (沁恒 CH9433 EVB 裸帧 / 达妙 DM-USB2CAN 30 字节信封)
#   命令语义出自:
#     固件仓库\
#       CH32L103_DRV8313_FOC_CAN\命令表与使用说明_UART与CAN_2026-09-28.md
#-------------------------------------------------

QT       += core gui
QT       += serialport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG   += c++11
CONFIG   += sdk_no_version_check

TARGET   = L103MotorControl

# Windows 应用图标 (齿轮 + 电机), 多尺寸 256/128/64/48/32/16
RC_ICONS = src/app.ico
TEMPLATE = app

DEFINES += QT_DEPRECATED_WARNINGS

INCLUDEPATH += $$PWD/src

SOURCES += \
    src/main.cpp \
    src/l103protocol.cpp \
    src/uartlink.cpp \
    src/canlink.cpp \
    src/bridgelink.cpp \
    src/mainwindow.cpp \
    src/waveform.cpp \
    src/waveplot.cpp

HEADERS += \
    src/l103protocol.h \
    src/uartlink.h \
    src/canlink.h \
    src/bridgeframing.h \
    src/bridgelink.h \
    src/mainwindow.h \
    src/waveform.h \
    src/waveplot.h

## 想固定 DLL 位置时改这里; 程序运行时也会自动找 exe 同目录下的 USBCANx64.dll
CH9433_DIR = $$PWD/third_party/CH9433EVT/lib
