//
//  PlaySoundsViewController    .swift
//  Voice Transformer
//
//  Created by ssarber on 1/19/15.
//  Copyright (c) 2015 Zuk Gek. All rights reserved.
//

import UIKit
import AVFoundation


@IBDesignable class PlaySoundsViewController: UIViewController {

    var audioEngine = AVAudioEngine()
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                selector: #selector(stopAndResetAudioEngine),
                                name: AVAudioEngineConfigurationChangeNotification,
                                object: audioEngine)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        stopAndResetAudioEngine()
        playSound(0.5)
    }

    @IBAction func playSoundFast(sender: UIButton) {
        stopAndResetAudioEngine()
        playSound(2)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Experimental sound -- Work in Progress!
    @IBAction func experiment(sender: UIButton) {
        
        audioPlayer.stop()
        stopAndResetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        
        let unitDistortion = AVAudioUnitDistortion()
        unitDistortion.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechWaves)
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(unitDistortion)
        
        let mixerNode = audioEngine.mainMixerNode
        
        audioEngine.connect(audioPlayerNode, to: unitDistortion, format: audioFile.processingFormat)
        
        audioEngine.connect(unitDistortion, to: mixerNode, format: audioFile.processingFormat)
        
        audioEngine.connect(mixerNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            audioPlayerNode.play()
        } catch _ {}
        
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        stopAndResetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch

        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            audioPlayerNode.rate = 1.5
            audioPlayerNode.play()
        } catch _ {}
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
        stopAndResetAudioEngine()
    }
    
    @IBAction func playWetCave(sender: UIButton) {
        audioPlayer.stop()
        stopAndResetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 100
        
        audioEngine.attachNode(reverbEffect)
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.prepare()
        do {
            try audioEngine.start()
            audioPlayerNode.play()
        } catch _ {}
    }
    
    @IBAction func playDigreridoo(sender: UIButton) {
        audioPlayer.stop()
        stopAndResetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        
        let unitDistortion = AVAudioUnitDistortion()
        unitDistortion.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechGoldenPi)
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(unitDistortion)
        
        let mixerNode = audioEngine.mainMixerNode
        
        audioEngine.connect(audioPlayerNode, to: unitDistortion, format: audioFile.processingFormat)
        
        audioEngine.connect(unitDistortion, to: mixerNode, format: audioFile.processingFormat)
        
        audioEngine.connect(mixerNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
            audioPlayerNode.play()
        } catch _ {}
        
        audioPlayerNode.play()
    }
    

    func playSound(rate: Float) {
        audioPlayer.stop()
        audioPlayer.prepareToPlay()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    func stopAndResetAudioEngine() {
            audioEngine.stop()
            audioEngine.reset()
    }

}
