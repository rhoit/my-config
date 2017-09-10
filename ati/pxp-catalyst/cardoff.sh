#!/bin/bash

# https://wiki.archlinux.org/index.php/Catalyst#Hybrid.2FPowerXpress:_turning_off_discrete_GPU

libglx=$(/usr/lib/fglrx/switchlibglx query)

modprobe acpi_call

if [ "$libglx" = "intel" ]; then
    echo '\_SB.PCI0.PEG0.PEGP._OFF' > /proc/acpi/call
fi
