class Devping < Formula
  desc "Native macOS notifications for AI coding assistants (Claude Code, OpenCode, etc.)"
  homepage "https://github.com/Vibe-Marketer/devping"
  url "https://github.com/Vibe-Marketer/devping/releases/download/v1.2.0/DevPing-1.2.0-macOS.zip"
  sha256 "61a044f5551a9c98115d2a79d25b8004e2452eeda3238c9ead5e7972592317a4"
  version "1.2.0"
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

  def post_install
    # Launch the app automatically after install so the menu bar icon appears immediately
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
