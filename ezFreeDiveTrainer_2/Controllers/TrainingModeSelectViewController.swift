//
//  TrainingModeSelectViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit

class TrainingModeSelectViewController: UIViewController {

    @IBOutlet weak var myTrainingModeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(myTrainingModeTableView)
        // Do any additional setup after loading the view.
        myTrainingModeTableView.delegate = self
        myTrainingModeTableView.dataSource = self
        myTrainingModeTableView.separatorStyle = .none
        myTrainingModeTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        self.title = "Training"
    }

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier {
//            switch identifier {
//            case "timetimeSegue":
//                let vc = segue.destination as! TimeTimeViewController
//            default:
//                break
//            }
//        }
//    }
    
}

extension TrainingModeSelectViewController: UITableViewDelegate {
}

extension TrainingModeSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2/*for demo   true = 4*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingModeCellTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.modeTital.text = "Timer Training"
            cell.modeDescryption.text = "You can set your table just......"
            cell.modeImageView.image = UIImage(named: "wallclock")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingModeCellTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.modeTital.text = "Step Training"
            cell.modeDescryption.text = "You can set your table just......"
            cell.modeImageView.image = UIImage(named: "footprints")
            
            SubFunctions.shared.drawGradual(image: cell.modeImageView, arcCenterMustBeSquareViewXY: cell.modeImageView.bounds.width / 2, radius: cell.modeImageView.bounds.width / 2, color1: "#29323c", color2: "#29323c", lineWidth: 4.0)
            
            return cell
            
        }
        
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingModeTableViewCell
//            cell.backgroundColor = UIColor.clear
//            cell.modeTital.text = "時間遞減 + time"
//            cell.modeDescryption.text = "666666666666666666666666666666"
//            cell.modeImageView.image = UIImage(named: "wallclock")
//            return cell
//
//        } else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TrainingModeCell2TableViewCell
//            cell.backgroundColor = UIColor.clear
//            cell.mode2Tital.text = "時間遞減 + 呼吸次數"
//            cell.mode2Descryption.text = "66666666666666666666666666"
//            cell.mode2ImageView1.image = UIImage(named: "badbreath")
//            cell.mode2ImageView2.image = UIImage(named: "wallclock")
//            self.view.bringSubviewToFront(cell.mode2ImageView1)
//            return cell
//
//        } else if indexPath.row == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingModeTableViewCell
//            cell.backgroundColor = UIColor.clear
//            cell.modeTital.text = "步數遞減 + time"
//            cell.modeDescryption.text = "66666666666666666666666666"
//            cell.modeImageView.image = UIImage(named: "footprints")
//
//            //畫漸層
//            let gradient = CAGradientLayer()
//            gradient.frame =  CGRect(origin: .zero, size: cell.modeImageView.frame.size)
//            let color1 = UIColor(hexString: "#29323c").cgColor
//            let color2 = UIColor(hexString: "#29323c").cgColor
//            gradient.colors = [color1, color2]
//            let shape = CAShapeLayer()
//            shape.lineWidth = 4
//            shape.path = UIBezierPath(arcCenter: CGPoint(x: 36, y: 36), radius: CGFloat(36), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
//            shape.strokeColor = UIColor.black.cgColor
//            shape.fillColor = UIColor.clear.cgColor
//            gradient.mask = shape
//
//            cell.modeImageView.layer.addSublayer(gradient)
//            return cell
//
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TrainingModeCell2TableViewCell
//            cell.backgroundColor = UIColor.clear
//            cell.mode2Tital.text = "時間遞減 + 呼吸次數"
//            cell.mode2Descryption.text = "66666666666666666666666666"
//            cell.mode2ImageView1.image = UIImage(named: "badbreath")
//            cell.mode2ImageView2.image = UIImage(named: "footprints")
//
//            let gradient = CAGradientLayer()
//            gradient.frame =  CGRect(origin: .zero, size: cell.mode2ImageView2.frame.size)
//            let color1 = UIColor(hexString: "#29323c").cgColor
//            let color2 = UIColor(hexString: "#29323c").cgColor
//            gradient.colors = [color1, color2]
//            let shape = CAShapeLayer()
//            shape.lineWidth = 2
//            shape.path = UIBezierPath(arcCenter: CGPoint(x: 23, y: 22.8), radius: CGFloat(22.2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
//            shape.strokeColor = UIColor.black.cgColor
//            shape.fillColor = UIColor.clear.cgColor
//            gradient.mask = shape
//
//            cell.mode2ImageView2.layer.addSublayer(gradient)
//
//            return cell
//        }
        
        
//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingModeTableViewCell
//            cell.backgroundColor = UIColor.clear
//            cell.modeTital.text = "時間遞減 + time"
//            cell.modeDescryption.text = "666666666666666666666666666666"
//            cell.modeImageView.image = UIImage(named: "wallclock")
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TrainingModeCell2TableViewCell
//            cell.mode2Tital.text = "時間遞減 + 呼吸次數"
//            cell.mode2Descryption.text = "66666666666666666666666666"
//            cell.mode2ImageView1.image = UIImage(named: "salutation")
//            cell.mode2ImageView2.image = UIImage(named: "wallclock")
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingModeTableViewCell
//            cell.backgroundColor = UIColor.clear
//            cell.modeTital.text = "步數遞減 + time"
//            cell.modeDescryption.text = "66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666"
//            cell.modeImageView.image = UIImage(named: "salutation")
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TrainingModeCell2TableViewCell
//            cell.mode2Tital.text = "時間遞減 + 呼吸次數"
//            cell.mode2Descryption.text = "66666666666666666666666666"
//            cell.mode2ImageView1.image = UIImage(named: "salutation")
//            cell.mode2ImageView2.image = UIImage(named: "wallclock")
//            return cell
//        default:
//            break
//        }
//        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: reduceTime()
        case 1: reduceTimeBreath()
        case 2: reduceStep()
        case 3: reduceStepBreath()
        default: break
        }
    }
    func reduceTime() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ReduceTime") {
            show(controller, sender: nil)
        }
    }
    func reduceTimeBreath() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ReduceTimeBreath") {
            show(controller, sender: nil)
        }
    }
    func reduceStep() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ReduceStep") {
            show(controller, sender: nil)
        }
    }
    func reduceStepBreath() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ReduceStepBreath") {
            show(controller, sender: nil)
        }
    }
    
}
