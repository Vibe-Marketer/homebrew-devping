class Devping < Formula
  desc "Native macOS notifications for AI coding assistants (Claude Code, OpenCode, etc.)"
  homepage "https://github.com/Vibe-Marketer/devping"
  url "https://github.com/Vibe-Marketer/devping/releases/download/v1.2.5/DevPing-v1.2.5.zip"
  sha256 "72e2fa69783acf35c49ceeb20750d6f9ad66d81a7cfdbd2277c72f66b7ec6852"
  version "1.2.5"
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
