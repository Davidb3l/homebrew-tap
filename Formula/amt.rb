class Amt < Formula
  desc "Ametrite: local-first issue tracking + markdown knowledge base for AI agent workflows"
  homepage "https://github.com/Davidb3l/Ametrite"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.1.0/amt-aarch64-apple-darwin.tar.xz"
      sha256 "111577bea5d16fc7ce844023e4bd8f14c88114f5d9654f34f1e9faeffdbf33e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.1.0/amt-x86_64-apple-darwin.tar.xz"
      sha256 "2ec368456a42e307434748722ababc1683145b5c99f9fc9fb37d3e9f4f4ef74e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Davidb3l/Ametrite/releases/download/v0.1.0/amt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5a3f33d16c87be68b9736e8d5285e0cee7af031c95b535f18306697e9d02804a"
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
    bin.install "amt" if OS.mac? && Hardware::CPU.arm?
    bin.install "amt" if OS.mac? && Hardware::CPU.intel?
    bin.install "amt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
