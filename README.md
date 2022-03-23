# homebrew-Macast

This repo contains custom mpv and ffmpeg homebrew tap for Macast.

## Main

### Casks/macast-dev.rb

Install Macast.app (dev version)

```
brew tap xfangfang/Macast
brew install macast-dev
```

If you want to install the official version, please run: `brew install macast`

### mpv-macast.rb

Depends on ffmpeg-macast instead of ffmpeg
Does not depend on vapoursynth and yt-dlp


### ffmpeg-macast.rb

Removed all encoding libraries
Removed some of the decoding libraries which ffmpeg can natively decode
Patch for some HLS video (For personal use, the release version of Macast.app does not contain this modification)

## Others

### build mpv for Macast.app

If you want to build macast locally App may refer to the following content

##### step 1: build Macast.app (without mpv)

You can refer to the construction steps in the [Macast wiki](https://github.com/xfangfang/Macast/wiki/BuildFromSource)

On the Mac of Intel chip, we can directly copy the officially compiled mpv into the Macast.app, but the official does not provide the mpv binary file of Apple silicon chip, so we need to compile mpv manually.

##### step 2: build mpv and copy to Macast.app

```
# build mpv

cd Macast
brew tap xfangfang/Macast
brew install mpv-macast
```

Find where mpv located: `which mpv` and make sure this mpv is the one you just built.

Then copy mpv to Macast.app.

```
mkdir -p dist/Macast.app/Contents/Resources/bin/MacOS/
cp `which mpv` dist/Macast.app/Contents/Resources/bin/MacOS/mpv
```

Finally, copy the libraries which mpv dependent into Macast.app

```
# brew install dylibbundler
dylibbundler -od -b \
-x dist/Macast.app/Contents/Resources/bin/MacOS/mpv \
-d dist/Macast.app/Contents/Resources/bin/MacOS/lib/ \
-p @executable_path/lib/

codesign --sign - --force dist/Macast.app/Contents/Resources/bin/MacOS/lib/*

```

## Links

https://github.com/xfangfang/Macast/blob/main/.github/workflows/build-macast.yaml

https://github.com/xfangfang/Macast/wiki/BuildFromSource

https://github.com/xfangfang/Macast/issues/11

https://github.com/xfangfang/Macast/releases/tag/v0.1
