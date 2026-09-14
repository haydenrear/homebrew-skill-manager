# Starter formula for the skill-manager/homebrew-tap repo.
#
# Place this file at:
#   skill-manager/homebrew-tap:Formula/skill-manager.rb
#
# After the first release-please tag fires, the `bump-homebrew-tap` job in
# .github/workflows/release.yml uses mislav/bump-homebrew-formula-action to
# rewrite the `url` and `sha256` fields automatically — leave the placeholders
# as-is for the very first commit; the action accepts a stale formula as long
# as the structure is recognizable.
class SkillManager < Formula
  desc "Build tool for agent skills: CLI deps, skill references, MCP servers"
  homepage "https://github.com/haydenrear/skill-manager"
  url "https://github.com/haydenrear/skill-manager/releases/download/v0.28.0/skill-manager-0.28.0.tar.gz"
  sha256 "ff6dfcff8c469de0d06d066cb7a6da4623c93d047248aa38d0ad17fd5b1d5f3f"
  license "Apache-2.0"

  depends_on "openjdk@21"
  depends_on "uv"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/skill-manager"
  end

  def caveats
    <<~EOS
      The virtual-mcp-gateway runs under uv. The first time you invoke
      `skill-manager gateway up`, uv will materialize the gateway venv at:
        #{libexec}/share/virtual-mcp-gateway/.venv

      Java is provided by openjdk@21 (a brew dependency). If `java -version`
      fails, run:
        brew link --force openjdk@21
      The skill-manager registry server is published as a container image at
      ghcr.io/haydenrear/skill-manager-server. To self-host:
        docker compose -f docker-compose-ghcr.yml up -d
      (see https://github.com/haydenrear/skill-manager)
    EOS
  end

  test do
    assert_match "skill-manager", shell_output("#{bin}/skill-manager --version")
  end
end
