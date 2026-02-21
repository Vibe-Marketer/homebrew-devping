class Devping < Formula
  desc "Native macOS notifications for AI coding assistants (Claude Code, OpenCode, etc.)"
  homepage "https://github.com/Vibe-Marketer/devping"
  url "https://github.com/Vibe-Marketer/devping/releases/download/v1.2.6/DevPing-v1.2.6.zip"
  sha256 "a877109280c6a61a0a83df35bc11e5c6cf42d48ee892bf94416aa071443cf5e1"
  version "1.2.6"
  license "MIT"

  depends_on :macos => :sonoma

  def install
    (prefix/"DevPing.app").mkpath
    system "cp", "-R", "#{buildpath}/.", "#{prefix}/DevPing.app/"

    (bin/"devping").write <<~SH
      #!/bin/bash
      exec "#{prefix}/DevPing.app/Contents/MacOS/devping" "$@"
    SH
  end

  def post_install
    # Remove old copy first to avoid "Operation not permitted" on upgrades
    system "rm", "-rf", "/Applications/DevPing.app"
    # Copy to /Applications so it appears in Launchpad, Spotlight, and Finder
    system "cp", "-R", "#{prefix}/DevPing.app", "/Applications/DevPing.app"
    # Launch after a short delay so macOS finishes registering the app bundle
    system "bash", "-c", "sleep 2 && open /Applications/DevPing.app &"
  end

  def caveats
    <<~EOS
      DevPing is installed in /Applications and will launch automatically.
      Look for the ⚡ bolt icon in your menu bar.

      To have it start automatically at login, use the Settings menu
      in the DevPing menu bar icon.

      You can also trigger a notification via the CLI:
        devping "Your message here"
    EOS
  end

  test do
    assert_predicate prefix/"DevPing.app", :directory?
    assert_predicate prefix/"DevPing.app/Contents/MacOS/devping", :executable?
  end
end
