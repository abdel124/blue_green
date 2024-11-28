#!/bin/bash
pkill -f app.py || true
nohup python3 /home/ec2-user/python-app/app.py > /home/ec2-user/python-app/log.txt 2>&1 &