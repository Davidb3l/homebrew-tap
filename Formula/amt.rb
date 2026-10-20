class Amt < Formula
  desc "Ametrite: local-first issue tracking + markdown knowledge base for AI agent workflows"
  homepage "https://github.com/Davidb3l/Ametrite"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.5.0/amt-aarch64-apple-darwin.tar.xz"
      sha256 "70e66e767ae32020c6e50291ea84475c466b6de9d2e88467e82bf0ac214ff443"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.5.0/amt-x86_64-apple-darwin.tar.xz"
      sha256 "e42e3a1c20146e95333b2358a2df30185c0cf4b546ebc7392a36c1790acf6704"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Davidb3l/Ametrite/releases/download/v0.5.0/amt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4c38e615be62c7b6bf3e5dc320157ddbd734eb818cdbd43c5eb1b20b25f2fb4e"
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
