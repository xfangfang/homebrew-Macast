cask "macast-dev" do
  arch = Hardware::CPU.intel? ? "IntelChip" : "AppleSilicon"
  
  version "0.7.0,dev-8d53e51"
  
  if Hardware::CPU.intel?
    sha256 "283322af8458b3eaa3367b0e9c970f5b8f96b452082a2202808710b63132aa46"
  else
    sha256 "201e93340236b07904a30c64984abf5a855442686be8efeec8bbf70af680077c"
  end
 

  url "https://nightly.link/xfangfang/Macast/actions/runs/2036674714/Macast-MacOS-8d53e51-#{arch}.dmg.zip"
  name "Macast"
  desc "DLNA Media Renderer"
  homepage "https://github.com/xfangfang/Macast"

  livecheck do
    url :homepage
    strategy :github_latest
  end
  
  auto_updates true
  
  conflicts_with cask: "macast"

  depends_on macos: ">= :mojave"

  app "Macast.app"
  
  shimscript = "#{staged_path}/macast.wrapper.sh"
  binary shimscript, target: "macast"
  
  preflight do
    File.write shimscript, <<~EOS
      #!/bin/bash
      exec '#{appdir}/Macast.app/Contents/MacOS/Macast' "$@"
    EOS
  end
  
  postflight do
    system_command "xattr",
                   args: ["-rd", "com.apple.quarantine", "#{appdir}/Macast.app"],
                   sudo: true
  end
  
  caveats do
    unsigned_accessibility
    <<~EOS
       Macast.app is not signed by a developer license, so it will need your permission to finish the installtion.
       We will run the following command to remove the quarantine tag:
         'sudo xattr -rd com.apple.quarantine /Applications/Macast.app'
     EOS
  end

  zap trash: [
    "~/Library/Logs/Macast",
    "~/Library/Application Support/Macast",
    "~/Library/Preferences/cn.xfangfang.Macast.plist",
    "~/Library/Saved Application State/cn.xfangfang.Macast.savedState",
  ]
end
