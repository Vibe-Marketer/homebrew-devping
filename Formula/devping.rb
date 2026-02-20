class Devping < Formula
  desc "Native macOS notifications for AI coding assistants (Claude Code, OpenCode, etc.)"
  homepage "https://github.com/Vibe-Marketer/devping"
  url "https://github.com/Vibe-Marketer/devping/releases/download/v1.0.0/DevPing-1.0.0-macOS.zip"
  sha256 "7cb10fa914aab6803b17d28ca942e30f28b5e8e519a03c50ba8c000049959405"
  version "1.0.0"
  license "MIT"

  depends_on :macos => :sonoma

  def install
    # The zip contains DevPing.app at root level
    prefix.install buildpath/"DevPing.app"

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
