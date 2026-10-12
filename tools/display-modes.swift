import Foundation
import CoreGraphics
import Metal
var ids=[CGDirectDisplayID](repeating:0,count:16)
var n:UInt32=0
let result=CGGetActiveDisplayList(16,&ids,&n)
print("Active displays \(n), result \(result.rawValue)")
for id in ids.prefix(Int(n)) {
 print("DISPLAY \(id) main=\(CGDisplayIsMain(id)) GPU=\(CGDirectDisplayCopyCurrentMetalDevice(id)?.name ?? "unknown")")
 if let current=CGDisplayCopyDisplayMode(id) { print("Current id=\(current.ioDisplayModeID), \(current.width)x\(current.height), pixels=\(current.pixelWidth)x\(current.pixelHeight), hz=\(current.refreshRate)") }
 guard let modes=CGDisplayCopyAllDisplayModes(id,[kCGDisplayShowDuplicateLowResolutionModes:true] as CFDictionary) as? [CGDisplayMode] else {continue}
 for m in modes where m.width==2560 && m.height==1440 && m.pixelWidth==2560 && m.pixelHeight==1440 {print("MODE \(m.ioDisplayModeID) \(m.width)x\(m.height) hz=\(m.refreshRate) flags=\(m.ioFlags)")}
}
