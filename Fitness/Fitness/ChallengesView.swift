//  ChallengesView.swift
//  Fitnic

import UIKit
import StoreKit

class ChallengesView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRestorePurchases: UIButton!
    var products = [SKProduct]()

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()
        doReadJsonData()

        self.loadProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(ChallengesView.handlePurchaseNotification(_:)), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doCallAnalytics(name: "Challenges Page", action: "View", label: "30 day Challenge page loaded")
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

    // MARK: - Load Products
    func loadProducts() {
        products = []
        tableView.reloadData()
        RageProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - UITableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengesCell", for:indexPath) as! challengesTableViewCell
        cell.imgLock.image = UIImage(named: "about_backarrow")

        cell.lblLevelName.text = challengesArray?[indexPath.row]["name"]
        switch indexPath.row {
            case 0 : break
            case 1 : if UserDefaults.standard.string(forKey: "intermediateprice") != "" {
                        cell.imgLock.image = UIImage(named: "lock_main")
                     }
            break
            case 2 : if UserDefaults.standard.string(forKey: "advancedprice") != "" {
                        cell.imgLock.image = UIImage(named: "lock_main")
                     }
            break
            default : break
        }

        cell.backgroundImageView.image = UIImage(named: (challengesArray?[indexPath.row]["backgroundimage"])!)
        cell.imgLevelThumb.image = UIImage(named: (challengesArray?[indexPath.row]["thumbimage"])!)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doCallAnalytics(name: "Challenges Page", action: "Touch", label: "Challenge selected")
        LevelIndex = indexPath.row

        switch indexPath.row {
            case 1 : if UserDefaults.standard.string(forKey: "intermediateprice") != "" {
                self.doCallInApp(index: indexPath)
                return
            }
            break
            case 2 : if UserDefaults.standard.string(forKey: "advancedprice") != "" {
                self.doCallInApp(index: indexPath)
                return
            }
            break
            default : break
        }

        let str = UserDefaults.standard.string(forKey: (challengesArray?[indexPath.row]["name"])!)
        if str?.characters.count == 0 {
            let actionSheetController: UIAlertController = UIAlertController(title: "Welcome to 30 Day Challenge!!", message: "Choose Exercise:", preferredStyle: .actionSheet)
            actionSheetController.view.tintColor = orangeColor
            for dict in arrThirtyDayExercises {
                let mDict = dict as! NSDictionary
                let sttitle: String = mDict.value(forKey: "categoryName") as! String
                actionSheetController.addAction(UIAlertAction(title: sttitle, style: .default, handler: doSomething))
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            })
            actionSheetController.addAction(cancelAction)

            if UIDevice.current.userInterfaceIdiom == .pad {
                actionSheetController.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
                actionSheetController.popoverPresentationController?.sourceRect = tableView.rectForRow(at: indexPath)
            }
            self.present(actionSheetController, animated: true, completion: nil)
        } else {
            selectedMainExercise = str!
            selectedLevel = (challengesArray?[LevelIndex]["name"])!

            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let iVC = storyboard.instantiateViewController(withIdentifier: "thirtydaychallenge") as! thirtyDayChallengeView
            self.present(iVC, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return UIScreen.main.bounds.height/1.2
        } else {
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                return 383
            } else {
                if (SCREENSIZE.height == 667) {
                    return 187
                } else if (SCREENSIZE.height == 736) {
                    return 206
                }
            }
            return 160
        }
    }

    // MARK: - IBAction Methods
    @IBAction func doRestorePurchases(_ sender: UIButton) {
        EZLoadingActivity.show("loading...", disableUI: true)
        RageProducts.store.restorePurchases()
    }

    // MARK: - UIApplication delegate Methods
    func doCallInApp (index: IndexPath) {
        var product: SKProduct = SKProduct()

        var priceIs : String = ""
        switch index.row {
        case 1: priceIs = intermediatePrice
            product = self.products[1]
            break
        case 2: priceIs = advancedPrice
            product = self.products[0]
            break
        default:
            break
        }

        let actionSheetController: UIAlertController = UIAlertController(title: "30 Day Challenge!!", message: "Would you like to unlock this level for \(priceIs) ?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            RageProducts.store.buyProduct(product)
            EZLoadingActivity.show("loading...", disableUI: true)
        })
        actionSheetController.addAction(action1)
        let action2 = UIAlertAction(title: "No", style: .default, handler: { (alert) in
        })
        actionSheetController.addAction(action2)
        self.present(actionSheetController, animated: true, completion: nil)
    }

    // MARK: - InApp purchase Methods
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        switch productID {
        case INTERMEDIATE_INAPP_BUNDLE:
            UserDefaults.standard.set("", forKey: "intermediateprice")
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            break
        case ADVANCE_INAPP_BUNDLE:
            UserDefaults.standard.set("", forKey: "advancedprice")
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
            break
        default:
            break
        }
        EZLoadingActivity.hide(true, animated: true)
    }

    // MARK: - UIAlertController Methods
    func doSomething(action: UIAlertAction) {
        UserDefaults.standard.set(action.title, forKey: (challengesArray?[LevelIndex]["name"])!)
        UserDefaults.standard.set(0, forKey: (challengesArray?[LevelIndex]["name"])!+"day")
        selectedMainExercise = action.title!
        selectedLevel = (challengesArray?[LevelIndex]["name"])!

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let iVC = storyboard.instantiateViewController(withIdentifier: "thirtydaychallenge") as! thirtyDayChallengeView
        self.present(iVC, animated: true, completion: nil)
    }
}
