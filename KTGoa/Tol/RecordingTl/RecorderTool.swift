//
//  RecorderTool.swift
//  Golaa
//
//  Created by chenkaisong on 2024/5/15.
//

import UIKit
import AVFoundation

enum RecordMsgStatus {
    /// 停止录音 录音未开始
    case stop
    /// 录音失败
    case fail
    /// 录音结束
    case end
}

/// 录音结果的回调
typealias RecordResultCompletion = (_ duration: Int, _ path: String) -> Void

/// 回调录音状态
typealias CallBackRecordMsgStatus  = (_ status: RecordMsgStatus) -> Void

class RecorderTool: NSObject {
    var duration = 0
    
    /// 录音结束
    var blockResultCom: RecordResultCompletion?
    /// 录音状态
    var blockRecordStatus: CallBackRecordMsgStatus?
    
    static let shared  = RecorderTool()
    
    private override init() {
        super.init()
        NIMSDK.shared().mediaManager.add(self)
    }
    
    private func recordCallStatus(_ status: RecordMsgStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.blockRecordStatus?(status)
        }
    }
    
    /// 开始录音
    func beginRcordss() {
        NIMSDK.shared().mediaManager.record(forDuration: TimeInterval(60))
    }
    
    /// 停止录音
    func stopRecord() {
        timer?.cancel()
        NIMSDK.shared().mediaManager.stopRecord()
    }
    
    /// 取消录音
    func canceRecord() {
        NIMSDK.shared().mediaManager.cancelRecord()
        duration = 0
    }

}

extension RecorderTool: NIMMediaManagerDelegate {
    
    func recordAudioProgress(_ currentTime: TimeInterval) {
       // print("录音时长======: \(currentTime)")
        duration = Int(currentTime)
    }
    
    func recordAudioInterruptionEnd() {
       // print("录音结束被打断回调")
        blockRecordStatus?(.fail)
    }
    
    func recordAudioInterruptionBegin() {
      // print("录音开始被打断回调")
        blockRecordStatus?(.fail)
    }
    
    func recordAudio(_ filePath: String?, didCompletedWithError error: (any Error)?) {
       // print("didCompletedWithError path: \(String(describing: filePath)) Error: \(String(describing: error))")

        if error != nil {
            // 录音失败
            blockRecordStatus?(.fail)
            return
        }
        
        guard let path = filePath else { return }
        
        if duration < 1 {
            blockRecordStatus?(.stop)
            duration = 0
            return
        }
        
        blockResultCom?(duration, path)
        blockRecordStatus?(.end)
        duration = 0
    }
}
