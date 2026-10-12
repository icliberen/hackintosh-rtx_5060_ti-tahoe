# Recorded rebuild procedure

The successful local build used upstream source without tracked code edits. It did not implement a new Tahoe ABI fix in source; rebuilding made the existing ABI 2 source replace a stale Tahoe binary.

Source: `nullmoth/nvidia-macos-driver`, commit `c7dc26239bf85a648d5318fde135ebc09dc094a3` (1.2.0).
Headers: `NVIDIA/open-gpu-kernel-modules`, commit `e4a5faa2567f28c8eabe0ebb6422b6d0abcf37eb`.

Run manually in a separate workspace after fetching the pinned repositories:

```sh
git clone https://github.com/nullmoth/nvidia-macos-driver.git source
git -C source checkout --detach c7dc26239bf85a648d5318fde135ebc09dc094a3
git clone https://github.com/NVIDIA/open-gpu-kernel-modules.git ogkm610
git -C ogkm610 checkout --detach e4a5faa2567f28c8eabe0ebb6422b6d0abcf37eb
OGKM="$PWD/ogkm610" bash source/build/accel_build.sh "$PWD/source/kexts/NVRM" "$PWD/rebuilt/15"
NM_TAHOE=1 OGKM="$PWD/ogkm610" bash source/build/accel_build.sh "$PWD/source/kexts/NVRM" "$PWD/rebuilt/26"
```

This produces NVAccel only; it is not the full installed graphics stack. The successful original experiment used NVRM, NVRMFB, NVRMAGDC, GPU bundles, NVK and firmware from the official 1.2.0 package, with the rebuilt Tahoe NVAccel and reviewed installer patches. Fetch that release from the upstream project and retain all its notices. Its binaries are not bundled here.

See the pinned upstream build script for required SDK/toolchain/dependencies. The exact historical build-tool version was not independently reconstructed in this audit. Different toolchains or signatures may produce a different binary hash; a matching source checkout alone does not establish bit-for-bit reproducibility.

The historical SHA-256 is `e8da3758d89efaa5b0c77701b4cd19f59a0f631f7c43af9dfb3524605d961cb7` for Tahoe NVAccel. Historical checks verified ABI 2, symbol tables and successful binding of four kexts in an isolated AuxKC. A first comparison against older 1.1.0 symbols failed; it was corrected against 1.2.0 after reviewing the two new removal-control imports. The initial failure is not a runtime failure of the final build.

## Read-only compute check

```sh
xcrun swiftc tools/check-metal.swift -o /tmp/rtx-tahoe-metal-check
/tmp/rtx-tahoe-metal-check
```

Read the named NVIDIA device's PASS/FAIL line, not only the command exit status. This basic shader validates `x[i] = i * 3 + 7` for 4,096 elements; it does not qualify all rendering APIs or performance.

Historical archived installers are deliberately not provided as a turnkey installer. They are pinned to one OS build, personal EFI identity, package hashes and backup state; redaction makes some placeholders invalid. Do not run them unchanged or use the old patches on newer upstream packages without reviewing the differences.
