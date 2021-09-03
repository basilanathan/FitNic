//  PlayerViewController.swift
//  Fitnic

import UIKit
import GoogleMobileAds

class PlayerViewController: UIViewController {
    // Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var aboutTextView: UITextView!

    @IBOutlet weak var lblWorkOutDetailTitle: UILabel!
    @IBOutlet weak var btnPlayVideo: UIButton!

    // Variables
    var videoTitle = ""
    var urlPath = ""
    var about = ""
    var imageURL = ""

    // MARK: - UIViewController Methods
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()

        let url = URL(string: imageURL)
        self.thumbImage.sd_setImage(with: url)

        self.lblTitle.text = self.videoTitle
        aboutTextView.text = about
        self.perform(#selector(PlayerViewController.scrollToTop), with: nil, afterDelay: 0.5)

        if (UIDevice.current.userInterfaceIdiom == .pad) {
            var frame = self.thumbImage.frame
            frame.size.height = 400
            self.thumbImage.frame = frame

            frame = self.btnPlayVideo.frame
            frame.size.height = 400
            self.btnPlayVideo.frame = frame

            frame = self.lblWorkOutDetailTitle.frame
            frame.origin.y = self.thumbImage.frame.origin.y + self.thumbImage.frame.size.height
            self.lblWorkOutDetailTitle.frame = frame
        }

        var frame = self.aboutTextView.frame
        frame.origin.y = self.lblWorkOutDetailTitle.frame.origin.y + self.lblWorkOutDetailTitle.frame.size.height + 15
        frame.size.height = self.view.frame.size.height - frame.origin.y - 10
        self.aboutTextView.frame = frame
        self.aboutTextView.textColor = UIColor.darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doCallAnalytics(name: "PlayerViewController Page", action: "View", label: "Video Player Page appeared")
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
    @IBAction func doPlayVideo(_ sender: UIButton) {
        let myStoryboard: UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let objController: youTubeVideoPlayer = myStoryboard.instantiateViewController(withIdentifier: "youTubeVideoPlayer") as! youTubeVideoPlayer
        objController.videoID = self.urlPath
        self.present(objController, animated: false, completion: nil)
    }

    @IBAction func doBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func scrollToTop() {
        aboutTextView.setContentOffset(CGPoint.zero, animated: true)
    }
}
