//
//  ConfigViewController.swift
//  PushHuliPizza
//
//  Created by localadmin on 20.09.18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationsRegistered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = stationsRegistered[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                print("\(indexPath.row) \(self.stationsTable.cellForRow(at: indexPath))")
                textField.text = self.stationsTable.cellForRow(at: indexPath)?.textLabel?.text
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                self.stationsTable.cellForRow(at: indexPath)?.textLabel?.text = alert.textFields!.first!.text!
                self.stationsRegistered[indexPath.row] = alert.textFields!.first!.text!
                self.stationsTable.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
//            stationsTable.remove(at: indexPath.row)
            tableView.reloadData()
        })
        
        return [deleteAction, editAction]
    }

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var lineButton: UITextField!
    @IBOutlet weak var passwordButton: UITextField!
    @IBOutlet weak var stationsTable: UITableView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var messagesLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    @IBAction func returnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var stationsRegistered:[String] = ["English","French","Italian","German"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

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
