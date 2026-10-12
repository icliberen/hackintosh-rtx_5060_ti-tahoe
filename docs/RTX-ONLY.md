# Operation without the RX 6800

On 12 October 2026, the machine's owner, **icliberen**, confirmed that this setup also works **without the RX 6800 installed**. The repository records that confirmation as owner-tested RTX-only operation.

## Evidence attribution

| Record | GPU configuration | What it establishes |
| --- | --- | --- |
| 9–10 October bring-up and saved Metal probes | RTX 5060 Ti + RX 6800 installed | Historical driver integration and basic Metal computation on each GPU |
| 12 October automated display and Metal captures | Both GPUs still present in the captured inventory | NVIDIA-driven 1440p/180 Hz display and repeated NVIDIA compute correctness |
| Owner confirmation on 12 October | RX 6800 removed | Owner-tested operation without the secondary AMD card |

No separate diagnostic capture of the RX-removed configuration is included yet. The owner's statement does not specify a new compute benchmark, exact refresh rate, or which historical UI problems remain in that configuration. Do not attribute the two-GPU captures to the standalone test or assume every historical workaround applies to it.

The `-SecurityAgent` workaround used in the original investigation depended on native RX 6800 Metal remaining available. The failed `-loginwindow` candidate also attempted AMD fallback. Neither is presented as a validated solution for NVIDIA-only authorization or boot-login rendering.

Future standalone evidence can consist of sanitized `sw_vers`, `system_profiler SPDisplaysDataType`, and the included Metal probe output, with no AMD device present. Such output would supplement the owner's confirmation rather than change the historical captures.
