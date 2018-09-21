//
//  PostingViewController.swift
//  PushHuliPizza
//
//  Created by localadmin on 20.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import UIKit

class PostingViewController: UIViewController, URLSessionDelegate {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyText: UITextView!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var soundByteButton: UIButton!
    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var URLButton: UIButton!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var returnLabel: UIButton!
    
    @IBAction func returnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var dropNdragButton: UIButton!
    

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
    
    @IBAction func postAction(_ sender: UIButton) {
        var apnsSubSub = ["title":titleTextField.text,"body":bodyText.text]
        var apnsSub = ["alert":apnsSubSub]
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
    

        
}
