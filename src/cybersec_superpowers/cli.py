"""cybersec_superpowers - Cybersecurity Superpowers CLI entry point."""

from __future__ import annotations

import os
import stat
import subprocess
import sys
from pathlib import Path


def _find_project_root() -> Path:
    """Walk up from this file's directory to find the project root."""
    current = Path(__file__).resolve().parent
    for _ in range(6):
        if (current / "scripts" / "run-orchestrator.sh").exists():
            return current
        current = current.parent
    print("Error: Could not locate Cybersecurity Superpowers installation.", file=sys.stderr)
    sys.exit(1)


ROOT = _find_project_root()


def _ensure_executable(path: Path) -> None:
    """Set +x on a file."""
    st = path.stat()
    os.chmod(path, st.st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def _find_script(name: str) -> Path:
    """Locate a script in the project root."""
    candidates = [
        ROOT / "scripts" / name,
        ROOT / "examples" / "demo-project" / name,
    ]
    for c in candidates:
        if c.exists():
            _ensure_executable(c)
            return c
    print(f"Error: {name} not found in installation", file=sys.stderr)
    sys.exit(1)


def _run_script(script_name: str, passthrough_args: list[str] | None = None) -> None:
    """Run a bundled bash script, forwarding remaining CLI args."""
    script = _find_script(script_name)
    args = passthrough_args if passthrough_args else sys.argv[2:]
    cmd = ["/usr/bin/env", "bash", str(script)] + args
    proc = subprocess.run(cmd)
    sys.exit(proc.returncode)


def _run_orchestrator(mode: str | None = None) -> None:
    """Run the orchestrator with a given mode."""
    script = _find_script("run-orchestrator.sh")
    args = [str(script)]
    if mode:
        args.append(mode)
        if len(sys.argv) > 2:
            args.extend(sys.argv[2:])
    else:
        args.extend(sys.argv[2:])
    proc = subprocess.run(["/usr/bin/env", "bash"] + args)
    sys.exit(proc.returncode)


def main() -> None:
    """cybersec CLI: run orchestrator or individual skills.

    Usage:
        cybersec --help
        cybersec threat-model "My App"
        cybersec full "My App"
        cybersec implement "My App"
    """
    if len(sys.argv) < 2 or sys.argv[1] in ("--help", "-h"):
        print("Cybersecurity Superpowers")
        print("")
        print("Usage: cybersec <command> [args...]")
        print("")
        print("Commands:")
        print("  threat-model <desc>   Run threat-modeling skill")
        print("  implement <desc>      Run secure-coding + static-analysis")
        print("  full <desc>           Run all 5 core skills sequentially")
        print("  demo                  Run the demo project")
        print("  setup                 Run environment setup")
        print("  suite                 Run full security suite")
        print("  sbom                  Generate SBOM")
        print("  clear-eval            Run CLEAR evaluation")
        print("")
        print("Examples:")
        print("  cybersec threat-model 'MyApp'")
        print("  cybersec full 'MyApp'")
        print("  cybersec demo")
        return

    command = sys.argv[1]
    commands = {
        "threat-model": lambda: _run_orchestrator("threat-model"),
        "implement": lambda: _run_orchestrator("implement"),
        "full": lambda: _run_orchestrator("full"),
        "demo": lambda: _run_script("run-demo.sh"),
        "setup": lambda: _run_script("setup.sh"),
        "suite": lambda: _run_script("run-security-suite.sh"),
        "sbom": lambda: _run_script("generate-sbom.sh", sys.argv[2:] if len(sys.argv) > 2 else None),
        "clear-eval": lambda: _run_script("run-clear-eval.sh", sys.argv[2:] if len(sys.argv) > 2 else None),
    }

    fn = commands.get(command)
    if fn:
        fn()
    else:
        print(f"Unknown command: {command}", file=sys.stderr)
        sys.exit(1)


def orchestrator() -> None:
    """cybersec-orchestrator: direct orchestrator entry point."""
    _run_orchestrator()


def demo() -> None:
    """cybersec-demo: run the demo project."""
    _run_script("run-demo.sh")