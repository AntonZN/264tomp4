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
  echo "Usage ffmpegPatch: converter file.264 /tmp_stream /usr/bin/ffmpeg4 output.mkv"
  exit 1
fi

if [ -z "$isAudio" ];then
  echo "Usage ffmpegPatch: converter file.264 /tmp_stream /usr/bin/ffmpeg4 output.mkv 1/0"
  exit 1
fi

if [ ! -f "$patch" ]; then
  echo "File not found: $patch"
  exit 1
fi

tmpDir=$(mktemp -p $tmpDirectory --directory ci-XXXXXXXXXXXXXXXX)

ls -lh

cp "$patch" "$tmpDir"/input.264
cp * $tmpDir

cd $tmpDir

ls -lh

./convert2 input.264

if [ "$isAudio" -eq "1" ]; then
  $ffmpegPatch -hide_banner -loglevel panic -i input.wav input.mp3
  ./mkvmerge  --output "output.mkv" --timestamps "0:input.video.ts.txt" "input.h264" "input.mp3"
  # $ffmpegPatch -hide_banner -loglevel panic -i input.mkv -c:v copy -c:a copy -strict -1 output.mkv
else
  ./mkvmerge  --output "output.mkv" --timestamps "0:input.video.ts.txt" "input.h264"
  # $ffmpegPatch -hide_banner -loglevel panic -i input.mkv -c:v copy -an output.mkv
fi

chmod 644 output.mkv
mv output.mkv ${outputPatch}
rm -rf $tmpDir
