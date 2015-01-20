//
//  ViewController.swift
//  Voice Transformer
//
//  Created by ssarber on 1/19/15.
//  Copyright (c) 2015 Zuk Gek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true

    }

    @IBAction func recordAudio(sender: UIButton) {
        NSLog("recordng audio")
        recordButton.enabled = false
        stopButton.hidden = false
        recordingInProgress.hidden = false
    }
    
    @IBAction func stopRecording(sender: UIButton) {

        recordingInProgress.hidden = true
    }
}

