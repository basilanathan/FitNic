//  Config.swift
//  Fitnic

import Foundation
import FirebaseAnalytics

var SCREENSIZE = UIScreen.main.bounds.size
var userInterface = UIDevice.current.userInterfaceIdiom

let APPDEL:AppDelegate = UIApplication.shared.delegate as! AppDelegate

let INTERMEDIATE_INAPP_BUNDLE = "com.basila.Intermediatelevel"
let ADVANCE_INAPP_BUNDLE = "com.basila.Advancedlevel"

let orangeColor = UIColor(red: 255.0/255.0, green: 129.0/255.0, blue: 97.0/255.0, alpha: 1.0)
//let orangeColor = UIColor(red: 240.0/255.0, green: 53.0/255.0, blue: 48.0/255.0, alpha: 1.0)

let intermediatePrice = "4.99$"
let advancedPrice = "5.99$"

//FILL OUT YOUR ADMOB BANNER IDs HERE
let ADMOB_BANNER_UNIT_ID = "ca-app-pub-2559845429793907/9898848671"
let ADMOB_INTERSTITIALS_UNIT_ID = "ca-app-pub-2559845429793907/2375581877"

let googleAanalyticsTrackingID = "UA-96199519-6"

let SHARE_TEXT = "Discover awesome workout & stay fit. You can download the app from app store for free  "

//Put your app id. You can find your App ID (Apple ID of the app) on itunes connect app information section
//format is XXXXXXXXX  for example : 1085214233
let APP_ID = "1228088572"

let youtubeBaseImageURL = "http://img.youtube.com/vi/"

let challengesArray:Array? = [
    ["name"            : "Beginner",
     "backgroundimage" : "about_beginging",
     "thumbimage"      : "beg_icon"],
    ["name"            : "Intermediate",
     "backgroundimage" : "about_inter",
     "thumbimage"      : "inter_icon"],
    ["name"            : "Advanced",
     "backgroundimage" : "about_advance",
     "thumbimage"      : "advamce_icon"]
]

var arrThirtyDayExercises:NSMutableArray = []

var selectedMainExercise = ""
var selectedLevel = "-1"
var LevelIndex: Int = -1
var selectedSubExerCise = ""
var SubExerCiseIndex = -1
var exerciseTime = 0
var currentDay = -1

func doReadJsonData() {
    if arrThirtyDayExercises.count > 0 {
        arrThirtyDayExercises.removeAllObjects()
    }
    guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileUrl = documentsDirectoryUrl.appendingPathComponent("30DayChallenge.json")
    do {
        let data = try Data(contentsOf: fileUrl, options: [])
        let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        arrThirtyDayExercises = ((jsonResult.value(forKey: "data")!) as! NSArray).mutableCopy() as! NSMutableArray
    } catch {
    }
}

func saveToJsonFile() {
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileUrl = documentDirectoryUrl.appendingPathComponent("30DayChallenge.json")
    do {
        let dict : NSMutableDictionary = NSMutableDictionary()
        dict.setValue(arrThirtyDayExercises, forKey: "data")
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        try data.write(to: fileUrl, options: [])
    } catch {
    }
}

// call Google Analytics
func doCallAnalytics(name: String, action: String, label: String) {
    DispatchQueue.main.async {
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(name)" as NSObject,
            kFIRParameterItemName: name as NSObject,
            kFIRParameterContentType: label as NSObject
            ])
    }
}
