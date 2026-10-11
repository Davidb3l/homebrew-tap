class Amt < Formula
  desc "Ametrite: local-first issue tracking + markdown knowledge base for AI agent workflows"
  homepage "https://github.com/Davidb3l/Ametrite"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.4.0/amt-aarch64-apple-darwin.tar.xz"
      sha256 "658db3926fb5ddb215ba25b476a5a857ae99f4856cad45e008a10dbad9c8e407"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Davidb3l/Ametrite/releases/download/v0.4.0/amt-x86_64-apple-darwin.tar.xz"
      sha256 "3e1357927674564749e0d7d6e77a70e412242331f115d3bbe2a671bf4d5de076"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Davidb3l/Ametrite/releases/download/v0.4.0/amt-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fab756248091c78206433c56ef752d84c8171448fb8b506fdf96a4f74c8b40d0"
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
