//
//  ViewController.swift
//  PushHuliPizza
//
//  Created by Steven Lipton on 1/13/17.
//  Copyright © 2017 Steven Lipton. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate, UITextFieldDelegate, URLSessionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pendingPostsButton: UIButton!
    @IBOutlet weak var linesPicker: UIPickerView!
    @IBOutlet weak var postingButton: UIButton!
    @IBOutlet weak var configButton: UIButton!
    @IBOutlet weak var stationsPicker: UIPickerView!
    @IBOutlet weak var previousPostsButton: UIButton!
    
    var stationsRegistered:[String] = ["English","French","Italian","German"]
    
    var channel4K: String?
    var channel4Pass: String?
    var channel4URL: String?
    var tokens:[String] = ["5effd4dfc158d922c877c1e3c99fd46296e2c1afcd080a63a2da397bce1c9bb3","f6e9345c225f508089e08a0de2480ab4cdafdebbabc8f1034f597570bc10c095"]
    
  
    
    
 
    
//    @IBAction func showChannelWebVC(_ sender: Any) {
//        channel4K = String(channel.text!).trimmingCharacters(in: .whitespacesAndNewlines)
//        if channel4K != "" {
//            appDelegate.tagZet.insert(channel4K!)
//            let urlString = returnURLgivenKey(key2search: channel4K!, typeOf: ".URL")
//            if urlString == nil {
////                channelURL.isHidden = false
////                channelPass.isHidden = false
////                doURLnPassAnimation()
////                channelURL.becomeFirstResponder()
//            } else {
//                doSafariVC(url2U: urlString!)
//
//            }
//        }
//    }
    
//    @IBAction func doChannelURL(_ sender: Any) {
//        channel4URL = String(channelURL.text!).trimmingCharacters(in: .whitespacesAndNewlines)
//        if channel4URL != "" {
////            channelPass.becomeFirstResponder()
//        }
//    }
    
//    @IBAction func doPass(_ sender: Any) {
//        channel4Pass = String(channelPass.text!).trimmingCharacters(in: .whitespacesAndNewlines)
//        if channel4Pass! == "" || channel4URL! == "" {
//            showRules()
//            return
//        }
//        let newUUID = UUID().uuidString
//        channelUUID.text = newUUID
//        doUUIDAnimation()
//        storeURLgivenKey(key2Store: channel4K!, URL2Store: channel4URL!, pass2U: channel4Pass!)
//        doSafariVC(url2U: channel4URL!)
//    }
    
    func showRules() {
        let alert = UIAlertController(title: "You need channel + http + password?", message: "You need a channel + http + password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func badURL() {
        let alert = UIAlertController(title: "Bad URL?", message: "Sorry, unable to open that URL \(channel4URL)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    var lineName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        channelURL.isHidden = true
//        channelPass.isHidden = true
//        channelUUID.alpha = 0.0
        
        
        // Do any additional setup after loading the view, typically from a nib.
//        if !icloudStatus()! {
//            // warn user needs cloudKit
//        }
        let defaults = UserDefaults.standard
        lineName = defaults.string(forKey: remoteRecords.lineName)
        let linePass = defaults.string(forKey: remoteRecords.linePassword)
//        stationsRegistered = (defaults.array(forKey: remoteRecords.stationNames) as? [String])!
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return stationsRegistered.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return stationsRegistered[row]
        } else {
            return "knowitall"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        doAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



