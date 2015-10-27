#!/bin/bash

BASEDIR=`pwd`
echo $BASEDIR

export PYTHONPATH=$BASEDIR/features_extraction; $PYTHONPATH
