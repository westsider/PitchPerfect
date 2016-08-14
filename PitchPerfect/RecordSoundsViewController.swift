//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Warren Hansen on 8/12/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  output to speaker
//  use grad background
//  make sure icons dont autosize to fit and streatch

//  white icons?
//  add harmonizer?


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLable: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordAudio(sender: AnyObject) {
        
        print("Record Button was pressed")
        recordingLable.text = "Recording In Progress"
        stopButton.enabled = true
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
 
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        do{
            //Found this implemetation of AVAudiosessionPortOverride due to quietness during playback
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        }catch{
            print("could not set output to speaker")
        }
        //
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        

        
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func stopRecording(sender: AnyObject) {
        // In the stopRecordingAudio() function of RecordSoundsViewController(), set the shared instance to be inactive
        
        print("Stop Recording Button Pressed")
        recordButton.enabled = true
        stopButton.enabled = false
        recordingLable.text = "Tap To Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View Will Appear Called")
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving record")
        if (flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let recordAudioURL = sender as! NSURL
            playSoundVC.recordedAudioURL = recordAudioURL
        }
    }
    
    
    
    
    
    
}

