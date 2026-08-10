class Amt < Formula
  desc "Ametrite: local-first issue tracking + markdown knowledge base for AI agent workflows"
  homepage "https://github.com/Davidb3l/Ametrite"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.2.0/amt-aarch64-apple-darwin.tar.xz"
      sha256 "e565101f6b42653173eba72c7005dcb7980e8a5e27ef4174aea95bb07dbac2ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.2.0/amt-x86_64-apple-darwin.tar.xz"
      sha256 "3df8016f7cb6047b06949bdb0934f575db2d3fea52aa51ccc0da030f493bb2dc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Davidb3l/Ametrite/releases/download/v0.2.0/amt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "20473930df30b41284838c46be3eb5af3278916f7815329cf88dd81fc80b23dd"
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
