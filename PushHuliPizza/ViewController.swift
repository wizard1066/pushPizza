//
//  ViewController.swift
//  PushHuliPizza
//
//  Created by Steven Lipton on 1/13/17.
//  Copyright © 2017 Steven Lipton. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var radioLabel: UILabel!
    @IBOutlet weak var channel: UITextField!
    @IBOutlet weak var channelURL: UITextField!
    @IBOutlet weak var channelPass: UITextField!
    
    @IBAction func showChannelWebVC(_ sender: Any) {
        if channel.text != "" {
            let urlString = returnURLgivenKey(key2search: channel.text!, typeOf: ".URL")
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
        if channelURL.text != "" {
            channelPass.becomeFirstResponder()
        }
    }
    
    @IBAction func doPass(_ sender: Any) {
        if channelURL.text! == "" || channelURL.text! == "" {
            showRules()
            return
        }
        storeURLgivenKey(key2Store: channel.text!, URL2Store: channelURL.text!, pass2U: channelPass.text!)
        doSafariVC(url2U: channelURL.text!)
    }
    
    func showRules() {
        let alert = UIAlertController(title: "You need channel + http + password?", message: "You need a channel + http + password", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func doSafariVC(url2U: String) {
        channel.text = ""
        channelPass.text = ""
        channelURL.text = ""
        channelURL.isHidden = true
        channelPass.isHidden = true
        channel.becomeFirstResponder()
        if let url = URL(string: url2U) {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        channelURL.isHidden = true
        channelPass.isHidden = true
        
        
        
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

