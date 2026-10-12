import Foundation
import Metal
let devices = MTLCopyAllDevices()
print("Metal devices: \(devices.count)")
for d in devices {
    print("Device: \(d.name), registryID=\(String(d.registryID, radix:16))")
    do {
        let src = """
        #include <metal_stdlib>
        using namespace metal;
        kernel void verify_gpu(device uint *x [[buffer(0)]], uint i [[thread_position_in_grid]]) {
            x[i] = i * 3u + 7u;
        }
        """
        let lib = try d.makeLibrary(source: src, options: nil)
        let pipeline = try d.makeComputePipelineState(function: lib.makeFunction(name:"verify_gpu")!)
        guard let queue=d.makeCommandQueue(), let cmd=queue.makeCommandBuffer(),
              let buffer=d.makeBuffer(length:4096*MemoryLayout<UInt32>.stride,options:.storageModeShared),
              let enc=cmd.makeComputeCommandEncoder() else { print("FAIL: allocation");continue }
        memset(buffer.contents(),0,buffer.length)
        enc.setComputePipelineState(pipeline)
        enc.setBuffer(buffer,offset:0,index:0)
        enc.dispatchThreads(MTLSize(width:4096,height:1,depth:1),threadsPerThreadgroup:MTLSize(width:min(256,pipeline.maxTotalThreadsPerThreadgroup),height:1,depth:1))
        enc.endEncoding();cmd.commit();cmd.waitUntilCompleted()
        guard cmd.status == .completed else { print("FAIL: command \(String(describing:cmd.error))");continue }
        let values=buffer.contents().bindMemory(to:UInt32.self,capacity:4096)
        let ok=(0..<4096).allSatisfy { values[$0] == UInt32($0)*3+7 }
        print(ok ? "PASS: 4096 GPU-computed results match" : "FAIL: GPU results mismatch")
    } catch { print("FAIL: \(error)") }
}
