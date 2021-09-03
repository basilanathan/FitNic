//  ViewController.swift
//  Fitness

import UIKit
import GoogleMobileAds
import FirebaseDatabase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var data : NSMutableArray = NSMutableArray()
    var ref:FIRDatabaseReference!

    func fetchDataFromFirebase() {
        EZLoadingActivity.show("loading...", disableUI: true)
        ref = FIRDatabase.database().reference()
        ref.observe(.value, with: { (snapshot) in
            let dataDict = snapshot.value as! NSDictionary
            print(dataDict)
            self.data = dataDict["data"] as! NSMutableArray
            self.tableView.reloadData()
            EZLoadingActivity.hide()
        })
    }

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()

        tableView.delegate = self
        fetchDataFromFirebase()
        tableView.reloadData()

        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doCallAnalytics(name: "Main Page", action: "View", label: "Main page loaded")
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

    func orientationChanged() {
        tableView.reloadData()
        doCallAnalytics(name: "Main Page", action: "devicerotate", label: "Orientation changed")
    }

    // MARK: - UITableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for:indexPath) as! MainViewTableViewCell
        let rowData = self.data[indexPath.row] as! NSDictionary
        let imageName  = rowData["imageName"] as! String
        let url = URL(string: imageName)
        cell.backgroundImageView.sd_setImage(with: url, placeholderImage: nil, options: .handleCookies)
        cell.categoryLabel.text = rowData["categoryName"] as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doCallAnalytics(name: "Main Page", action: "Touch", label: "Cell Item selected")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let categoryViewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        let rowData = self.data[indexPath.row] as! NSDictionary
        categoryViewController.categoryTitle = rowData["categoryName"] as! String
        let categoryData = rowData["category"] as! NSMutableArray
        categoryViewController.data = categoryData
        print(categoryData)
        self.present(categoryViewController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return UIScreen.main.bounds.height/1.5
        } else {
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                return 360
            }
            return 200
        }
    }

    // MARK: - IBAction Methods
    @IBAction func shareBtnDidTap(_ sender: UIButton) {
        doCallAnalytics(name: "Main Page", action: "Touch", label: "Share button clicked")
        let ITUNES_BASE_URL = "https://itunes.apple.com/app/id"
        let shareText = SHARE_TEXT + ITUNES_BASE_URL + APP_ID
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            let popoverController = UIPopoverController(contentViewController: activityViewController)
            popoverController.present(from: sender.frame, in: self.view, permittedArrowDirections: .any, animated: true)
        } else {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
