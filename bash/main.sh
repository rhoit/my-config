#!/bin/bash

mv ~/.bashrc ~/.bashrc.bak
ln -s "$PWD/bashrc" ~/.bashrc
ln -s "$PWD/bashrc.d" ~/.bashrc.d

