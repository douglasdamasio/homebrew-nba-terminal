# typed: false
# frozen_string_literal: true

class NbaTerminal < Formula
  include Language::Python::Virtualenv::Formula

  desc "TUI to follow NBA games, standings, and box scores in the terminal"
  homepage "https://github.com/douglasdamasio/nba-terminal"
  url "https://github.com/douglasdamasio/nba-terminal/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0bd4f7eea2038ec438b155624fc11209e94b7912810c21b9a21cbcd5bd9238b2"
  license "MIT"
  head "https://github.com/douglasdamasio/nba-terminal.git", branch: "main"

  depends_on "python@3.12"

  def install
    # Copy app source into libexec/app so PYTHONPATH can find it
    (libexec/"app").install Dir[buildpath/"*"]

    # Create virtualenv and install dependencies
    virtualenv_create(libexec, "python3.12")
    system libexec/"bin/pip", "install", "-r", libexec/"app/requirements.txt"

    # Wrapper script: set PYTHONPATH and run the app
    (bin/"nba-terminal").write <<~EOS
      #!/bin/bash
      export PYTHONPATH="#{libexec}/app"
      exec "#{libexec}/bin/python" -m src.main "$@"
    EOS
    chmod 0755, bin/"nba-terminal"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/nba-terminal --help", 0)
  end
end

