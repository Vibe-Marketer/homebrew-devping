class Devping < Formula
  desc "Native macOS notifications for AI coding assistants (Claude Code, OpenCode, etc.)"
  homepage "https://github.com/Vibe-Marketer/devping"
  url "https://github.com/Vibe-Marketer/devping/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "10635c4c4bf99f0efdca34db8b21e5b58497b6754a77061a0cebaf9882c7ea3a"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos => :sonoma

  def install
    # Build the Swift binary in release mode
    system "swift", "build", "-c", "release"

    bin_path = `swift build -c release --show-bin-path`.strip
    binary = "#{bin_path}/devping"

    # Assemble DevPing.app bundle
    app_dir = buildpath/"DevPing.app"
    contents = app_dir/"Contents"
    macos_dir = contents/"MacOS"
    resources_dir = contents/"Resources"

    [macos_dir, resources_dir].each(&:mkpath)

    # Binary
    cp binary, macos_dir/"devping"

    # Info.plist
    cp buildpath/"Info.plist", contents/"Info.plist"

    # App icon
    if (buildpath/"Resources/DevPing.icns").exist?
      cp buildpath/"Resources/DevPing.icns", resources_dir/"DevPing.icns"
    end

    # Ad-hoc sign
    system "codesign", "--force", "--sign", "-", app_dir.to_s

    # Install .app to prefix
    prefix.install app_dir

    # Install CLI shim so `devping` works from terminal
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

      You can also use the CLI directly:
        devping "Your message here"
    EOS
  end

  test do
    assert_predicate prefix/"DevPing.app", :directory?
    assert_predicate prefix/"DevPing.app/Contents/MacOS/devping", :executable?
  end
end
