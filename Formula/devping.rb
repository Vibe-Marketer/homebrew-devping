class Devping < Formula
  desc "Native macOS notifications for AI coding assistants (Claude Code, OpenCode, etc.)"
  homepage "https://github.com/Vibe-Marketer/devping"
  url "https://github.com/Vibe-Marketer/devping/releases/download/v1.1.0/DevPing-1.1.0-macOS.zip"
  sha256 "58c983e3518f3269f4ea4399bd65a5dec2c71dbf80784ec010dd93511dcf2114"
  version "1.1.0"
  license "MIT"

  depends_on :macos => :sonoma

  def install
    # Homebrew moves the top-level zip directory (DevPing.app) INTO buildpath,
    # so buildpath itself IS DevPing.app (contains Contents/).
    (prefix/"DevPing.app").mkpath
    system "cp", "-R", "#{buildpath}/.", "#{prefix}/DevPing.app/"

    # CLI shim so `devping` works from the terminal
    (bin/"devping").write <<~SH
      #!/bin/bash
      exec "#{prefix}/DevPing.app/Contents/MacOS/devping" "$@"
    SH
  end

  def caveats
    <<~EOS
      DevPing has been installed as a menu bar app.

      To launch it now:
        open #{prefix}/DevPing.app

      To have it start automatically at login, use the Settings menu
      in the DevPing menu bar icon after launching.

      You can also trigger a notification via the CLI:
        devping "Your message here"
    EOS
  end

  test do
    assert_predicate prefix/"DevPing.app", :directory?
    assert_predicate prefix/"DevPing.app/Contents/MacOS/devping", :executable?
  end
end
