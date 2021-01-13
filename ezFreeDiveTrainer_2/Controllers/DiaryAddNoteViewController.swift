//
//  DiaryAddNoteViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/30.
//

import UIKit

class DiaryAddNoteViewController: UIViewController {
    
    @IBOutlet weak var maskImage: UIImageView!
    @IBOutlet weak var finImage: UIImageView!
    @IBOutlet weak var suitImage: UIImageView!
    @IBOutlet weak var weightkImage: UIImageView!
    @IBOutlet weak var moodkImage: UIImageView!
    @IBOutlet weak var weatherkImage: UIImageView!
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var maskTextFiled: UITextField!
    @IBOutlet weak var finTextFiled: UITextField!
    @IBOutlet weak var suitTextFiled: UITextField!
    @IBOutlet weak var weightkTextFiled: UITextField!
    @IBOutlet weak var moodkTextFiled: UITextField!
    @IBOutlet weak var weatherkTextFiled: UITextField!
    @IBOutlet weak var locationTextFiled: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        // Do any additional setup after loading the view.
        imageSet(image: maskImage, name: "snorkel")
        imageSet(image: finImage, name: "fins")
        imageSet(image: suitImage, name: "diving-suit")
        imageSet(image: weightkImage, name: "bar")
        imageSet(image: weatherkImage, name: "nature")
        imageSet(image: locationImage, name: "location")
        photoImageView.image = UIImage(named: "1024")
    }
    
    func imageSet(image: UIImageView, name: String) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.image = UIImage(named: name)
        
        SubFunctions.shared.drawGradual(image: image, arcCenterMustBeSquareViewXY: image.bounds.width / 2, radius: image.bounds.width / 2, color1: "#f9d423", color2: "#ff4e50", lineWidth: 4.0)
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
