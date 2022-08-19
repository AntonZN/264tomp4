`sudo yum -y install fuse-libs`

`sudo yum -y install fuse`

```
./converter patch_to_264_file.264 tmp_directory patch_to_ffmpeg patch_output audio
```

Example:

```
./converter /tmp_stream/camera_test/archive/P220819_122518_122820.264 /tmp_stream /usr/local/bin/ffmpeg4 /tmp_stream/camera_test/archive/P220819_122518_122820.mkv 1
```

