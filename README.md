# bilidown
function:
1. download stream from bilibili on MacOS by url
2. remove video part, only keep audio part
3. convert audio part into format mp3

prerequest:
```shell
brew install ffmpeg
ffmpeg --version ==> ensure you have installed ffmpeg on your pc
pip3 install you-get
```

how to use:
1. write video urls into a file called `urlsToDeal`.
```shell
https://www.bilibili.com/video/BV1ws411X7aj?t=156.1
https://www.bilibili.com/video/BV1d4411A7xc?t=1.6
https://www.bilibili.com/video/BV1Ck4y1w7Pc?t=1.5
https://www.bilibili.com/video/BV1hs411275U?t=1.0
```
2. put this file and download.sh in the same dir. Then run download.sh
