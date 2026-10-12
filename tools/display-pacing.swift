import Foundation
import CoreGraphics
import CoreVideo
let id=CGMainDisplayID()
var link:CVDisplayLink?
guard CVDisplayLinkCreateWithCGDisplay(id,&link)==kCVReturnSuccess,let link=link else {print("STOP: display link creation failed");exit(1)}
final class Samples {let lock=NSLock();var stamps=[UInt64]()}
let samples=Samples()
let context=Unmanaged.passUnretained(samples).toOpaque()
CVDisplayLinkSetOutputCallback(link,{_,_,_,_,_,ctx in
 let s=Unmanaged<Samples>.fromOpaque(ctx!).takeUnretainedValue();s.lock.lock();s.stamps.append(DispatchTime.now().uptimeNanoseconds);s.lock.unlock();return kCVReturnSuccess
},context)
print("Display \(id), nominal period \(CVDisplayLinkGetNominalOutputVideoRefreshPeriod(link).timeValue)/\(CVDisplayLinkGetNominalOutputVideoRefreshPeriod(link).timeScale)")
CVDisplayLinkStart(link);Thread.sleep(forTimeInterval:5);CVDisplayLinkStop(link)
samples.lock.lock();let stamps=samples.stamps;samples.lock.unlock()
let values=zip(stamps.dropFirst(),stamps).map {Double($0.0-$0.1)/1e6}.sorted()
if !values.isEmpty {print("callbacks=\(stamps.count) median_ms=\(values[values.count/2]) p95_ms=\(values[min(values.count-1,Int(Double(values.count)*0.95))]) max_ms=\(values.last!) mean_ms=\(values.reduce(0,+)/Double(values.count))")}
