//  WorkoutTimerViewController.swift
//  Fitness

import UIKit
import AudioToolbox

class WorkoutTimerViewController: UIViewController,cltimerDelegate {
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var workoutTimer: CLTimer!
    @IBOutlet weak var timerSegment: UISegmentedControl!

    var isTimerStarted = false

    let k5_MINUTES = 300
    let k10_MINUTES = 600
    let k15_MINUTES = 900
    let k20_MINUTES = 1200
    let k30_MINUTES = 1800
    var currentSecond = 300

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()

        if (UIDevice.current.userInterfaceIdiom == .pad) {
            var frame = self.workoutTimer.frame
            frame.size.width = 500
            frame.size.height = 500
            frame.origin.x = (self.view.frame.size.width - frame.size.width)/2
            self.workoutTimer.frame = frame

            frame = self.timerSegment.frame
            frame.size.width = 500
            frame.size.height = 50
            frame.origin.x = (self.view.frame.size.width - frame.size.width)/2
            frame.origin.y = self.workoutTimer.frame.origin.y + self.workoutTimer.frame.size.height + 30
            self.timerSegment.frame = frame

            frame = self.startBtn.frame
            frame.size.width = 350
            frame.size.height = 40
            frame.origin.x = (UIScreen.main.bounds.size.width - frame.size.width)/2
            frame.origin.y = self.timerSegment.frame.origin.y + self.timerSegment.frame.size.height + 50
            self.startBtn.frame = frame
            self.startBtn.titleLabel?.font = UIFont(name: (self.startBtn.titleLabel?.font.fontName)!, size: CGFloat(20))
        }

        self.startBtn.layer.cornerRadius = 5.0
        self.startBtn.layer.masksToBounds = true
    }

    // MARK: - IBAction Methods
    @IBAction func startBtnDidTap(_ sender: UIButton) {
        isTimerStarted = !isTimerStarted
        if isTimerStarted {
        //start timer
            sender.setTitle("STOP", for: UIControlState.normal)
            startTimer(withSecond: currentSecond)
        } else {
        //reset timer
            sender.setTitle("START", for: UIControlState.normal)
            resetTimer()
        }
    }

    @IBAction func durationSwitchedDidChange(_ sender: UISegmentedControl) {
        workoutTimer.stopTimer()
        workoutTimer.resetTimer()
        isTimerStarted = false
        startBtn.setTitle("START", for: UIControlState.normal)

        switch sender.selectedSegmentIndex {
        case 0:
            currentSecond = k5_MINUTES
            workoutTimer.updateText(timeValue: "5Min")
        case 1:
            currentSecond = k15_MINUTES
            workoutTimer.updateText(timeValue: "15Min")
        case 2:
            currentSecond = k20_MINUTES
            workoutTimer.updateText(timeValue: "20Min")
        case 3:
            currentSecond = k30_MINUTES
            workoutTimer.updateText(timeValue: "30Min")
        default:
            currentSecond = k5_MINUTES
            workoutTimer.updateText(timeValue: "5Min")
        }
    }

    // MARK: - Other Methods
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 129.0/255.0, blue: 97.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 252.0/255.0, green: 151.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func resetTimer() {
        workoutTimer.resetTimer()
    }

    func startTimer(withSecond:Int) {
        workoutTimer.startTimer(withSeconds: currentSecond, format: .Minutes, mode: .Reverse)
    }

    func playFinishSound () {
        if let soundURL = Bundle.main.url(forResource: "finish", withExtension: "aiff") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            AudioServicesPlaySystemSound(mySound);
        }
    }

    // MARK: - CLTimer Delegate Methods
    func timerDidStop(time: Int) {
    }

    func timerDidUpdate(time: Int) {
        if time == 0 {
            playFinishSound()
            isTimerStarted = false
            startBtn.setTitle("START", for: UIControlState.normal)
        }
    }
}
