# RTX 5060 Ti 16 GB · macOS Tahoe Hackintosh

**A physical Ryzen Hackintosh running macOS Tahoe with RTX 5060 Ti graphics, verified Metal compute, and 1440p / 180 Hz DisplayPort output.**

[![macOS](https://img.shields.io/badge/macOS-Tahoe%2026.7.1-222222)](docs/PROVENANCE.md)
[![GPU](https://img.shields.io/badge/GPU-RTX%205060%20Ti%2016GB-76b900)](evidence/displays-2026-10-12.txt)
[![Metal](https://img.shields.io/badge/Metal-compute%20verified-007aff)](evidence/metal-2026-10-12.txt)
[![License](https://img.shields.io/badge/license-PolyForm%20Noncommercial-blue)](LICENSE)

This repository shares the configuration changes, rebuild notes, helper source, and test records from getting an **INNO3D RTX 5060 Ti 16 GB** working on **macOS Tahoe 26.7.1 (25G241)**. The machine uses an **AMD Ryzen 5 9600X** and drives an **MSI MAG 274QF at 2560×1440 / 180 Hz** directly from the NVIDIA DisplayPort output.

**The system also works without the RX 6800 installed, as confirmed by the owner.** An RX 6800 was used during the original bring-up and the saved two-GPU Metal tests. Those historical logs and the later owner-confirmed RTX-only result are documented separately in [RTX-only operation](docs/RTX-ONLY.md).

The graphics stack is based on [NullMoth's NVIDIA macOS driver](https://github.com/nullmoth/nvidia-macos-driver). This repository documents a working hardware configuration and local integration; credit for the underlying driver belongs to its upstream authors.

## Results

| Check | Result | Evidence |
| --- | --- | --- |
| Physical Hackintosh | Ryzen 5 9600X, Tahoe 26.7.1 / 25G241 | [Recorded build](docs/PROVENANCE.md) |
| NVIDIA recognition | RTX 5060 Ti, PCI ID `10de:2d04`, 16 GB VRAM | [Display capture](evidence/displays-2026-10-12.txt) |
| NVIDIA display output | Main display on RTX DisplayPort, 2560×1440 @ 180 Hz | [Display capture](evidence/displays-2026-10-12.txt) |
| Basic Metal compute | 4,096 correct results on the NVIDIA device; repeated on 12 October 2026 | [Metal test](evidence/metal-2026-10-12.txt) |
| Tahoe kernel binding | NVRM, NVAccel, NVRMFB and NVRMAGDC included in isolated test AuxKC | [Kernel check](evidence/kernel-preflight-identifiers-2026-10-09.txt) |
| RTX-only operation | Owner confirms operation with RX 6800 removed | [Owner report and scope](docs/RTX-ONLY.md) |
| High-refresh desktop | User confirmed usable 120 Hz and then 180 Hz sessions after reboot | [Experiment history](docs/WORKAROUNDS.md) |

The compute check validates a small shader and its output. It does not certify every Metal rendering feature. The 180 Hz timing capture measures display-link callbacks, not rendered FPS.

## Hardware and software

| Component | Configuration |
| --- | --- |
| Processor | AMD Ryzen 5 9600X |
| Memory | 32 GB |
| GPU | INNO3D GeForce RTX 5060 Ti 16 GB, GB206-A |
| Original secondary GPU | XFX Radeon RX 6800 16 GB; later removed for owner-tested RTX-only operation |
| Monitor | MSI MAG 274QF, DisplayPort, 2560×1440 @ 180 Hz |
| Operating system | macOS Tahoe 26.7.1, build 25G241, x86_64 |
| OpenCore | 1.0.8 |
| Driver baseline | NullMoth 1.2.0, commit [`c7dc262`](https://github.com/nullmoth/nvidia-macos-driver/tree/c7dc26239bf85a648d5318fde135ebc09dc094a3) |
| NVIDIA header revision | `e4a5faa2567f28c8eabe0ebb6422b6d0abcf37eb` |

The physical motherboard and exact GPU board SKU were not recorded in this audit. SMBIOS names are not treated as motherboard identification.

## How we got it working

1. **Rebuilt the Tahoe accelerator.** The old packaged Tahoe NVAccel still used VRAM ABI 1 while the current framebuffer expected ABI 2. We rebuilt both macOS 15 and 26 accelerators from the same upstream 1.2.0 source, following the diagnosis in [issue #51](https://github.com/nullmoth/nvidia-macos-driver/issues/51) and the approach in [PR #60](https://github.com/nullmoth/nvidia-macos-driver/pull/60).
2. **Checked the build before installation.** ABI layout, import/export symbol sets, and an isolated auxiliary kernel collection were checked. The local Tahoe NVAccel hash is recorded in [BUILD.md](docs/BUILD.md).
3. **Prepared a build-specific experimental installer.** Local patches allowed the recorded Tahoe build and initially inactive installation while EFI hid the card. The bundle backup/rollback changes came from [PR #59](https://github.com/nullmoth/nvidia-macos-driver/pull/59).
4. **Enabled the NVIDIA card in the test EFI.** We removed its `disable-gpu` property, added NVIDIA boot arguments, and excluded IONDRVSupport for Darwin 25. [The exact config delta](docs/opencore-changes.json) contains no SMBIOS identity data.
5. **Enabled the existing zero-copy display path.** Removing the temporary `-nvrmnoflip` restriction allowed upstream's automatic flip path to run. This improved the observed desktop output.
6. **Verified high-refresh output after restart.** Live refresh changes could corrupt the display. Selecting the mode and starting a fresh session produced user-confirmed 120 Hz and then 180 Hz output. This did not fix the general live mode-switch bug.
7. **Worked around the authorization window during dual-GPU testing.** A `-SecurityAgent` process entry avoided the experimental NVIDIA translator in password prompts while native AMD Metal remained available. This workaround depends on the AMD GPU and is separate from the owner-tested RTX-only configuration.

The driver's tracked source files were not locally modified. The work here consists of rebuilds, integration, configuration, tests and helper scripts developed with Codex.

## Reproducing the checks

Start with [the pinned rebuild notes](docs/BUILD.md), [the EFI delta](docs/opencore-changes.json), and [the successful and failed experiments](docs/WORKAROUNDS.md).

To run the included read-only Metal probe on an existing setup:

```sh
xcrun swiftc tools/check-metal.swift -o /tmp/rtx-tahoe-metal-check
/tmp/rtx-tahoe-metal-check
```

Look for the named **NVIDIA GeForce RTX 5060 Ti** device and its `PASS: 4096 GPU-computed results match` line. The original probe continues after some failures, so the exit status alone is insufficient.

`archive/` preserves historical helper source as text, including failed experiments. The archived installers are tied to specific hashes, a particular build and personal backup state; some paths have been redacted. They are reference material, not a universal installation script. No complete EFI, driver binaries, firmware, or macOS kernel collection is distributed here.

## Known issues and test scope

The original investigation observed corrupted application/settings icons, black or gray screens after live refresh changes, and a gray first boot login screen. The `loginwindow` exclusion did not fix the first-login issue. Ordinary SecurityAgent password prompts were separately confirmed working during the dual-GPU phase.

The saved automated evidence was collected with both GPUs installed. The owner's later confirmation establishes that the system also works with RX 6800 removed; a separate RTX-only diagnostic capture is not yet included. The AMD-specific authorization workaround should not be copied into an RTX-only setup as a proven fix.

Sleep, GPU audio, hardware video encode/decode, CUDA, professional applications, sustained-load thermals and long-term stability have not been qualified by this report. These are experimental results for this configuration, not a guarantee for every RTX card or Tahoe build.

## Repository map

| Directory | Contents |
| --- | --- |
| [`docs/`](docs/) | Build recipe, provenance, RTX-only report, configuration delta, experiments |
| [`evidence/`](evidence/) | Sanitized OS, display, Metal, ABI and kernel-binding captures |
| [`tools/`](tools/) | Read-only Metal and display probe sources |
| [`patches/`](patches/) | Installer/uninstaller diffs against the historical 1.2.0 package |
| [`archive/`](archive/) | Redacted historical helper sources for review |
| [`MANIFEST.sha256`](MANIFEST.sha256) | Checksums of the files in this publication |

## Credits and license

Maintained by [**icliberen**](https://github.com/icliberen). Base graphics work: **NullMoth Systems**, with **NVIDIA open GPU kernel modules**, **Mesa NVK**, and **metal2vulkan**. Additional credit goes to the authors of [#51](https://github.com/nullmoth/nvidia-macos-driver/issues/51), [#60](https://github.com/nullmoth/nvidia-macos-driver/pull/60), and [#59](https://github.com/nullmoth/nvidia-macos-driver/pull/59).

This repository uses **[PolyForm Noncommercial 1.0.0](LICENSE)**. Retain the license and required notices when sharing or modifying covered files. See [LICENSES.md](LICENSES.md) and [NOTICE](NOTICE) for scope and third-party attribution. Upstream components retain their own licenses.

The report makes no world-first claim. Its contribution is a documented early physical RTX 5060 Ti 16 GB / Ryzen / Tahoe configuration, reproducible basic Metal checks, and an honest record of the remaining problems.
