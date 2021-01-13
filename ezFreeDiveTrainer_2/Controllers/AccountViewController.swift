//
//  AccountViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit
import MessageUI

class AccountViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myEmailLabel: UILabel!
    
    var cellText = ["版本", "回報問題", "隱私政策"]
    var version = ""
    let email = MFMailComposeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account"
        let dictionary = Bundle.main.infoDictionary!
        version = dictionary["CFBundleShortVersionString"] as! String
        print("versionversionversionversion\(version)")

        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        myImageView.backgroundColor = UIColor.clear
        print("\(myImageView.frame.size.width)")
        print("\(myImageView.frame.size.width)")

        myNameLabel.text = "CCY"
        myEmailLabel.text = "yyyy@gamil.com"
        
        SubFunctions.shared.imageSet(image: myImageView, name: "people", c1: "#f6d365", c2: "#fda085", lineWidth: 10.0)
        
        email.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["tylersoooong79@hotmail.com.tw"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            mail.setEditing(true, animated: true)
            mail.setSubject("🌟 ezFreeDiveTrainer")
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

}
extension AccountViewController: UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            sendEmail()
        } else if indexPath.row == 2 {
            
        } else {
            
        }
    }
}
extension AccountViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.text = self.cellText[indexPath.row]
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = "\(version)"
            cell.accessoryType = .none
            return cell
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = ""
            return cell
        }
        
    }
    
    
}
