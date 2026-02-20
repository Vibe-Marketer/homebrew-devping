class Devping < Formula
  desc "Native macOS notifications for AI coding assistants (Claude Code, OpenCode, etc.)"
  homepage "https://github.com/Vibe-Marketer/devping"
  url "https://github.com/Vibe-Marketer/devping/releases/download/v1.0.0/DevPing-1.0.0-macOS.zip"
  sha256 "7cb10fa914aab6803b17d28ca942e30f28b5e8e519a03c50ba8c000049959405"
  version "1.0.0"
  license "MIT"

  depends_on :macos => :sonoma

  def install
    # Debug: list what's in buildpath
    system "ls", "-la", buildpath.to_s

    app_src = buildpath/"DevPing.app"
    odie "DevPing.app not found in #{buildpath}" unless app_src.directory?

    (prefix/"DevPing.app").mkpath
    system "cp", "-R", "#{app_src}/.", "#{prefix}/DevPing.app/"

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
