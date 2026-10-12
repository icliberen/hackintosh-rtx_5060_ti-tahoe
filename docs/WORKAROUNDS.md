# Successful and unsuccessful experiments

| Experiment | Recorded result | Interpretation |
| --- | --- | --- |
| Make RTX visible in EFI | PCI 10de:2d04 appeared | Prerequisite only, not acceleration |
| Rebuild Tahoe NVAccel using current ABI 2 source | Four kexts linked; basic Metal compute passed after installation | Existing upstream diagnosis/build path applied locally |
| Only NVIDIA DP active | Refused-frame growth stopped; user reported improvement | AMD GPU still installed; dual-output setup not qualified |
| Runtime zero-copy flip | 759 flips / 10 s, no refused flips in recorded sample; visible trails resolved | Existing upstream feature enabled |
| Remove temporary `-nvrmnoflip` restriction | Automatic flip confirmed after restart | Existing upstream 60 s enable delay retained |
| Live 180 Hz, automatic numerical 85 Hz rollback | Black/gray output; rollback did not visually recover | No safe general live modeset fix established |
| `flip_lean=0` at 120 Hz | Input/mouse-triggered blackouts remained | Failed candidate |
| `nvaccel_iop_async=0` at 120 Hz | Blackouts remained | Failed candidate |
| Fresh 120 Hz then 180 Hz sessions after restart | User confirmed usable output | Some icon errors remained; not a driver patch or proof of mechanism |
| SecurityAgent NVIDIA deny | Separate process probes passed; user confirmed visible password prompts | RX 6800-dependent workaround, not translator feature implementation |
| loginwindow NVIDIA deny | Actual first boot login stayed gray | Failed candidate; still active during current audit |
| EFI `SetupVirtualMap=False` | Earlier boot hung | Failed diagnostic; final saved config kept original True |
| Working config copied to SSD EFI | Hash match, 355 other files unchanged | Separate boot-source verification not recorded |

The process list is first-match-wins. A deny entry precedes the wildcard. No interposition library was installed into Apple's SecurityAgent or WindowServer; the test interposer was used only in separate, unprivileged probe processes.

The currently installed process list includes both `-loginwindow` and `-SecurityAgent`. The former failed to resolve the actual boot screen and should not be represented as a successful fix. This audit has not changed that list, the installed drivers, EFI, refresh rate or NVRAM.

Archived scripts are historical records. Read-only audit probes were executed; archived mutation helpers were not rerun. Do not use hardcoded hashes, redacted placeholders or stale build-specific installers as generic instructions.

## Later RTX-only confirmation

The owner confirmed operation with RX 6800 removed on 12 October 2026. The captured two-GPU tests and AMD fallback experiments above remain historical evidence. See [RTX-ONLY.md](RTX-ONLY.md) for the separate owner report and its scope.
