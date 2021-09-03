//  thirtyDayChallengeView.swift
//  Fitnic

import UIKit
import GoogleMobileAds

class thirtyDayChallengeView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GADInterstitialDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var lblExerCiseName: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var myCollection: UICollectionView!

    // Interstitials
    var interstitials:GADInterstitial?

    // MARK: - Admob Methods
    func loadInsterstitials() {
        interstitials = GADInterstitial(adUnitID: ADMOB_INTERSTITIALS_UNIT_ID)
        interstitials?.delegate = self
        interstitials?.load(GADRequest())
    }

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.isReady {
            ad.present(fromRootViewController: self)
        }
    }

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()

        self.lblTitle.text = selectedLevel

        var cornerValue:CGFloat = 5.0
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            cornerValue = 10.0
        }

        var frame = self.myCollection.frame
        frame.origin.y = self.lblExerCiseName.frame.origin.y + self.lblExerCiseName.frame.size.height + 10
        frame.size.height = SCREENSIZE.height - frame.origin.y - 100
        self.myCollection.frame = frame

        self.progress.transform = self.progress.transform.scaledBy(x: 1.1, y: 5.5)
        self.progress.clipsToBounds = true
        self.progress.layer.cornerRadius = cornerValue
        self.progress.layer.masksToBounds = true

        self.lblExerCiseName.text = UserDefaults.standard.string(forKey: selectedLevel)

        loadInsterstitials()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doCallAnalytics(name: "Challenges Page", action: "View", label: "30 day Challenge page loaded")

        self.doRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 129.0/255.0, blue: 97.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 252.0/255.0, green: 151.0/255.0, blue: 85.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func doRefresh() {
        let days = UserDefaults.standard.integer(forKey: selectedLevel+"day")
        self.lblProgress.text = "Progress \((days*100)/30)%"
        let progs: Float = Float(Float(days)/30.0)
        self.progress.progress = progs
        self.myCollection.reloadData()
    }

    // MARK: - Other Methods
    @IBAction func doPreview(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let iVC = storyboard.instantiateViewController(withIdentifier: "exercisepreviewlist") as! exercisePreviewList
        self.present(iVC, animated: true, completion: nil)
    }

    @IBAction func doReset(_ sender: UIButton) {
        let alertView = UIAlertController(title: "Reset", message: "Are you sure want to reset this level ? This will erase all information related to this level.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Reset", style: .default, handler: { (alert) in
            self.doResetAllSubExercises()
            UserDefaults.standard.set(0, forKey: (challengesArray?[LevelIndex]["name"])!+"day")
            self.doRefresh()

            let levelName:String = (challengesArray?[LevelIndex]["name"])!
            UserDefaults.standard.set("", forKey: levelName)

            let alert: UIAlertView = UIAlertView()
            alert.title = "Alert"
            alert.message = "You have successfully reset \(levelName) Level. Now you can select exersice again & restart 30 day challenge."
            alert.addButton(withTitle: NSLocalizedString("ok", comment: ""))
            alert.show()
            self.dismiss(animated: true, completion: nil)
        })
        alertView.addAction(action1)
        let action2 = UIAlertAction(title: "No", style: .destructive, handler: { (alert) in
        })
        alertView.addAction(action2)
        self.present(alertView, animated: true, completion: nil)
    }

    func doResetAllSubExercises() {
        for j in 0..<arrThirtyDayExercises.count {
            let mDict = arrThirtyDayExercises.object(at: j) as! NSDictionary
            if (mDict.value(forKey: "categoryName") as! String) == selectedMainExercise {
                let arr = mDict.value(forKey: selectedLevel) as! NSArray
                for k in 0..<arr.count {
                    let exDict = arr.object(at: k) as! NSDictionary
                    let arrEx = exDict.value(forKey: "exlist") as! NSArray
                    for i in 0..<arrEx.count {
                        let exkey = selectedMainExercise + selectedLevel + "\(k)" + (arrEx.object(at: i) as! String) + "\(i)"
                        UserDefaults.standard.set(nil, forKey: exkey)
                    }
                }
            }
        }
    }

    @IBAction func doBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - UICollectionView Methods
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thirtyCell", for: indexPath) as! thirtydayCollectionviewCell
        cell.backgroundColor = UIColor.clear
        cell.lblChallengeDay.text = "\(indexPath.row+1)"
        cell.imgCheckMark.isHidden = true

        let days = UserDefaults.standard.integer(forKey: selectedLevel+"day")
        if indexPath.row+1 <= days {
            cell.imgCheckMark.isHidden = false
            cell.lblChallengeDay.text = ""
        } else {
            cell.imgCheckMark.isHidden = true
        }

        let mSize = SCREENSIZE.width / 6
        if userInterface == .pad {
            cell.lblChallengeDay.layer.cornerRadius = (mSize-54)/2
        } else {
            if (SCREENSIZE.height == 568) {
                cell.lblChallengeDay.layer.cornerRadius = (mSize-20)/2
            } else if (SCREENSIZE.height == 667) {
                cell.lblChallengeDay.layer.cornerRadius = (mSize-25)/2
            } else if (SCREENSIZE.height == 736) {
                cell.lblChallengeDay.layer.cornerRadius = (mSize-30)/2
            }
        }
        cell.lblChallengeDay.layer.masksToBounds = true
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let mSize = SCREENSIZE.width / 6
        return CGSize(width:mSize, height:mSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! thirtydayCollectionviewCell
        let cday = UserDefaults.standard.integer(forKey: selectedLevel+"day")
        if cell.imgCheckMark.isHidden {
            if cday == indexPath.row {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let iVC = storyboard.instantiateViewController(withIdentifier: "startChellengeView") as! startChellengeView
                currentDay = indexPath.row
                self.present(iVC, animated: true, completion: nil)
            } else {
                let alert: UIAlertView = UIAlertView()
                alert.title = "Hey"
                alert.message = "Please complete previous day workouts first."
                alert.addButton(withTitle: NSLocalizedString("ok", comment: ""))
                alert.show()
            }
        }
    }
}
