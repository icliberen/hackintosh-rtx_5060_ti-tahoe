# Provenance and priority

## Recorded local chronology (Europe/Istanbul, UTC+03)

- 9 October 2026: existing Tahoe 26.7.1 machine inspected; RTX hidden in EFI. A test EFI and RX baseline were prepared.
- 9 October, evening: original USB boot restored after failed diagnostic trials. Upstream 1.2.0 NVAccel rebuilt for Sequoia and Tahoe. ABI and isolated kernel collection checks passed.
- 9 October, 23:53: reviewed experimental package installed; installed-file hashes and AuxKC inclusion verified.
- 10 October, 00:25: NVIDIA and AMD each passed the 4,096-element Metal compute probe; NVIDIA DP output was then tuned.
- 10 October, 00:54: SecurityAgent-only GPU-list workaround installed and later confirmed visually by the user.
- 10 October, 01:01: live 180 Hz switch failed; numerical rollback to 85 Hz did not restore the visible picture.
- 10 October, 01:28 / 01:41: fresh 120 Hz and 180 Hz sessions confirmed by the user after restart. Metal compute was rechecked at 180 Hz. Some icons remained corrupted.
- 10 October, 13:20: working USB config transferred to SSD EFI; 355 other files verified unchanged.
- 10 October, 13:29 onward: loginwindow exclusion did not fix the boot login screen. An undo was prepared; no executed undo or final boot-login fix was recorded.
- 12 October: OS, active NVIDIA 16 GB / 180 Hz display and both Metal compute results rechecked. Installed Tahoe NVAccel still matched the local-build hash.
- 12 October, publication request: owner confirmed that the system also works with RX 6800 removed. This later report is separate from the preceding dual-GPU captures.

These times combine chat execution metadata, saved records and user reports. They are local records, not independently timestamped public proof of priority.

## Credit

- NullMoth Systems: base kernel/Metal/display stack, NVK integration, translator and firmware packaging.
- Issue #51: diagnosis of stale macOS 26 accelerator VRAM ABI; RTX 5080 / Tahoe report.
- PR #60 (MasonDye): rebuilding both accelerators and Tahoe RTX 4070 Laptop/KVM evidence; posted 9 October 2026 at 17:41 UTC (20:41 Istanbul).
- PR #59 (MasonDye): `ditto` backup/rollback fixes on macOS 26.
- This machine's owner and Codex: local rebuild verification, dual-GPU installation, test EFI/config integration, Metal probes, high-refresh experiments, SecurityAgent process selection, guarded helpers and SSD transfer checks.

The local upstream source repository is still at the pinned commit and has no tracked source modifications; only an untracked shader cache was present. Kernel features such as automatic zero-copy flip were already in upstream code.

Sources: [#51](https://github.com/nullmoth/nvidia-macos-driver/issues/51), [#60](https://github.com/nullmoth/nvidia-macos-driver/pull/60), [#59](https://github.com/nullmoth/nvidia-macos-driver/pull/59), [upstream](https://github.com/nullmoth/nvidia-macos-driver).

## What can be claimed

Documented experimental bare-metal RTX 5060 Ti 16 GB operation on Tahoe 26.7.1, on a Ryzen 5 9600X machine, with NVIDIA DP output at 1440p/180 Hz and a passing basic NVIDIA Metal compute check. An AMD GPU remained installed during the captured tests. The owner subsequently confirmed operation with RX 6800 removed; see [RTX-ONLY.md](RTX-ONLY.md).

Cannot be claimed: the first NVIDIA GPU on Tahoe, a driver written from scratch by this local team, full Metal compatibility, 180 FPS performance, automated RTX-only test evidence, stable support for every card, or independently established world-first priority.

Public research on 12 October found earlier Tahoe evidence for other NVIDIA cards, including #51/#60 and later [RTX 5060 Laptop PR #113](https://github.com/nullmoth/nvidia-macos-driver/pull/113). Searches and the upstream 5060 issue/comment inventory did not establish an earlier public report of this exact desktop 5060 Ti 16 GB configuration. That absence is insufficient to prove a world first. Unindexed, private, deleted and non-English reports remain possible.
