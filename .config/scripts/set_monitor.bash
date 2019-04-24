#!/bin/bash

HDMI_STATUS=$(xrandr | grep HDMI | cut -d ' ' -f2)

if [ $HDMI_STATUS = "connected" ]
then
    xrandr --output HDMI1 --auto --primary --right-of eDP1
    echo "is connected"
else
    xrandr --output eDP1 --auto --primary
    echo "is not connected"
fi
