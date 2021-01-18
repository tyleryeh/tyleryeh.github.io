//
//  HistoryViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/3.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet var myshadowView: UIView!
    @IBOutlet var myInnerView: UIView!
    
    var data: [TableData] = []
    var diaryData: [TableData] = []
    // TimelinePoint, Timeline back color, title, description, lineInfo, thumbnails, illustration
//    var showData = [Int: [(TimelinePoint, UIColor, String, String, String?, [String]?, String?)]]()
    let formatterr: DateFormatter = {
       let foramtter = DateFormatter()
        foramtter.timeStyle = .long
        foramtter.dateStyle = .medium
        return foramtter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myshadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowView.layer.shadowOpacity = 0.5
        myshadowView.layer.shadowRadius = 2
        myshadowView.layer.cornerRadius = 30
        myshadowView.backgroundColor = UIColor.clear
        myInnerView.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        self.title = "History"
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor.clear
        
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle(for: TimelineTableViewCell.self))
        self.myTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.data = []
        self.diaryData = []
        fetchCoreDataRT()
        fetchCoreDataDiary()
        self.myTableView.reloadData()
    }
    
    func fetchCoreDataRT() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        fetchRequest.predicate = NSPredicate(format: "whitchTable contains[cd] %@", "RT")
        let order = NSSortDescriptor(key: "saveDate", ascending: true)
        fetchRequest.sortDescriptors = [order]
        moc.performAndWait {
            do {
                self.data = try moc.fetch(fetchRequest)
            }catch {
                self.data = []
            }
        }
    }
    
    func fetchCoreDataDiary() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        fetchRequest.predicate = NSPredicate(format: "whitchTable contains[cd] %@", "Diary")
        let order = NSSortDescriptor(key: "diaryDate", ascending: true)
        fetchRequest.sortDescriptors = [order]
        moc.performAndWait {
            do {
                self.diaryData = try moc.fetch(fetchRequest)
            }catch {
                self.diaryData = []
            }
        }
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "hRTSegue" {
//            let vc = segue.destination as! RTCounterViewController
//            if selectCellSection == 0 {
//                guard let name = self.data[selectCellIndexPath].tableName else {return}
//                vc.catchTableName = name
//            } else {
//                guard let name = self.diaryData[selectCellIndexPath].tableName else {return}
//            }
//        }
//    }
    
    func updateLabelForThings(location: String, temMax: String, temMin: String, moodemoji: String) -> NSMutableAttributedString {
        
        let content = NSMutableAttributedString()
        if moodemoji != "" {
            content.append(NSAttributedString(string: "\(location) • "))
            content.append(NSAttributedString(string: "\(temMin)-\(temMax)°C • "))
            let moodImage = NSTextAttachment()
            moodImage.image = UIImage(named: "\(moodemoji)")
            moodImage.bounds = CGRect(x: 0, y: -4.5, width: 20, height: 20)
            content.append(NSAttributedString(attachment: moodImage))
        }
        return content
    }

}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //RTVC
        if indexPath.section == 0 {
            let vc = storyboard?.instantiateViewController(identifier: "RTVC") as! RTCounterViewController
            guard let name = self.data[indexPath.row].tableName else {return}
            vc.catchTableName = name
            show(vc, sender: nil)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "diaryNoteVC") as! DiaryNoteSetViewController
            vc.uuid = self.diaryData[indexPath.row].tableID
            
            // Create Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            guard let stringDate = self.diaryData[indexPath.row].diaryDate else {return}
            
            vc.titleDate = dateFormatter.date(from: stringDate)
            vc.note = self.diaryData[indexPath.row]
            vc.delegate = self
            show(vc, sender: nil)
        }
        
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.data.count
        case 1:
            return self.diaryData.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimelineTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.bubbleColor = UIColor.clear
        cell.bubbleEnabled = false

        cell.titleLabel.font = UIFont.init(name: "Chalkboard SE Regular", size: 26)
        cell.descriptionLabel.font = UIFont.systemFont(ofSize: 14)

        cell.timeline.width = 3.5
        cell.timelinePoint = TimelinePoint(diameter: 10, lineWidth: 1, color: UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening")), filled: true)
        cell.timeline.leftMargin = tableView.bounds.width * 0.18
        cell.illustrationImageView.image = nil
        cell.viewsInStackView = []

        
        if indexPath.section == 0 {
            let breath = self.data[indexPath.row].breath ?? ""
            let hold = self.data[indexPath.row].hold ?? ""
            let set = self.data[indexPath.row].set ?? ""
            
            cell.titleLabel.text = self.data[indexPath.row].tableName
            cell.descriptionLabel.text = "BreathTime: \(breath), HoldTime: \(hold), Set: \(set)"
            if indexPath.row == 0 {
                cell.illustrationImageView.image = UIImage(named: "wallclock")
                cell.illustrationSize.constant = 20
                cell.viewsInStackView = [UIImageView(image: UIImage(named: "wallclock"))]
                cell.timeline.backColor = UIColor.black  //時間軸的線
                cell.timeline.frontColor = UIColor.clear //圓點連接處
            } else if indexPath.row == self.data.count - 1 {
                cell.timeline.backColor = UIColor.clear
                cell.timeline.frontColor = UIColor.black
            } else {
                cell.timeline.backColor = UIColor.black
                cell.timeline.frontColor = UIColor.black
            }
            return cell
            
        } else if indexPath.section == 1{
        
            let weaterLocation = self.diaryData[indexPath.row].weatherLocation ?? ""
            let moodImage = self.diaryData[indexPath.row].moodEmoji ?? ""
            let tMax = self.diaryData[indexPath.row].weatherTMax ?? ""
            let tMin = self.diaryData[indexPath.row].weatherTMin ?? ""
            let weater = self.diaryData[indexPath.row].weatherName ?? ""
            
            var weaImage = ""
            switch weater {
            case "晴":
                weaImage = "sun"
            case "多雲":
                weaImage = "cloudy"
            case "陰":
                weaImage = "cloud"
            default:
                weaImage = ""
            }
            
            cell.titleLabel.text = self.diaryData[indexPath.row].diaryName ?? ""
            if weaImage != "" {cell.illustrationImageView.image = UIImage(named: weaImage)}
            cell.illustrationSize.constant = 20
            cell.descriptionLabel.attributedText = updateLabelForThings(location: weaterLocation, temMax: tMax, temMin: tMin, moodemoji: moodImage)
            
            if indexPath.row == 0 {
                cell.timeline.backColor = UIColor.black  //時間軸的線
                cell.timeline.frontColor = UIColor.clear //圓點連接處
            } else if indexPath.row == self.diaryData.count - 1 {
                cell.timeline.backColor = UIColor.clear
                cell.timeline.frontColor = UIColor.black
            } else {
                cell.timeline.backColor = UIColor.black
                cell.timeline.frontColor = UIColor.black
            }
            return cell
            
        } else {
            return cell
        }
        
    }
    
}

extension HistoryViewController: DiaryNoteSetViewControllerDelegate {
    func didFinishSetNote(note: TableData, isNotToday: Bool) {
        if isNotToday == true {
            self.data.append(note)
            self.myTableView.reloadData()
        } else {
            if let index = self.diaryData.firstIndex(of: note) {
                let indexPath = IndexPath(row: index, section: 1)
                self.myTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        CoreDataHelper.shared.saveContext()
    }
    
    
}
