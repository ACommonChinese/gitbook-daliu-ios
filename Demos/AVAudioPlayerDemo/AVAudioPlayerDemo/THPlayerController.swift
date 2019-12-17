//
//  THPlayerController.swift
//  AVAudioPlayerDemo
//
//  Created by banma-1118 on 2019/12/13.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

import UIKit
import AVFoundation

class THPlayerController: NSObject {
    var isPlaying: Bool = false
    var players: Array<AVAudioPlayer>
    
    /// 初始化
    override init() {
        super.init()
        
        self.players = []
    }
    
    func playerForFile(name: String) -> AVAudioPlayer {
        let fileURL = Bundle.main.url(forResource: name, withExtension: "caf")!
        let guitarPlayer: AVAudioPlayer = AVAudioPlayer(contentsOf: fileURL)
        // Call can throw, but it is not marked with 'try' and the error is not handled
        return guitarPlayer
    }
    
    /// 播放
    func play() {
        
    }
    
    /// 停止
    func stop() {
        
    }
    
    /// 调整播放速率
    func adjustRate(rate: CGFloat) {
        
    }
    
    /// 调整立体声道播放
    func adjustPan(pan: CGFloat, index: Int) {
        
    }
    
    /// 调整音量
    func adjustVolume(volume: CGFloat, index: Int) {
        
    }
}
