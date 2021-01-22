//
//  AccountViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit
import MessageUI
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class AccountViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var myEmailLabel: UILabel!
    
    var cellText = ["Version", "Report", "Privacy Policy", "LogIn"]
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
        
        // 新增手勢
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapClick(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(tapRecognizer)
        
        //登入後通知
        NotificationCenter.default.addObserver(self, selector: #selector(updataProfile), name: .ProfileDidChange, object: nil)
        
    }
    @objc func updataProfile() {
        if let profile = Profile.current{
            self.myNameLabel.text = profile.name
        }
    }
    // 手勢響應方法
    @objc func tapClick(recognizer:UITapGestureRecognizer) {
        print("Tap")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
//        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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

extension AccountViewController: LogInViewControllerDelegate {
    func appleDidLonIn(name: String, email: String) {
        self.myEmailLabel.text = email
        self.myNameLabel.text = name
    }
    
    func fbDidLogIn(email: String) {
        self.myEmailLabel.text = email
    }
    
}

extension AccountViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.myImageView.image = image/*.resize(newSize: CGSize(width: 100, height: 100))*/
        self.dismiss(animated: true, completion: nil)
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
            
        } else if indexPath.row == 3 {
            //Login
            let vc = storyboard?.instantiateViewController(identifier: "logInVC") as! LogInViewController
            vc.delegate = self
            show(vc, sender: true)
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
