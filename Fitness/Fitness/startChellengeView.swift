//  startChellengeView.swift
//  Fitnic

import UIKit
class startChellengeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblExercises: UITableView!

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblExercises.backgroundView?.backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear

        self.setGradientBackground()
        self.lblTitle.text = "Day \(currentDay+1) of 30"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<arrThirtyDayExercises.count {
            let mDict = arrThirtyDayExercises.object(at: i) as! NSDictionary
            if (mDict.value(forKey: "categoryName") as! String) == selectedMainExercise {
                let sArray: NSArray = mDict.value(forKey: selectedLevel) as! NSArray
                let exArray: NSArray = (sArray.object(at: currentDay) as AnyObject).value(forKey: "exlist") as! NSArray

                var flag:Int = 0
                for j in 0..<exArray.count {
                    let exName = exArray.object(at: j) as? String
                    if exName == "REST" {
                        let exkey = selectedMainExercise + selectedLevel + "\(currentDay)" + exName! + "\(j)"
                        UserDefaults.standard.set("", forKey: exkey)
                        flag = 0
                        break
                    }

                    let exkey = selectedMainExercise + selectedLevel + "\(currentDay)" + exName! + "\(j)"
                    if UserDefaults.standard.string(forKey: exkey) == nil {
                        flag = 1
                        break
                    }
                }
                if flag == 0 {
                    UserDefaults.standard.set(currentDay+1, forKey: selectedLevel+"day")

                    let actionSheetController: UIAlertController = UIAlertController(title: "Congratulations", message: "You are done with todays workout", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    actionSheetController.addAction(action1)
                    self.present(actionSheetController, animated: true, completion: nil)
                }
            }
        }
        self.tblExercises.reloadData()
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

    // MARK: - Other Methods
    @IBAction func doBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var mDict = NSDictionary()
        for dict in arrThirtyDayExercises {
            mDict = dict as! NSDictionary
            if (mDict.value(forKey: "categoryName") as! String) == selectedMainExercise {
                break
            }
        }
        let sArray: NSArray = mDict.value(forKey: selectedLevel) as! NSArray
        let exArray: NSArray = (sArray.object(at: currentDay) as AnyObject).value(forKey: "exlist") as! NSArray
        exerciseTime = (sArray.object(at: currentDay) as AnyObject).value(forKey: "time") as! Int

        return exArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        let checkimage = self.view.viewWithTag(111) as? UIImageView

        var mDict = NSDictionary()
        for dict in arrThirtyDayExercises {
            mDict = dict as! NSDictionary
            if (mDict.value(forKey: "categoryName") as! String) == selectedMainExercise {
                break
            }
        }
        let sArray: NSArray = mDict.value(forKey: selectedLevel) as! NSArray
        let exArray: NSArray = (sArray.object(at: currentDay) as AnyObject).value(forKey: "exlist") as! NSArray

        let exName = exArray.object(at: indexPath.row) as? String
        let exkey = selectedMainExercise + selectedLevel + "\(currentDay)" + exName! + "\(indexPath.row)"
        if UserDefaults.standard.string(forKey: exkey) == nil {
            checkimage?.image = UIImage(named: "cross")
        } else {
            checkimage?.image = UIImage(named: "tick")
        }

        let exLabel = cell.viewWithTag(112) as? UILabel
        exLabel?.textAlignment = NSTextAlignment.left
        exLabel?.text = exName
        if exName == "REST" {
            checkimage?.image = UIImage(named: "tick")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let exLabel = cell.viewWithTag(112) as? UILabel
        if exLabel?.text == "REST" {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let iVC = storyboard.instantiateViewController(withIdentifier: "challengetimer") as! challengetimer
        selectedSubExerCise = (exLabel?.text)!
        SubExerCiseIndex = indexPath.row
        self.present(iVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
