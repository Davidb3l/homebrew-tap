class Amt < Formula
  desc "Ametrite: local-first issue tracking + markdown knowledge base for AI agent workflows"
  homepage "https://github.com/Davidb3l/Ametrite"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.4.2/amt-aarch64-apple-darwin.tar.xz"
      sha256 "1fb031c6b437558795dded87313c6101f36625bf3bf0fb9bb13c5d1641bba465"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.4.2/amt-x86_64-apple-darwin.tar.xz"
      sha256 "d153284fef6a0e3a7f76f4d00fd90fe7bf246c1294274d7bdb497cd2e80ad24c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Davidb3l/Ametrite/releases/download/v0.4.2/amt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1a0d1d2fe3f5eb9534e39019c01af47e874c3bb3eeff8c932d5b866758cf3a9f"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "amt"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "amt"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "amt"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
