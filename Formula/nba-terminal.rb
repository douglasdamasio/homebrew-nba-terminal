# typed: false
# frozen_string_literal: true

class NbaTerminal < Formula
  desc "TUI to follow NBA games, standings, and box scores in the terminal"
  homepage "https://github.com/douglasdamasio/nba-terminal"
  url "https://github.com/douglasdamasio/nba-terminal/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0bd4f7eea2038ec438b155624fc11209e94b7912810c21b9a21cbcd5bd9238b2"
  license "MIT"
  head "https://github.com/douglasdamasio/nba-terminal.git", branch: "main"

  depends_on "python@3.12"

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"

    system python, "-m", "venv", libexec
    (libexec/"app").install Dir[buildpath/"*"]
    system libexec/"bin/pip", "install", "-r", libexec/"app/requirements.txt"

    (bin/"nba-terminal").write <<~EOS
      #!/bin/bash
      export PYTHONPATH="#{libexec}/app"
      cd "#{libexec}/app" && exec "#{libexec}/bin/python" -m src.main "$@"
    EOS
    chmod 0755, bin/"nba-terminal"
  end

  def caveats
    <<~EOS
      If you see "Failed to fix install linkage" for pydantic_core, you can ignore it.
      Run `nba-terminal --help` to confirm the app works.
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/nba-terminal --help", 0)
  end
end
