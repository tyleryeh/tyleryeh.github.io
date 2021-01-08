//
//  DiarySetViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/4.
//

import UIKit

class DiaryNoteSetViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionVIewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var myInfoLabelForThings: UILabel!
    @IBOutlet weak var myInfoLabelForDive: UILabel!
    
    var location = ""
    var moodemoji = ""
    var weater = ""
    var tepeturMax = ""
    var tepeturMin = ""
    
    var weatherInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionVIewLayout.minimumInteritemSpacing = 1
        myCollectionVIewLayout.scrollDirection = .horizontal
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        myCollectionView.backgroundColor = UIColor.clear
        
        //設定文字myInfoLabeForThings
//        let content = NSMutableAttributedString(string: "蘭嶼 • ")
//        let weaterImage = NSTextAttachment()
//        let moodImage = NSTextAttachment()
//
//        weaterImage.image = UIImage(named: "sun")
//        weaterImage.bounds = CGRect(x: 0, y: -4.5, width: 20, height: 20)
//        content.append(NSAttributedString(attachment: weaterImage))
//        content.append(NSAttributedString(string: " • 23°C • "))
//
//        moodImage.image = UIImage(named: "shock")
//        moodImage.bounds = CGRect(x: 0, y: -4.5, width: 20, height: 20)
//        content.append(NSAttributedString(attachment: moodImage))
//
//        myInfoLabelForThings.attributedText = content
        
    }
    
    func updateLabelForThings(label: UILabel, location: String, weater: String, temMax: String, temMin: String, moodemoji: String) {
        
        let content = NSMutableAttributedString()
        if location != "" {
            content.append(NSAttributedString(string: "\(location) • "))
        }
        if weater != "" && temMax != "" && temMin != "" {
            
//            let filterString = weater.startIndex
            var weaImage = ""
            switch weater {
            case "晴":
                weaImage = "sun"
            case "多雲":
                weaImage = "cloudy"
            case "陰":
                weaImage = "cloud"
            default:
                weaImage = "rain"
            }
            
            let weaterImage = NSTextAttachment()
            weaterImage.image = UIImage(named: "\(weaImage)")
            weaterImage.bounds = CGRect(x: 0, y: -4.5, width: 20, height: 20)
            content.append(NSAttributedString(attachment: weaterImage))
            
            content.append(NSAttributedString(string: " • \(temMin)-\(temMax)°C • "))
        }
        if moodemoji != "" {
            let moodImage = NSTextAttachment()
            moodImage.image = UIImage(named: "\(moodemoji)")
            moodImage.bounds = CGRect(x: 0, y: -4.5, width: 20, height: 20)
            content.append(NSAttributedString(attachment: moodImage))
        }
        label.attributedText = content
    }

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

}

extension DiaryNoteSetViewController: UICollectionViewDelegate {
    
}
extension DiaryNoteSetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DiaryMyCollectionViewCell
        
        cell.myBtn.layer.cornerRadius = cell.myBtn.frame.height / 2
        cell.myBtn.layer.masksToBounds = true
        cell.myBtn.backgroundColor = UIColor.clear
        
        if indexPath.row == 0 {
            cell.myBtn.setImage(UIImage(named: "camera"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(cameraBtn), for: .touchUpInside)
        } else if indexPath.row == 1 {
            cell.myBtn.setImage(UIImage(named: "diving"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(divingBtn), for: .touchUpInside)
        } else if indexPath.row == 2 {
            cell.myBtn.setImage(UIImage(named: "cheeky"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(moodBtn(_:)), for: .touchUpInside)
        } else if indexPath.row == 3{
            cell.myBtn.setImage(UIImage(named: "placeholder"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(loactionBtn), for: .touchUpInside)
        } else {
            cell.myBtn.setImage(UIImage(named: "cloudy"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(weatherBtn), for: .touchUpInside)
        }
        
        return cell
    }
    //相機
    @objc func cameraBtn() {
        print("cameraBtn")
    }
    //裝備
    @objc func divingBtn() {
        print("divingBtn")
    }
    //心情
    @objc func moodBtn(_ sender: Any) {
        print("cheekyBtn")
        let button = sender as? UIButton
        let buttonFrame = button?.frame ?? CGRect.zero
        
        let popoverViewSize = CGSize(width: 320, height: 100)
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "MoodVC") as? MoodViewController
        //設定彈出來多少
        popoverContentController?.preferredContentSize = popoverViewSize
        popoverContentController?.modalPresentationStyle = .popover
        
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = sender as? UIView
            popoverPresentationController.sourceRect = buttonFrame
            popoverPresentationController.delegate = self
            
            if let popoverController = popoverContentController {
                //MARK: moodDelegate
                popoverController.delegate = self
                present(popoverController, animated: true, completion: nil)
            }
        }
    }
    //定位
    @objc func loactionBtn() {
        print("placeholderBtn")
        let vc = storyboard?.instantiateViewController(identifier: "mapVC") as! MapViewController
        show(vc, sender: nil)
    }
    //天氣
    @objc func weatherBtn() {
        print("cloudyBtn")
        let vc = storyboard?.instantiateViewController(identifier: "weatherVC") as! WeatherViewController
        vc.delegate = self
        show(vc, sender: nil)
    }
    
    
}
//MARK: UIPopoverPresentationControllerDelegate
extension DiaryNoteSetViewController: UIPopoverPresentationControllerDelegate{
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

//MARK: MoodViewControllerDelegate
extension DiaryNoteSetViewController: MoodViewControllerDelegate, WeatherViewControllerDelegate {
    func didUpdateWeatherInfo(updateWeatherInfo: [String]) {
        //hard code....
        location = updateWeatherInfo[0]
        weater = updateWeatherInfo[1]
        tepeturMax = updateWeatherInfo[2]
        tepeturMin = updateWeatherInfo[3]
        updateLabelForThings(label: myInfoLabelForThings, location: location, weater: weater, temMax: tepeturMax, temMin: tepeturMin, moodemoji: moodemoji)
    }
    
    func didUpdateMoodEmoji(emojiString: String) {
        print("emojiString: \(emojiString)")
        moodemoji = emojiString
        updateLabelForThings(label: myInfoLabelForThings, location: location, weater: weater, temMax: tepeturMax, temMin: tepeturMin, moodemoji: moodemoji)
        
    }
    
}
