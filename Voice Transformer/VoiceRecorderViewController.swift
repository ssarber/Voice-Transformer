//
//  VoiceRecorderViewController.swift
//  Voice Transformer
//
//  Created by ssarber on 1/19/15.
//  Copyright (c) 2015 Zuk Gek. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceRecorderViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        tapToRecord.hidden = false
        recordButton.enabled = true
        stopButton.hidden = true

    }

    @IBAction func recordAudio(sender: UIButton) {
        tapToRecord.hidden = true
        recordButton.enabled = false
        stopButton.hidden = false
        recordingInProgress.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        var session = AVAudioSession.sharedInstance()
        
        do {
            // Direct the sound to speakers instead of headphones
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord,
                withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        } catch _ {
        }
        
        var emptyDic = [String: String]()
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: emptyDic)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            // Step 1 --Save the recorded audio
            // Calling constructor here
            recordedAudio = RecordedAudio(filePath: recorder.url, audioTitle:recorder.url.lastPathComponent)
          
            // Step 2 - Move to the next scene aka perform a segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            NSLog("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

