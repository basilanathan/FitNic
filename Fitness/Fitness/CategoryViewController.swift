//  CategoryViewController.swift
//  Fitnic

import UIKit
import GoogleMobileAds

class CategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var data : NSMutableArray = NSMutableArray()
    var categoryTitle = ""

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!

    // MARK: - Admob banner
    func loadAdmobBanner() {
        bannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()

        doCallAnalytics(name: "CategoryViewController Page", action: "View", label: "Category view appeared")

        self.lblTitle.text = categoryTitle
        self.tableView.delegate = self

        var frame = self.bannerView.frame
        frame.origin.y = self.view.frame.size.height - frame.size.height
        self.bannerView.frame = frame

        loadAdmobBanner()
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryViewController.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
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
    func orientationChanged() {
        doCallAnalytics(name: "CategoryViewController Page", action: "rotateDevice", label: "Orientation Changed")
        tableView.reloadData()
    }

    @IBAction func doBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for:indexPath) as! CategoryTableViewCell
        let rowData = self.data[indexPath.row] as! NSDictionary
        cell.trainingNameLabel.text = rowData["shortDesc"] as? String

        let imageUrl = rowData["url"] as! String
        let imageQuality = rowData["imageQuality"] as! String
        let urlPath = youtubeBaseImageURL + imageUrl + "/" + imageQuality + ".jpg"
        let url = URL(string: urlPath)
        cell.backgroundImageView.sd_setImage(with: url, placeholderImage: nil, options: .handleCookies)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doCallAnalytics(name: "CategoryViewController Page", action: "Touch", label: "Video Item selected")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let pVC = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        let rowData = self.data[indexPath.row] as! NSDictionary
        let imageUrl = rowData["url"] as! String
        let imageQuality = rowData["imageQuality"] as! String

        pVC.videoTitle = (rowData["shortDesc"] as! String).replacingOccurrences(of: "\n", with: "")
        pVC.urlPath = imageUrl
        pVC.about = rowData["about"] as! String
        pVC.imageURL = youtubeBaseImageURL + imageUrl + "/" + imageQuality + ".jpg"
        self.present(pVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return UIScreen.main.bounds.height/1.2
        } else {
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                return 360
            }
            return 200
        }
    }
}
