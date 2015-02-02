//
//  PlaySoundsViewController    .swift
//  Voice Transformer
//
//  Created by ssarber on 1/19/15.
//  Copyright (c) 2015 Zuk Gek. All rights reserved.
//

import UIKit
import AVFoundation



class PlaySoundsViewController: UIViewController {

    var audioEngine = AVAudioEngine()!
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
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
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        stopAndResetAudioEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch

        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.rate = 1.5
        audioPlayerNode.play()

    }
    
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBAction func playWetCave(sender: UIButton) {
        audioPlayer.stop()
        stopAndResetAudioEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 100
        
        audioEngine.attachNode(reverbEffect)
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }
    
    @IBAction func playDigreridoo(sender: UIButton) {
        audioPlayer.stop()
        stopAndResetAudioEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        
        var unitDistortion = AVAudioUnitDistortion()
        unitDistortion.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechGoldenPi)
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(unitDistortion)
        
        var mixerNode = audioEngine.mainMixerNode
        
        audioEngine.connect(audioPlayerNode, to: unitDistortion, format: audioFile.processingFormat)
        
        audioEngine.connect(unitDistortion, to: mixerNode, format: audioFile.processingFormat)
        
        audioEngine.connect(mixerNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
