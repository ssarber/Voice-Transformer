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

    
    var audioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
            var filePathUrl = NSURL.fileURLWithPath(filePath)
            var error: NSError?
            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: &error)
            audioPlayer.enableRate = true
            
        } else {
            NSLog("The file path is empty")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        playSound(0.5)
    }

    @IBAction func playSoundFast(sender: UIButton) {
        playSound(1.5)
    }

    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
    }
    
    func playSound(rate: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
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
