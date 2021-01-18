//
//  DiaryViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit
import FSCalendar
import CoreData

class DiaryViewController: UIViewController {

    @IBOutlet weak var myFSCalendar: FSCalendar!
    @IBOutlet weak var myTableView: UITableView!
    
    var data = [TableData]()
    var showDayData = [TableData]()
    var isFSChangeValue = false
    
    let formatterr: DateFormatter = {
       let foramtter = DateFormatter()
//        foramtter.timeStyle = .long
        foramtter.dateStyle = .medium
        return foramtter
    }()
    
    var selectedDay:Date?
    
    var icons: [String] = ["bubbles", "cat-face", "hammerheadfishshape", "shark", "wave"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Diary"
        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        myFSCalendar.delegate = self
        myFSCalendar.dataSource = self
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        
        myFSCalendar.backgroundColor =  UIColor.clear
        myFSCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 16.0)
        myFSCalendar.appearance.titleDefaultColor = UIColor.darkText
//        myFSCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16.0)
//        myFSCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14.0)
        
        myTableView.backgroundColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCoreData()
        myTableView.reloadData()
    }
    func fetchCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        fetchRequest.predicate = NSPredicate(format: "whitchTable contains[cd] %@", "Diary")
        let order = NSSortDescriptor(key: "diaryDate", ascending: false)
        fetchRequest.sortDescriptors = [order]
        moc.performAndWait {
            do {
                self.data = try moc.fetch(fetchRequest)
                showDayData = dayFilter(data: self.data, selectDate: Date())
//                if self.data.count != 0 {updateValueAfterCoreDate()}
            }catch {
                self.data = []
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //addPressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNote" {
//            print("\(showDayData)")
//            print("\(showDayData == nil)")
//            print("\(showDayData != nil)")
            let dic = ["isFirstOpenApp": true]
            UserDefaults.standard.register(defaults: dic)
            let vc = segue.destination as! DiaryNoteSetViewController
            let note = TableData(context: CoreDataHelper.shared.managedObjectContext())
            CoreDataHelper.shared.saveContext()
            vc.delegate = self
            vc.uuid = note.tableID
            if isFSChangeValue == true {
                vc.titleDate = selectedDay
                isFSChangeValue = false
            } else {
                vc.titleDate = Date()
            }
            
        }
    }
    

}

extension DiaryViewController: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        isFSChangeValue = true
        selectedDay = date
        showDayData = dayFilter(data: self.data, selectDate: date)
        myTableView.reloadData()
    }

    func dayFilter(data: [TableData], selectDate: Date) -> [TableData]{
        var strings = [String]()
        var filterArray = [TableData]()
        //append string
        //有個全部的陣列 data ok
        for i in 0..<data.count {
            guard let datee = data[i].diaryDate else {return []}
            strings.append(datee)
        }
        //filter
        //過濾出日期的陣列
        let afterFilterArray = strings.filter { ($0).contains("\(formatterr.string(from: selectDate))")}
        print("\(afterFilterArray)")
        for i in 0..<data.count {
            for j in 0..<afterFilterArray.count {
                if let dateOfDay = data[i].diaryDate {
                    if dateOfDay == afterFilterArray[j] {
                        filterArray.append(data[i])
                        break
                    }
                }
            }
        }
        
        return filterArray
    }
    
}


extension DiaryViewController: FSCalendarDataSource{
    
}

extension DiaryViewController: DiaryNoteSetViewControllerDelegate{
    func didFinishSetNote(note: TableData, isNotToday: Bool) {
        //給tre or false
        if isNotToday == true { //not today
            self.data.append(note)
        } else { //today
            //data 是全部的日記，要跟showdata分開
            //處理model 再處理view
//            if let index = self.data.firstIndex(of: note){
//                let indexPath = IndexPath(row: index, section: 0)
//                self.myTableView.reloadRows(at: [indexPath], with: .automatic)
//            }
        }
        CoreDataHelper.shared.saveContext()
        self.myTableView.reloadData()
    }
    
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //filter index 轉 data index
        var transFerIndex = -1
        for i in 0..<self.data.count {
            if showDayData[indexPath.row].tableID == self.data[i].tableID {
                transFerIndex = i
                break
            }
        }
        //點到cell跳轉畫面，帶uuid過去
        let vc = storyboard?.instantiateViewController(identifier: "diaryNoteVC") as! DiaryNoteSetViewController
        vc.delegate = self
        vc.uuid = self.data[transFerIndex].tableID
        vc.note = self.data[transFerIndex]
        vc.titleDate = selectedDay
        print("\(vc.titleDate)")
        //userDefault
        show(vc, sender: nil)
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showDayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiaryCellTableViewCell
        
        cell.myLabel.text = "\(self.showDayData[indexPath.row].diaryName ?? "Na")"
        cell.myImageView.image = nil
        
        let randomIndex = Int.random(in: 0..<icons.count)
        
        cell.myImageView.image = UIImage(named: icons[randomIndex])
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }

}
