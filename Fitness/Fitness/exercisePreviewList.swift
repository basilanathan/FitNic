//  exercisePreviewList.swift
//  Fitnic

import UIKit
class exercisePreviewList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblPreviewList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblPreviewList.backgroundView?.backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        self.setGradientBackground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    // MARK: - Other Methods
    @IBAction func doback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableView Methods
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
//        vw.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5)

        if section != 0 {
            let line = UILabel(frame: CGRect(x: (SCREENSIZE.width-250)/2, y: 0, width: 250, height: 1.0))
            line.backgroundColor = UIColor.white
            line.text = ""
            vw.addSubview(line)
        }

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: 45))
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Day \(section+1)"
        vw.addSubview(label)
        return vw
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 30
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
        let exArray: NSArray = (sArray.object(at: section) as AnyObject).value(forKey: "exlist") as! NSArray

        return exArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        var mDict = NSDictionary()
        for dict in arrThirtyDayExercises {
            mDict = dict as! NSDictionary
            if (mDict.value(forKey: "categoryName") as! String) == selectedMainExercise {
                break
            }
        }
        let sArray: NSArray = mDict.value(forKey: selectedLevel) as! NSArray
        let exArray: NSArray = (sArray.object(at: indexPath.section) as AnyObject).value(forKey: "exlist") as! NSArray
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.textLabel?.text = exArray.object(at: indexPath.row) as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
