#!/bin/sh

cd `dirname $0`/..
PACKAGES=`pwd`/packages

cd $PACKAGES/webext
pub run test

cd $PACKAGES/webextdev
pub run test