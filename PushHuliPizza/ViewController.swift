//
//  ViewController.swift
//  PushHuliPizza
//
//  Created by Steven Lipton on 1/13/17.
//  Copyright © 2017 Steven Lipton. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate, UITextFieldDelegate, URLSessionDelegate {

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
    var tokens:[String] = ["5effd4dfc158d922c877c1e3c99fd46296e2c1afcd080a63a2da397bce1c9bb3","f6e9345c225f508089e08a0de2480ab4cdafdebbabc8f1034f597570bc10c095"]
    
//    fileprivate var secIdentity: SecIdentity?
//
//    fileprivate func identityFor(_ certificatePath: String, passphrase: String) -> SecIdentity? {
//        let PKCS12Data = try? Data(contentsOf: URL(fileURLWithPath: certificatePath))
//        let passPhraseKey : String = kSecImportExportPassphrase as String
//        let options = [passPhraseKey : passphrase]
//        var items : CFArray?
//        let ossStatus = SecPKCS12Import(PKCS12Data! as CFData, options as CFDictionary, &items)
//        guard ossStatus == errSecSuccess else {
//            return nil
//        }
//        let arr = items!
//        if CFArrayGetCount(arr) > 0 {
//            let newArray = arr as [AnyObject]
//            let secIdentity =  newArray[0][kSecImportItemIdentity as String] as! SecIdentity
//            return secIdentity
//        }
//        return nil
//    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var items: CFArray?
        
        let urlPath = Bundle.main.bundleURL.appendingPathComponent("Cert.p12")
        let contentOf = try? Data(contentsOf:urlPath)
        
        let certOptions:NSDictionary = [kSecImportExportPassphrase as NSString:"0244941651" as NSString]
        SecPKCS12Import(contentOf! as NSData, certOptions, &items)
        let certItems:Array = (items! as Array)
        let dict:Dictionary<String, AnyObject> = certItems.first! as! Dictionary<String, AnyObject>
        
        let label = dict[kSecImportItemLabel as String] as? String
        let keyID = dict[kSecImportItemKeyID as String] as? Data
        let trust = dict[kSecImportItemTrust as String] as! SecTrust?
        let certChain = dict[kSecImportItemCertChain as String] as? Array<SecTrust>
        let identity = dict[kSecImportItemIdentity as String] as! SecIdentity?
        
        let credentials = URLCredential(identity: identity!, certificates: certChain, persistence: .forSession)
        completionHandler(.useCredential,credentials)
    }
    
    
    @IBAction func push(_ sender: Any) {
        var apnsSub = ["alert":"hello"]
        var apnsPayload = ["aps":apnsSub]
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        var loginRequest = URLRequest(url: URL(string: "https://api.sandbox.push.apple.com/3/device/5effd4dfc158d922c877c1e3c99fd46296e2c1afcd080a63a2da397bce1c9bb3")!)
        loginRequest.allHTTPHeaderFields = ["apns-topic": "ch.cqd.PushHuliPizza",
                                            "content-type": "application/x-www-form-urlencoded"
        ]
        loginRequest.httpMethod = "POST"
        let data = try? JSONSerialization.data(withJSONObject: apnsPayload, options:[])
        if let content = String(data: data!, encoding: String.Encoding.utf8) {
            // here `content` is the JSON dictionary containing the String
            print(content)
        }
        loginRequest.httpBody = data
        print("apnsPayLoad \(data)")
        let loginTask = session.dataTask(with: loginRequest) { data, response, error in
            print("error \(error) \(response)")
        }
        loginTask.resume()
    }
    
//    func fucked() {
//        let stringPath = Bundle.main.path(forResource: "Cert", ofType: "p12")
//        guard let apns = APNS(certificatePath: stringPath!, passphrase: "0244941651") else {
//            print("Failed to create APNS object")
//            return
//        }
//
//        var apnsOptions = APNS.Options()
//        apnsOptions.topic = "Weekend deal"
//        apnsOptions.port = .p2197
//        apnsOptions.expiry = Date()
//        apnsOptions.development = false
//        apnsOptions.priority = 10
//
//        let certificateIdentity = getIdentity(password: "0244941651")
//        let apnsConnection = APNS(identity: certificateIdentity!, options: apnsOptions)
//
//        let json: String = "{\"aps\":{\"title\":\"cest marche\",\"body\":\"We're doing pizza today\"},\"badge\":42,\"sound\":\"default\",\"category\":\"pizza.category\",\"mutable-content\":1},\"color\":\"blue\",\"tag\":\"knowitall\"}"
//
////        let json: String = "{\"aps\":{\"title\":\"cest marche\",\"body\":\"We're doing pizza today\"}}"
//
//        let jsonPayLoad = json.data(using: String.Encoding.utf8)
//        try! apnsConnection.sendPush(tokenList: tokens, payload: jsonPayLoad!) {
//            (apnsResponse) in
//            Swift.print("\n\(apnsResponse.deviceToken)")
//            Swift.print("  Status: \(apnsResponse.serviceStatus)")
//            Swift.print("  APNS ID: \(apnsResponse.apnsId ?? "")")
//            print("\(apnsResponse.errorReason)")
//            if let errorReason = apnsResponse.errorReason {
//                Swift.print("  ERROR: \(errorReason.description)")
//            }
//        }
//    }
//
//    func getIdentity (password : String?) -> SecIdentity? {
//        // Load certificate file
//        let path = Bundle.main.path(forResource: "Certificates", ofType : "p12")
//        let p12KeyFileContent = NSData(contentsOfFile: path!)
//
//        if (p12KeyFileContent == nil) {
//            NSLog("Cannot read PKCS12 file from \(path)")
//            return nil
//        }
//
//        // Setting options for the identity "query"
//        let options = [String(kSecImportExportPassphrase):password ?? ""]
//        var citems: CFArray? = nil
//        let resultPKCS12Import = withUnsafeMutablePointer(to: &citems) { citemsPtr in
//            SecPKCS12Import(p12KeyFileContent!, options as CFDictionary, citemsPtr)
//        }
//        if (resultPKCS12Import != errSecSuccess) {
//            return nil
//        }
//
//        // Recover the identity
//        let items = citems! as NSArray
//        let myIdentityAndTrust = items.object(at: 0) as! NSDictionary
//        let identityKey = String(kSecImportItemIdentity)
//        let identity = myIdentityAndTrust[identityKey] as! SecIdentity
//
//        print("identity : ", identity)
//
//        return identity as SecIdentity
//    }
    
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



