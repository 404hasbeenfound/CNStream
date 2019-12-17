#!/bin/bash
CURRENT_DIR=$(cd $(dirname ${BASH_SOURCE[0]});pwd)
arch=`uname -m`
card=$(cat /proc/driver/cambricon/mlus/*/information | grep -Eiow 'mlu-100|mlu-270' | uniq -c | grep -Eiow 'mlu-270|mlu-100')
if [ ${card} == "mlu-100" ]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CURRENT_DIR/../../mlu/MLU100/libs/$arch:$CURRENT_DIR/../../lib
  echo $LD_LIBRARY_PATH
elif [ ${card} == "mlu-270" ]; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CURRENT_DIR/../../mlu/MLU270/libs/$arch:$CURRENT_DIR/../../lib
else
  echo "driver is not installed!!!"
  exit 1
fi


pushd $CURRENT_DIR
  if [ ! -f $CURRENT_DIR/files.list_video ]; then
    echo "generate files.list_video in $CURRENT_DIR"
    for ((i = 0; i < 2; ++i))
    do
      echo "$CURRENT_DIR/test_data/video/wlwz.mp4" >> files.list_video
    done
  fi
  if [ ! -f $CURRENT_DIR/files.list_image ]; then
    echo "generate files.list_image in $CURRENT_DIR"
    echo "$CURRENT_DIR/test_data/image/all1.jpg" >> files.list_image
    echo "$CURRENT_DIR/test_data/image/all2.jpg" >> files.list_image
  fi
  if [ $? -ne 0 ]; then
      exit 1
  fi

popd
