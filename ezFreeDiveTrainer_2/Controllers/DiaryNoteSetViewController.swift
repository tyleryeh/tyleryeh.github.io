//
//  DiarySetViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/4.
//

import UIKit
import CoreData

protocol DiaryNoteSetViewControllerDelegate: class {
    func didFinishSetNote(note: TableData, isNotToday: Bool)
}

class DiaryNoteSetViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionVIewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var myInfoLabelForThings: UILabel!
    @IBOutlet weak var myInfoLabelForDiveSite: UILabel!
    @IBOutlet weak var myshadowView: UIView!
    @IBOutlet weak var myInnerView: UIView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var noteName: UITextField!
    
    weak var delegate: DiaryNoteSetViewControllerDelegate?
    
    var location = ""
    var moodemoji = ""
    var weater = ""
    var tepeturMax = ""
    var tepeturMin = ""
    
    var weatherInfo = [String]()
    var mapDiveSiteData = [MapData]()
    var equipData: EquipData?
    
    var screenSize:CGRect?
    
    let formatterr: DateFormatter = {
       let foramtter = DateFormatter()
//        foramtter.timeStyle = .long
        foramtter.dateStyle = .medium
        return foramtter
    }()
    
    var titleDate: Date?
    var uuid = ""
    var data = [TableData]()
    var note: TableData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteName.delegate = self
        myTextView.delegate = self
        self.title = "\(formatterr.string(from: titleDate ?? Date()))"
        
        //myshadowView setting
        myshadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowView.layer.shadowOpacity = 0.5
        myshadowView.layer.shadowRadius = 2
        myshadowView.layer.cornerRadius = 30
        myshadowView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        myInnerView.backgroundColor = UIColor.clear
        myTextView.backgroundColor = UIColor.clear
        
        screenSize = UIScreen.main.bounds
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionVIewLayout.minimumInteritemSpacing = 1
        myCollectionVIewLayout.scrollDirection = .horizontal
        
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        myCollectionView.backgroundColor = UIColor.clear
        addDoneButtonOnKeyboard(textView: myTextView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        fetchCoreData()
    }
    
    //存coreData!!
    @IBAction func doneBtnPressedSave(_ sender: Any) {
        
        //要做delegate 傳給前面的Calender，這裡不該存coreDate!!
                
//        let note = TableData(context: CoreDataHelper.shared.managedObjectContext())
        
        if note == nil {
            self.data[0].diaryDate = "\(DateFormatter.localizedString(from: titleDate ?? Date(), dateStyle: .medium, timeStyle: .medium))"
            print("\(noteName.text ?? "")")
            print("\(myTextView.text ?? "")")
            self.data[0].diaryName = "\(noteName.text ?? "")"
            self.data[0].diaryTextView = "\(myTextView.text ?? "")"
            self.data[0].whitchTable = "Diary"
            self.delegate?.didFinishSetNote(note: self.data[0], isNotToday: true)
        } else {
            note.diaryDate = "\(DateFormatter.localizedString(from: titleDate ?? Date(), dateStyle: .medium, timeStyle: .medium))"
            print("\(note.diaryDate)")
            note.diaryName = "\(noteName.text ?? "")"
            note.diaryTextView = "\(myTextView.text ?? "")"
            
            note.equipSuit = "\(equipData?.mySuitText ?? "")"
            note.equipMask = "\(equipData?.myMaskText ?? "")"
            note.equipFins = "\(equipData?.myFinsText ?? "")"
            note.equipWeight = "\(equipData?.myWeightText ?? "")"
            note.equipVisibility = "\(equipData?.circleVisibilityText ?? "")"
            note.equipTemperature = "\(equipData?.myTempText ?? "")"
            note.equipMaxDeep = "\(equipData?.circleMaxDepthText ?? "")"
            note.equipDiveTime = "\(equipData?.myDiveTimeText ?? "")"
            
            note.moodEmoji = "\(moodemoji)"
            
            note.weatherName = weater
            note.weatherLocation = location
            note.weatherTMin = tepeturMin
            note.weatherTMax = tepeturMax
            
            note.locationSiteName = "\(mapDiveSiteData[0].diveSiteName ?? "")"
            note.locationSiteLat = "\(mapDiveSiteData[0].diveSiteLat ?? "")"
            note.locationSiteLon = "\(mapDiveSiteData[0].diveSiteLon ?? "")"
            
            note.whitchTable = "Diary"
//            if note.diaryDate != self.titleDate {
//
//            }
//            print("\(note.diaryDate) vs \(formatterr.string(from: self.titleDate ?? Date()))")
            formatterr.date(from: note.diaryDate ?? "")
//            print("\(note.diaryDate == formatterr.string(from: self.titleDate ?? Date()))")
            
            print("\(formatterr.date(from: note.diaryDate ?? "") != self.titleDate)")
            
            if formatterr.date(from: note.diaryDate ?? "") != self.titleDate {
                self.delegate?.didFinishSetNote(note: note, isNotToday: false)
            } else {
                self.delegate?.didFinishSetNote(note: note, isNotToday: true)
            }
            
        }
        
        navigationController?.popViewController(animated: true)

//        CoreDataHelper.shared.saveContext()
        
    }
    
    func fetchCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        fetchRequest.predicate = NSPredicate(format: "tableID contains[cd] %@", uuid)
        moc.performAndWait {
            do {
                self.data = try moc.fetch(fetchRequest)
                print("\(self.data)")
                if self.data.count != 0 {reloadValue()}
            }catch {
                self.data = []
            }
        }
    }
    
    func reloadValue(){
        //天氣 and 心情
        location = self.data[0].weatherLocation ?? ""
        weater = self.data[0].weatherName ?? ""
        tepeturMax = self.data[0].weatherTMax ?? ""
        tepeturMin = self.data[0].weatherTMin ?? ""
        moodemoji = self.data[0].moodEmoji ?? ""
        updateLabelForThings(label: myInfoLabelForThings, location: location, weater: weater, temMax: tepeturMax, temMin: tepeturMin, moodemoji: moodemoji)
        
        //裝備
        let equ = EquipData()
        equ.myDiveTimeText = self.data[0].equipDiveTime
        equ.mySuitText = self.data[0].equipSuit
        equ.myMaskText = self.data[0].equipMask
        equ.myFinsText = self.data[0].equipFins
        equ.myTempText = self.data[0].equipTemperature
        equ.myWeightText = self.data[0].equipWeight
        equ.circleVisibilityText = self.data[0].equipVisibility
        equ.circleMaxDepthText = self.data[0].equipMaxDeep
        equipData = equ
        
        //地點目前先做只有一筆資料
        let loc = MapData()
        loc.diveSiteLat = self.data[0].locationSiteLat
        loc.diveSiteLon = self.data[0].locationSiteLon
        loc.diveSiteName = self.data[0].locationSiteName
        mapDiveSiteData.append(loc)
//        let showALLFriendsContent = NSMutableAttributedString()
//        if data.count == 0 {
//            showALLFriendsContent.append(NSAttributedString(string: ""))
//            myInfoLabelForDiveSite.attributedText = showALLFriendsContent
//        }
//        showALLFriendsContent.append(NSAttributedString(string: ""))
//        myInfoLabelForDiveSite.attributedText = showALLFriendsContent
//        updateLabelForDiveSite(label: myInfoLabelForDiveSite, diveSiteName: mapDiveSiteData[0].diveSiteName ?? "", isLastOne: true, content: showALLFriendsContent)
//        for i in 0..<data.count {
//            guard let name = data[i].diveSiteName else {return}
//            if i == data.count - 1 {
//
//            } else {
//                updateLabelForDiveSite(label: myInfoLabelForDiveSite, diveSiteName: name, isLastOne: false, content: showALLFriendsContent)
//            }
//        }
        
        //時間
        if let day = formatterr.date(from: "\(self.data[0].diaryDate ?? "")") {
            let dateOfTime = "\(formatterr.string(from: day))"
            self.title = "\(dateOfTime)"
        } else {
            self.title = "\(formatterr.string(from: titleDate ?? Date()))"
        }
        //名字
        self.noteName.text = "\(self.data[0].diaryName ?? "")"
        //textView
        self.myTextView.text = "\(self.data[0].diaryTextView ?? "")"
        
        
        let showALLFriendsContent = NSMutableAttributedString()
        if data.count == 0 {
            showALLFriendsContent.append(NSAttributedString(string: ""))
            myInfoLabelForDiveSite.attributedText = showALLFriendsContent
        }
        for i in 0..<data.count {
            guard let name = self.data[i].locationSiteName else {return}
            if i == data.count - 1 {
                updateLabelForDiveSite(label: myInfoLabelForDiveSite, diveSiteName: name, isLastOne: true, content: showALLFriendsContent)
            } else {
                updateLabelForDiveSite(label: myInfoLabelForDiveSite, diveSiteName: name, isLastOne: false, content: showALLFriendsContent)
            }
        }

    }
    
    func addDoneButtonOnKeyboard(textView: UITextView) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(keyBoardDispear))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
    }
    @objc func keyBoardDispear(){
        myTextView.resignFirstResponder()
    }
    
    func updateLabelForDiveSite(label: UILabel, diveSiteName: String, isLastOne: Bool, content:  NSMutableAttributedString) {
        
        let siteImage = NSTextAttachment()
        siteImage.image = #imageLiteral(resourceName: "buoy")
        siteImage.bounds = CGRect(x: 0, y: -4.5, width: 20, height: 20)
        content.append(NSAttributedString(attachment: siteImage))
        
        if isLastOne == false {
            //我不是最後一個
            content.append(NSAttributedString(string: " • \(diveSiteName) "))
        } else {
            //我是最後一個
            content.append(NSAttributedString(string: " • \(diveSiteName)"))
        }
        
        label.attributedText = content
    }
    
    func updateLabelForThings(label: UILabel, location: String, weater: String, temMax: String, temMin: String, moodemoji: String) {
        
        let content = NSMutableAttributedString()
        if location != "" {
            content.append(NSAttributedString(string: "\(location) • "))
        }
        if weater != "" && temMax != "" && temMin != "" {
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


    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "diveSiteSegue" {
//            let diveSiteVC = segue.destination as! MapViewController
//            diveSiteVC.delegateData = mapDiveSiteData
//        }
//    }
 

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
            cell.myBtn.addTarget(self, action: #selector(divingBtn(_:)), for: .touchUpInside)
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
    @objc func divingBtn(_ sender: Any) {
        print("divingBtn")
        let equipVC = storyboard?.instantiateViewController(identifier: "equipVC") as! EquipViewController
        equipVC.delegate = self
        equipVC.transDataForEquip = equipData
        show(equipVC, sender: nil)
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
        let mapVC = storyboard?.instantiateViewController(identifier: "mapVC") as! MapViewController
        mapVC.delegate = self
        if mapDiveSiteData[0].diveSiteName != nil {
            mapVC.delegateData = mapDiveSiteData
        } else {
            mapVC.delegateData = []
        }
        show(mapVC, sender: nil)
    }
    //天氣
    @objc func weatherBtn() {
        print("cloudyBtn")
        let weatherVC = storyboard?.instantiateViewController(identifier: "weatherVC") as! WeatherViewController
        weatherVC.delegate = self
        show(weatherVC, sender: nil)
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
extension DiaryNoteSetViewController: MoodViewControllerDelegate, WeatherViewControllerDelegate, MapViewControllerDelegate, EquipViewControllerDelegate {
    
    //裝備更新
    func didFinishUpdateEquip(update data: EquipData) {
        equipData = data
        self.data[0].equipDiveTime = data.myDiveTimeText
        self.data[0].equipSuit = data.mySuitText
        self.data[0].equipMask = data.myMaskText
        self.data[0].equipFins = data.myFinsText
        self.data[0].equipTemperature = data.myTempText
        self.data[0].equipWeight = data.myWeightText
        self.data[0].equipVisibility = data.circleVisibilityText
        self.data[0].equipMaxDeep = data.circleMaxDepthText
        reloadValue()
        
    }
    
    //天氣更新
    func didUpdateWeatherInfo(updateWeatherInfo: [String]) {
        //hard code....
//        location = updateWeatherInfo[0]
//        weater = updateWeatherInfo[1]
//        tepeturMax = updateWeatherInfo[2]
//        tepeturMin = updateWeatherInfo[3]
//        updateLabelForThings(label: myInfoLabelForThings, location: location, weater: weater, temMax: tepeturMax, temMin: tepeturMin, moodemoji: moodemoji)
        self.data[0].weatherLocation = updateWeatherInfo[0]
        self.data[0].weatherName = updateWeatherInfo[1]
        self.data[0].weatherTMin = updateWeatherInfo[3]
        self.data[0].weatherTMax = updateWeatherInfo[2]
        self.reloadValue()
        
        
        
    }
    //心情更新
    func didUpdateMoodEmoji(emojiString: String) {
        moodemoji = emojiString
        self.data[0].moodEmoji = emojiString
        updateLabelForThings(label: myInfoLabelForThings, location: location, weater: weater, temMax: tepeturMax, temMin: tepeturMin, moodemoji: moodemoji)
        
    }
    //潛水地點更新
    func didUpdateDiveSite(updata data: [MapData]) {
        mapDiveSiteData = data
        
        //bug 目前只能存一筆資料
        self.data[0].locationSiteName = data[0].diveSiteName
        self.data[0].locationSiteLat = data[0].diveSiteLat
        self.data[0].locationSiteLon = data[0].diveSiteLon
        
        
        let showALLFriendsContent = NSMutableAttributedString()
        if data.count == 0 {
            showALLFriendsContent.append(NSAttributedString(string: ""))
            myInfoLabelForDiveSite.attributedText = showALLFriendsContent
        }
        for i in 0..<data.count {
            guard let name = data[i].diveSiteName else {return}
            if i == data.count - 1 {
                updateLabelForDiveSite(label: myInfoLabelForDiveSite, diveSiteName: name, isLastOne: true, content: showALLFriendsContent)
            } else {
                updateLabelForDiveSite(label: myInfoLabelForDiveSite, diveSiteName: name, isLastOne: false, content: showALLFriendsContent)
            }
        }
    }
    
}

extension DiaryNoteSetViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        noteName.text = textField.text ?? ""
        self.data[0].diaryName = "\(noteName.text ?? "")"
    }
    
}
