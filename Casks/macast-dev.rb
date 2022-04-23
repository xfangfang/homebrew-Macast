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
  
  conflicts_with cask: "macast"

  depends_on macos: ">= :mojave"

  app "Macast.app"
  binary "#{appdir}/Macast.app/Contents/MacOS/Macast", target: "macast"

  zap trash: [
    "~/Library/Logs/Macast",
    "~/Library/Application Support/Macast",
    "~/Library/Preferences/cn.xfangfang.Macast.plist",
    "~/Library/Saved Application State/cn.xfangfang.Macast.savedState",
  ]
end
