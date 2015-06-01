#!/bin/bash
play -c2 -n synth whitenoise band -n 100 24 band -n 300 100 gain +4  synth pinknoise lowpass -1 100 lowpass -1 100  lowpass -1 100 gain +2
