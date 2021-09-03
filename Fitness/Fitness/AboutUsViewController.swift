//  AboutUsViewController.swift
//  Fitnic

import UIKit
import MessageUI

class AboutUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var btnSendMail: UIButton!
    @IBOutlet weak var btnVisitWebsite: UIButton!

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()

        var thumbHeight:CGFloat = 216
        var btnFont:CGFloat = 13
        var btnWidth:CGFloat = 280
        var btnHeight:CGFloat = 35
        var spacing:CGFloat = 15
        var btnspacing:CGFloat = 8
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            thumbHeight = 518
            btnFont = 20
            btnWidth = 450
            btnHeight = 40
            spacing = 30
            btnspacing = 15
        } else {
            if (SCREENSIZE.height == 667) {
                thumbHeight = 253
            } else if (SCREENSIZE.height == 736) {
                thumbHeight = 279
            }
        }

        var frame = self.imgThumb.frame
        frame.size.height = thumbHeight
        self.imgThumb.frame = frame

        frame = self.txtAbout.frame
        frame.origin.y = self.imgThumb.frame.origin.y + self.imgThumb.frame.size.height + spacing
        self.txtAbout.frame = frame
        self.txtAbout.font = UIFont(name: (self.txtAbout.font?.fontName)!, size: btnFont)
        self.txtAbout.textColor = UIColor.darkGray
        self.txtAbout.sizeToFit()

        frame = self.btnSendMail.frame
        frame.size.width = btnWidth
        frame.size.height = btnHeight
        frame.origin.x = (UIScreen.main.bounds.size.width - frame.size.width)/2
        frame.origin.y = self.txtAbout.frame.origin.y + self.txtAbout.frame.size.height + spacing
        self.btnSendMail.frame = frame
        self.btnSendMail.titleLabel?.font = UIFont(name: (self.btnSendMail.titleLabel?.font.fontName)!, size: btnFont)

        frame = self.btnVisitWebsite.frame
        frame.size.width = btnWidth
        frame.size.height = btnHeight
        frame.origin.x = (UIScreen.main.bounds.size.width - frame.size.width)/2
        frame.origin.y = self.btnSendMail.frame.origin.y + self.btnSendMail.frame.size.height + btnspacing
        self.btnVisitWebsite.frame = frame
        self.btnVisitWebsite.titleLabel?.font = UIFont(name: (self.btnVisitWebsite.titleLabel?.font.fontName)!, size: btnFont)

        self.btnSendMail.layer.cornerRadius = 5.0
        self.btnSendMail.layer.masksToBounds = true
        self.btnVisitWebsite.layer.cornerRadius = 5.0
        self.btnVisitWebsite.layer.masksToBounds = true
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
    @IBAction func doSendEmail(_ sender: UIButton) {
        let toRecipents = ["fitnicfit@gmail.com"]
        let mailer: MFMailComposeViewController = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        mailer.setSubject("Feedback Fitnic App")
        mailer.setToRecipients(toRecipents)
        let messageBody = "Hi,\n\n"
        mailer.setMessageBody(messageBody as String, isHTML: false)
        self.present(mailer, animated: true, completion: nil)
    }

    @IBAction func doVisitWebSite(_ sender: UIButton) {
        let url = URL(string: "https://fitnic.fit")!
        UIApplication.shared.openURL(url)
    }

    // MARK: - MFMailComposeViewController Method
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            NSLog("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            NSLog("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            NSLog("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            NSLog("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismiss(animated: false, completion: nil)
    }
}
