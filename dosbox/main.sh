#!/bin/bash

echo "Changing keyboardlayout to dvorak (dv103)"
sed -i 's/keyboardlayout=auto/keyboardlayout=dv103/' ~/.dosbox/dosbox-0.74.conf
