//  challengetimer.swift
//  Fitnic

import UIKit
class challengetimer: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblexname: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnStartTimer: UIButton!
    @IBOutlet weak var btnStopTimer: UIButton!

    var exTime = 0
    var mTimer = Timer()

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()
        exTime = exerciseTime

        self.lblTitle.text = "Day \(currentDay+1) of 30"

        self.btnStartTimer.layer.borderColor = UIColor.white.cgColor
        self.btnStartTimer.layer.borderWidth = 2.0
        self.btnStartTimer.layer.cornerRadius = self.btnStartTimer.frame.size.width/2
        self.btnStartTimer.layer.masksToBounds = true

        self.btnStopTimer.layer.borderColor = UIColor.white.cgColor
        self.btnStopTimer.layer.borderWidth = 2.0
        self.btnStopTimer.layer.cornerRadius = self.btnStopTimer.frame.size.width/2
        self.btnStopTimer.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblexname.text = selectedSubExerCise
        self.lblTimer.text = "\(exerciseTime)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    func dotimercall() {
        exerciseTime = exerciseTime - 1
        self.lblTimer.text = "\(exerciseTime)"

        if ( exerciseTime <= 0 ) {
            mTimer.invalidate()
            UserDefaults.standard.set(currentDay, forKey: (challengesArray?[LevelIndex]["name"])!+"day")

            var mDict = NSDictionary()
            var cInd = 0
            for dict in arrThirtyDayExercises {
                mDict = dict as! NSDictionary
                if (mDict.value(forKey: "categoryName") as! String) == selectedMainExercise {
                    break
                }
                cInd = cInd + 1
            }

            let sArray: NSArray = mDict.value(forKey: selectedLevel) as! NSArray
            let exArray: NSArray = (sArray.object(at: currentDay) as AnyObject).value(forKey: "exlist") as! NSArray

            let exLabel = self.view.viewWithTag(112) as? UILabel
            exLabel?.textAlignment = NSTextAlignment.left
            exLabel?.text = exArray.object(at: SubExerCiseIndex) as? String

            let exkey = selectedMainExercise + selectedLevel + "\(currentDay)" + selectedSubExerCise + "\(SubExerCiseIndex)"
            UserDefaults.standard.set("", forKey: exkey)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func doBack(_ sender: UIButton) {
        if mTimer.isValid {
            mTimer.invalidate()
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func doStart(_ sender: UIButton) {
        if mTimer.isValid {
            return
        }
        mTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(dotimercall), userInfo: nil, repeats: true)
    }

    @IBAction func doStop(_ sender: UIButton) {
        if mTimer.isValid {
            mTimer.invalidate()
        }
    }
}
