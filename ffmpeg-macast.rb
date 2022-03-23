# modified from https://github.com/iina/homebrew-mpv-iina
# Last check with upstream: 5ef3900b6178dee40629e3e058a587ef196b53b1
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/ffmpeg.rb

class FfmpegMacast < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://github.com/xfangfang/FFmpeg/archive/patch/hls_4.4.zip"
  sha256 "7bfff0c1e2179892f8b735961599daf35e2bffa26ee99dd9a29765a5a157b5f9"
  head "https://github.com/xfangfang/FFmpeg.git", branch: "patch/hls_4.4"

  keg_only <<EOS
it is intended to only be used for building Macast.
This formula is not recommended for daily use and has no binaraies (ffmpeg, ffplay etc.)
EOS

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "dav1d"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libsoxr"
  depends_on "libvidstab"
  depends_on "rubberband"
  depends_on "snappy"
  depends_on "speex"
  depends_on "tesseract"
  depends_on "xz"
  depends_on "zeromq"
  depends_on "zimg"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gnutls
      --enable-gpl
      --enable-libbluray
      --enable-libdav1d
      --enable-librubberband
      --enable-libsnappy
      --enable-libtesseract
      --enable-libvidstab
      --enable-libxml2
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libspeex
      --enable-libsoxr
      --enable-libzmq
      --enable-libzimg
      --disable-libjack
      --disable-indev=jack
      --disable-programs
    ]

      # Needs corefoundation, coremedia, corevideo
     args << "--enable-videotoolbox" if OS.mac?
     args << "--enable-neon" if Hardware::CPU.arm?

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
