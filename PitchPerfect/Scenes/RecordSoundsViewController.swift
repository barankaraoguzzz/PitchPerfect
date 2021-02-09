//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by BARAN BATUHAN KARAOGUZ on 8.02.2021.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    // MARK: Properties
    
    var audioRecorder: AVAudioRecorder!
    var actionType: ActionType = .stop {
        didSet {
            configureUiByActionType()
            actionByType()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    //MARK: - IBActions
    
    @IBAction func didTapRecordAudioButton(_ sender: AnyObject) {
        actionType = .recording
    }
    
    @IBAction func didTapStopRecordingButton(_ sender: AnyObject) {
        actionType = .stop
    }
    
    //MARK: - Private methods
    
    ///Actions
    private func configureUiByActionType() {
        stopRecordingButton.isEnabled = actionType == .stop ? false : true
        recordButton.isEnabled = actionType == .stop ? true : false
        recordingLabel.text = Alerts.getAlerts(by: actionType)
    }
    
    private func actionByType() {
        switch actionType {
        case .recording:
            self.recordAudio()
        case .stop:
            self.stopRecording()
        }
    }
    
    ///Avfoundation helper
    private func recordAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    private func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //MARK: - Overriding methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.ShowPlaySoundsSegue {
            if let playSoundsViewController = segue.destination as? PlaySoundsViewController, let url = sender as? URL {
                playSoundsViewController.recordedAudioURL = url
            }
        }
    }
    
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: SegueIdentifier.ShowPlaySoundsSegue, sender: audioRecorder.url)
        }
        else {
            print("Sorry audio recorder can't record the voice ⚠️")
        }
    }
}

extension RecordSoundsViewController {
    
    struct Alerts {
        static private let Recording = "Recording in Progress"
        static private let StopRecording = "Tap to Record"
        
        static func getAlerts(by type: ActionType) -> String {
            switch type {
            case .recording:
                return Recording
            case .stop:
                return StopRecording
            }
        }
    }
    
    struct SegueIdentifier {
        static let ShowPlaySoundsSegue = "stopRecording"
    }
    
    enum ActionType {
        case recording
        case stop
    }
    
}
