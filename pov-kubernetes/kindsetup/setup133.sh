#!/bin/bash

sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512

kind create cluster --config ../kindconfig/kindconfig-v133.yml