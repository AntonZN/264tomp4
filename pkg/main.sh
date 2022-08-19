#!/bin/bash

patch=$1
tmpDirectory=$2
ffmpegPatch=$3
outputPatch=$4
isAudio=$5

inputBasename=`basename "$patch"`

if [ -z "$patch" ];then
  echo "Usage: converter patch_to_file.264"
  exit 1
fi

if [ -z "$tmpDirectory" ];then
  echo "Usage tmpDirectory: converter file.264 /tmp_stream"
  exit 1
fi

if [ -z "$ffmpegPatch" ];then
  echo "Usage ffmpegPatch: converter file.264 /tmp_stream /usr/bin/ffmpeg4"
  exit 1
fi

if [ -z "$outputPatch" ];then
  echo "Usage ffmpegPatch: converter file.264 /tmp_stream /usr/bin/ffmpeg4 output.mp4"
  exit 1
fi

if [ -z "$isAudio" ];then
  echo "Usage ffmpegPatch: converter file.264 /tmp_stream /usr/bin/ffmpeg4 output.mp4 1/0"
  exit 1
fi

if [ ! -f "$patch" ]; then
  echo "File not found: $patch"
  exit 1
fi

tmpDir=$(mktemp -p $tmpDirectory --directory ci-XXXXXXXXXXXXXXXX)

cp "$patch" "$tmpDir"/input.264
cd $tmpDir

ls -lh

../convert2 input.264

if [ "$isAudio" -eq "1" ]; then
  $ffmpegPatch input.mp3 -i input.wav
  ../mkvmerge  --output "input.mkv" --timestamps "0:input.video.ts.txt" "input.h264" "input.mp3"
  $ffmpegPatch -i input.mkv -c:v copy -c:a copy -strict -1 output.mp4
else
  ../mkvmerge  --output "input.mkv" --timestamps "0:input.video.ts.txt" "input.h264"
  $ffmpegPatch -i input.mkv -c:v copy -an output.mp4
fi

mv output.mp4 ${outputPatch}
rm -rf $tmpDir
