#!/bin/bash

# Stop Root from login from ssh
sed 's/.*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
