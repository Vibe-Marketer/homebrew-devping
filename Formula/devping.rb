class Devping < Formula
  desc "Native macOS notifications for AI coding assistants (Claude Code, OpenCode, etc.)"
  homepage "https://github.com/Vibe-Marketer/devping"
  url "https://github.com/Vibe-Marketer/devping/releases/download/v1.2.3/DevPing-1.2.3-macOS.zip"
  sha256 "290ddd4e3db3da2df8727ca26c20e6d0fb16c3f4843e61008b3ee95e74c0e593"
  version "1.2.3"
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
    system "open", "#{prefix}/DevPing.app"
  end

  def caveats
    <<~EOS
      DevPing is now running in your menu bar — look for the ⚡ bolt icon.

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
