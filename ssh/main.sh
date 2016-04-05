#!/bin/bash

sed 's/.*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# to copy cow-notify
