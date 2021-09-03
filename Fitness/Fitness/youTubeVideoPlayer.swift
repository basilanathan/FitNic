//  youTubeVideoPlayer.swift
//  Fitnic

import UIKit

class youTubeVideoPlayer: UIViewController, YTPlayerViewDelegate {
    var videoID: String!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()
        playerView.delegate = self
        playerView.load(withVideoId: videoID)
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

    @IBAction func doBack (_ sender : AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }

    func playerView(_ playerView:YTPlayerView, didChangeTo didChangeToState:YTPlayerState) {
        print ("\(didChangeToState)")
    }
}
