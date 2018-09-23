//
//  ConfigViewController.swift
//  PushHuliPizza
//
//  Created by localadmin on 20.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    


    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var stationsTable: UITableView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var messagesLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var lineText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    @IBAction func returnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        cloudDB.share.updateLine(lineName: newText, stationNames: stationsRegistered, linePassword: newPass)
    }
    
    func confirmRegistration() {
        let alert = UIAlertController(title: "Line registered", message: "Your new line is registered", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: textfield delegate
    
    var newText: String!
    var newPass: String!
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = verifyFields(textField: textField)
    }
    
    @IBAction func killLine(_ sender: UITextField) {
        if verifyFields(textField: sender) {
            deleteLine()
        }
    }
    
    func verifyFields(textField:UITextField) -> Bool {
        var result:Bool = false
        if textField.placeholder == "Password", lineText.text == "" {
            // no lineName do nothing
            return false
        }
        if textField.placeholder == "Line", passText.text == "" {
            // do password do nothing
            return false
        }
        newText = String(lineText.text!).trimmingCharacters(in: .whitespacesAndNewlines)
        newPass = String(passText.text!).trimmingCharacters(in: .whitespacesAndNewlines)
        let verify = linesDictionary[newText + newPass]
        if verify != nil {
            cloudDB.share.returnStationsOnLine(line2Seek: newText)
            result = true
        } else {
            passText.textColor = UIColor.red
            UIView.animate(withDuration: 0.75, delay: 0.25, options: [.curveEaseOut], animations: {
                self.passText.alpha = 0.0
            }) { (status) in
                self.passText.text = ""
                self.passText.alpha = 1.0
                self.passText.textColor = UIColor.black
            }
        }
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: tableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationsRegistered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = stationsRegistered[indexPath.row]
        cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBoldItalic", size: 20)
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.stationsTable.cellForRow(at: indexPath)?.textLabel?.text
            })
            alert.addAction(UIAlertAction(title: "Insert", style: .default, handler: { (updateAction) in
                self.stationsRegistered.insert("", at: indexPath.row)
                self.stationsTable.insertRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.stationsRegistered.remove(at: indexPath.row)
            tableView.reloadData()
        })
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = self.stationsTable.cellForRow(at: indexPath)?.textLabel?.text
        })
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
            self.stationsTable.cellForRow(at: indexPath)?.textLabel?.text = alert.textFields!.first!.text!
            self.stationsRegistered[indexPath.row] = alert.textFields!.first!.text!
            self.stationsTable.reloadRows(at: [indexPath], with: .fade)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
        
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Insert", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.stationsRegistered.insert("", at: indexPath.row)
            self.stationsTable.insertRows(at: [indexPath], with: .fade)
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.stationsRegistered.remove(at: indexPath.row)
            tableView.reloadData()
            success(true)
        })
        modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    // MARK: View methods
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var stationsRegistered:[String] = ["good","bad","ugly"]
    
    private func deleteLine() {
        let alert = UIAlertController(title: "", message: "Delete Line Item", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (updateAction) in
            cloudDB.share.deleteLine(lineName:self.newText,linePassword: self.newPass)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationsTable.rowHeight = 32
        lineText.delegate = self
        passText.delegate = self
        // Do any additional setup after loading the view.
//        let swipeLeft = UISwipeGestureRecognizer(target: lineText, action: #selector(ConfigViewController.deleteLine))
//        swipeLeft.direction = .left
//
//        self.view.addGestureRecognizer(swipeLeft)
    }
    
    private var pinObserver: NSObjectProtocol!
    private var pinObserver2: NSObjectProtocol!
    
    override func viewDidAppear(_ animated: Bool) {
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        let alert2Monitor = "confirmPin"
        let pinObserver = center.addObserver(forName: NSNotification.Name(rawValue: alert2Monitor), object: nil, queue: queue) { (notification) in
            self.confirmRegistration()
        }
        let alert2Monitor2 = "stationPin"
        pinObserver2 = center.addObserver(forName: NSNotification.Name(rawValue: alert2Monitor2), object: nil, queue: queue) { (notification) in
            self.stationsRegistered = stationsRead
            self.stationsTable.reloadData()
        }
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        tap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(tap)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let center = NotificationCenter.default
        if pinObserver != nil {
            center.removeObserver(pinObserver)
        }
        if pinObserver2 != nil {
            center.removeObserver(pinObserver2)
        }
//        if pinObserver3 != nil {
//            center.removeObserver(pinObserver2)
//        }
//        if pinObserver4 != nil {
//            center.removeObserver(pinObserver2)
//        }
    }
    
    
    
    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false
    
    
    
//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
    

    //    func doSafariVC(url2U: String) {
    //        channel.text = ""
    //        channelPass.text = ""
    //        channelURL.text = ""
    //        channelURL.isHidden = true
    //        channelPass.isHidden = true
    //        channel.becomeFirstResponder()
    //        if let url = URL(string: url2U.trimmingCharacters(in: .whitespacesAndNewlines)) {
    //            if UIApplication.shared.canOpenURL(url) {
    //                let vc: SFSafariViewController
    //                if #available(iOS 11.0, *) {
    //                    let config = SFSafariViewController.Configuration()
    //                    config.entersReaderIfAvailable = false
    //                    vc = SFSafariViewController(url: url, configuration: config)
    //                } else {
    //                    vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
    //                }
    //
    //                vc.delegate = self
    //                present(vc, animated: true)
    //            } else {
    //
    //            }
    //        }
    //    }
    
    //    func doAnimation() {
    //        radioLabel.center.y -= view.bounds.height
    //        channel.center.y += view.bounds.height
    //        UIView.animate(withDuration: 1.0, delay: 0.25, options: [.curveEaseOut],
    //                       animations: {
    //                        self.radioLabel.center.y += self.view.bounds.height },
    //                        completion: {(status) in
    //                        // do nothing
    //            }
    //        )
    //        UIView.animate(withDuration: 1.0, delay: 0.25, options: [.curveEaseOut], animations: {
    //            self.channel.center.y -= self.view.bounds.height
    //        }) { (status) in
    //            // next
    //        }
    //
    //    }
    
    //    func doURLnPassAnimation() {
    //        channelURL.center.x -= view.bounds.width
    //        channelPass.center.x += view.bounds.width
    //        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseOut], animations: {
    //            self.channelURL.center.x += self.view.bounds.width
    //        }) { (status) in
    //            // next
    //        }
    //        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseOut], animations: {
    //            self.channelPass.center.x -= self.view.bounds.width
    //        }) { (status) in
    //            // next
    //        }
    //    }
    //
    //    func doUUIDAnimation() {
    //        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseOut], animations: {
    //            self.channelUUID.alpha = 1.0
    //        }) { (status) in
    //            // next
    //        }
    //    }
    
    
    
    //    @IBAction func whiteAction(_ sender: Any) {
    //        appDelegate.colorZet.insert("white")
    //    }
    //
    //    @IBAction func greenAction(_ sender: Any) {
    //        appDelegate.colorZet.insert("green")
    //    }
    //
    //    @IBAction func blueAction(_ sender: Any) {
    //        appDelegate.colorZet.insert("blue")
    //    }
    //
    //    @IBAction func redAction(_ sender: Any) {
    //        appDelegate.colorZet.insert("red")
    //    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
