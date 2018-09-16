//
//  ViewController.swift
//  PushHuliPizza
//
//  Created by Steven Lipton on 1/13/17.
//  Copyright © 2017 Steven Lipton. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var radioLabel: UILabel!
    @IBOutlet weak var channel: UITextField!
    @IBOutlet weak var channelURL: UITextField!
    @IBOutlet weak var channelPass: UITextField!
    @IBOutlet weak var channelUUID: UITextField!
    @IBOutlet weak var redOption: UISwitch!
    @IBOutlet weak var blueOption: UISwitch!
    @IBOutlet weak var greenOption: UISwitch!
    @IBOutlet weak var whiteOption: UISwitch!
    
    var channel4K: String?
    var channel4Pass: String?
    var channel4URL: String?
    
    @IBAction func showChannelWebVC(_ sender: Any) {
        channel4K = String(channel.text!).trimmingCharacters(in: .whitespacesAndNewlines)
        if channel4K != "" {
            appDelegate.tagZet.insert(channel4K!)
            let urlString = returnURLgivenKey(key2search: channel4K!, typeOf: ".URL")
            if urlString == nil {
                channelURL.isHidden = false
                channelPass.isHidden = false
                doURLnPassAnimation()
                channelURL.becomeFirstResponder()
            } else {
                doSafariVC(url2U: urlString!)
                
            }
        }
    }
    
    @IBAction func doChannelURL(_ sender: Any) {
        channel4URL = String(channelURL.text!).trimmingCharacters(in: .whitespacesAndNewlines)
        if channel4URL != "" {
            channelPass.becomeFirstResponder()
        }
    }
    
    @IBAction func doPass(_ sender: Any) {
        channel4Pass = String(channelPass.text!).trimmingCharacters(in: .whitespacesAndNewlines)
        if channel4Pass! == "" || channel4URL! == "" {
            showRules()
            return
        }
        let newUUID = UUID().uuidString
        channelUUID.text = newUUID
        doUUIDAnimation()
        storeURLgivenKey(key2Store: channel4K!, URL2Store: channel4URL!, pass2U: channel4Pass!)
        doSafariVC(url2U: channel4URL!)
    }
    
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
    
    func doSafariVC(url2U: String) {
        channel.text = ""
        channelPass.text = ""
        channelURL.text = ""
        channelURL.isHidden = true
        channelPass.isHidden = true
        channel.becomeFirstResponder()
        if let url = URL(string: url2U.trimmingCharacters(in: .whitespacesAndNewlines)) {
            if UIApplication.shared.canOpenURL(url) {
                let vc: SFSafariViewController
                if #available(iOS 11.0, *) {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = false
                    vc = SFSafariViewController(url: url, configuration: config)
                } else {
                    vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                }
                
                vc.delegate = self
                present(vc, animated: true)
            } else {
                
            }
        }
    }
    
    func doAnimation() {
        radioLabel.center.y -= view.bounds.height
        channel.center.y += view.bounds.height
        UIView.animate(withDuration: 1.0, delay: 0.25, options: [.curveEaseOut],
                       animations: {
                        self.radioLabel.center.y += self.view.bounds.height },
                        completion: {(status) in
                        // do nothing
            }
        )
        UIView.animate(withDuration: 1.0, delay: 0.25, options: [.curveEaseOut], animations: {
            self.channel.center.y -= self.view.bounds.height
        }) { (status) in
            // next
        }
        
    }
    
    func doURLnPassAnimation() {
        channelURL.center.x -= view.bounds.width
        channelPass.center.x += view.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseOut], animations: {
            self.channelURL.center.x += self.view.bounds.width
        }) { (status) in
            // next
        }
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseOut], animations: {
            self.channelPass.center.x -= self.view.bounds.width
        }) { (status) in
            // next
        }
    }
    
    func doUUIDAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseOut], animations: {
            self.channelUUID.alpha = 1.0
        }) { (status) in
            // next
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func whiteAction(_ sender: Any) {
        appDelegate.colorZet.insert("white")
    }
    
    @IBAction func greenAction(_ sender: Any) {
        appDelegate.colorZet.insert("green")
    }
    
    @IBAction func blueAction(_ sender: Any) {
        appDelegate.colorZet.insert("blue")
    }
    
    @IBAction func redAction(_ sender: Any) {
        appDelegate.colorZet.insert("red")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        channelURL.isHidden = true
        channelPass.isHidden = true
        channelUUID.alpha = 0.0
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        if !icloudStatus()! {
            // warn user needs cloudKit
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        doAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

