# Sharing test results

Reports from the same card or another board can help distinguish reproducible behavior from a single-machine result. Include:

- Exact GPU model and VRAM capacity, CPU, motherboard, OS version/build and driver source/release.
- Whether the AMD secondary card is installed or removed; which GPU drives the display.
- Resolution/refresh rate, boot behavior, relevant PASS/FAIL lines and remaining rendering problems.
- Whether changes were tested after a fresh boot or by live display-mode switching.

Remove SMBIOS serials, MLB/ROM/UUID data, monitor serial numbers, local account names and network details before publishing logs. Share focused text excerpts rather than a complete EFI or system diagnostic dump.

This repository maintains an integration report and historical helper source. For bugs in the base graphics driver, use the upstream NullMoth project's issue tracker and its current reporting instructions. If you reference this configuration, link to the exact commit and describe differences.

Contributions to covered files are under this repository's PolyForm Noncommercial 1.0.0 license. Preserve upstream credit and required notices. Changes to historical records should preserve dates and distinguish new observations from old evidence.
