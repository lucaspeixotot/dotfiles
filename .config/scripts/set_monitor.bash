#!/bin/bash

HDMI_STATUS=$(xrandr | grep HDMI | cut -d ' ' -f2)

if [ $HDMI_STATUS = "connected" ]
then
    xrandr --output HDMI-1 --auto --primary --right-of eDP-1
    echo "is connected"
else
    xrandr --output eDP-1 --auto --primary
    echo "is not connected"
fi
