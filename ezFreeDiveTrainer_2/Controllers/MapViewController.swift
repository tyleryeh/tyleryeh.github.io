//
//  MapViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/31.
//

import UIKit
import MapKit
import SCLAlertView

protocol MapViewControllerDelegate: class {
    func didUpdateDiveSite(updata data: [MapData])
}

class MapViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!

    var locationManager = CLLocationManager()
    var userCurrentLocation = CLLocationCoordinate2D()
    let annotation = MKPointAnnotation()
    let annotationview = MKPinAnnotationView()
    
    var regionUpdateCenter = CLLocationCoordinate2D()
    
    var isTheFistTimeLocated = false
    var isReloadData = false
    
    var placeTextfield = UITextField()
    var isAddDiveSite = false
    var isFirstTimeLoadAnnotition = true
    var isAnnotationDrag = false
    
    var delegateData = [MapData]()
    weak var delegate: MapViewControllerDelegate?
    var reloadDataCount = 0
    var reloadArrayIndex = 0
    
    //delete
    var selectedView = MKAnnotationView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        myMapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        reloadDiveSitePointData(data: delegateData)
    }
    
    func reloadDiveSitePointData(data: [MapData]) {
        if data.count == 0 {
            isReloadData = false
        } else {
            for i in 0..<data.count {
                guard let name = data[i].diveSiteName,
                      let lat = data[i].diveSiteLat,
                      let lon = data[i].diveSiteLon else {return}
                guard  let doubleLat = Double(lat),
                       let doubleLon = Double(lon) else {
                    return
                }
                
                
                let newDiveSite = MKPointAnnotation()
                newDiveSite.coordinate.latitude = doubleLat
                newDiveSite.coordinate.longitude = doubleLon
    //            newDiveSite.coordinate = regionUpdateCenter
                newDiveSite.title = "\(name)"
                newDiveSite.subtitle = String(format: "%0.4f, ", newDiveSite.coordinate.latitude) + String(format: "%0.4f", newDiveSite.coordinate.longitude)
                myMapView.addAnnotation(newDiveSite)
            }
            isReloadData = true
            reloadDataCount = data.count
            isAddDiveSite = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }else if locationManager.authorizationStatus == .denied {
            let alert = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        var divesites = ""

        if delegateData.count != 0 {
            if delegateData[0].diveSiteName == "" {
                delegateData.remove(at: 0)
            }
        }
        
        for i in 0..<delegateData.count {
            divesites.append(delegateData[i].diveSiteName ?? "?")
            if i == delegateData.count - 1{ divesites.append("") } else {divesites.append(", ")}
        }
        
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 30,
            kTitleFont: UIFont(name: "Chalkboard SE Regular", size: 22)!,
            kTextFont: UIFont(name: "Chalkboard SE Regular", size: 12)!,
            kButtonFont: UIFont(name: "Chalkboard SE Regular", size: 14)!,
            contentViewCornerRadius: 20
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.view.backgroundColor = UIColor.clear
        alertView.addButton("Ok", target: self, selector: #selector(tranceDatatoNoteSetView))
        alertView.showSuccess("Do you want to save these lovely dive sites ?", subTitle: "\(divesites)", closeButtonTitle: "Cancel", circleIconImage: #imageLiteral(resourceName: "cat-face"))
    }
    
    @objc func tranceDatatoNoteSetView() {
        self.delegate?.didUpdateDiveSite(updata: delegateData)
    }
    
    @objc func aleartViewEditNewDiveSite(_ sender: Any) {
        print("AddAdd")
        
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 30,
            kTitleFont: UIFont(name: "Chalkboard SE Regular", size: 22)!,
            kTextFont: UIFont(name: "Chalkboard SE Regular", size: 12)!,
            kButtonFont: UIFont(name: "Chalkboard SE Regular", size: 14)!,
            contentViewCornerRadius: 20
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.view.backgroundColor = UIColor.clear
        placeTextfield = alertView.addTextField("Place")
        placeTextfield.backgroundColor = UIColor.clear
        placeTextfield.textColor = UIColor.systemGray
        alertView.addButton("Add", target: self, selector: #selector(addBtnPressed))
        alertView.showSuccess("Add new dive site 🥰", subTitle: "Let's go~~", closeButtonTitle: "Cancel", circleIconImage: #imageLiteral(resourceName: "buoy"))
    }
    
    @objc func deleteDiveSite(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 30,
            kTitleFont: UIFont(name: "Chalkboard SE Regular", size: 22)!,
            kTextFont: UIFont(name: "Chalkboard SE Regular", size: 12)!,
            kButtonFont: UIFont(name: "Chalkboard SE Regular", size: 14)!,
            contentViewCornerRadius: 20
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.view.backgroundColor = UIColor.clear
        alertView.addButton("Ok", target: self, selector: #selector(deleteDidSelectedView))
        alertView.showNotice("Do you reall want to delete?", subTitle: "🌝", closeButtonTitle: "Cancel", circleIconImage: #imageLiteral(resourceName: "cat-face"))
    }
    
    @objc func deleteDidSelectedView(){
        guard let viewannotation = selectedView.annotation,
              let viewName = selectedView.annotation?.title else {
            return
        }
        //取到哪比資料被刪
        var arrayIndex = 0
        for i in 0..<delegateData.count { //改用名字刪
            guard let name = delegateData[i].diveSiteName  else {
                return
            }
            if viewName == name {
                arrayIndex = i
                break
            }
        }
        //arrayIndex
        delegateData.remove(at: arrayIndex)
        myMapView.removeAnnotation(viewannotation)
        myMapView.reloadInputViews()
        
    }
    
    @objc func addBtnPressed() {
        guard let text = placeTextfield.text else { return }
        var currentPosition = CLLocationCoordinate2D()
        if isAnnotationDrag == false {
            currentPosition = regionUpdateCenter
        } else {
            guard let dragPosition = selectedView.annotation?.coordinate else {return}
            currentPosition = dragPosition
        }
        
        if text != "" {
            //New Annotation
            let newDiveSite = MKPointAnnotation()
            newDiveSite.coordinate = currentPosition
            newDiveSite.title = "\(text)"
            newDiveSite.subtitle = String(format: "%0.4f, ", currentPosition.latitude) + String(format: "%0.4f", currentPosition.longitude)
            myMapView.addAnnotation(newDiveSite)
            isAnnotationDrag = false
            
            //MARK: Save for trance data to diarysetVC
            let data = MapData()
            data.diveSiteName = "\(text)"
            data.diveSiteLat = String(format: "%0.6f", currentPosition.latitude)
            data.diveSiteLon = String(format: "%0.6f", currentPosition.longitude)
            delegateData.append(data)
            
            isAddDiveSite = true
        } else {
            print("Textfiled is Empty@@")
        }
        
    }


}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        if !isTheFistTimeLocated {
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            let region = MKCoordinateRegion(center: lastLocation.coordinate, span: span)
            myMapView.setRegion(region, animated: true)
            isTheFistTimeLocated = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        regionUpdateCenter = mapView.region.center
        print("\(regionUpdateCenter.latitude) , \(regionUpdateCenter.longitude)")
        
        //下圖釘
        if isReloadData == false {
            annotation.coordinate = regionUpdateCenter
            annotation.title = "Dive Site"
            annotation.subtitle = "Hold pressed to drag"
            myMapView.selectAnnotation(annotation, animated: true)
            myMapView.addAnnotations([annotation])
        }
        
    }
    
}
extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        //first time
        var resultID = "AddDiveSite"
        //second time
        if isAddDiveSite == true {
            //有個count的問題，要計算buffer數量，加完數量前要讓isReloaddata一直是true
            reloadDataCount -= 1
            if reloadDataCount >= 0 {
                isReloadData = true
                guard let lat = delegateData[reloadArrayIndex].diveSiteLat,
                      let lon = delegateData[reloadArrayIndex].diveSiteLon else { return nil }
                resultID = "\(lat)_\(lon)"
                reloadArrayIndex += 1
            } else {
                isReloadData = false
                resultID = String(format: "%0.6f_", regionUpdateCenter.latitude) + String(format: "%0.6f", regionUpdateCenter.longitude)
                isAddDiveSite = false
                reloadArrayIndex = 0 //加reload count = 0?/?
                reloadDataCount = 0
            }
        }
        //different ID
        var result = mapView.dequeueReusableAnnotationView(withIdentifier: resultID)

        if result == nil {
            if isFirstTimeLoadAnnotition == true && isReloadData == false{
                result = MKAnnotationView(annotation: annotation, reuseIdentifier: resultID)
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.image = #imageLiteral(resourceName: "buoy")
                result?.leftCalloutAccessoryView = imageView
                result?.canShowCallout = true
                result?.image = #imageLiteral(resourceName: "anchor").resize(newSize: CGSize(width: 50.0, height: 50.0))
                result?.isDraggable = true
                
                let button = UIButton(type: .contactAdd)//圓形一個i的圖案  //custom自訂圖案摟
                button.addTarget(self, action: #selector(aleartViewEditNewDiveSite(_:)), for: .touchUpInside)
                result?.rightCalloutAccessoryView = button
                isFirstTimeLoadAnnotition = false
                
            } else if isFirstTimeLoadAnnotition == true && isReloadData == true {
                result = MKAnnotationView(annotation: annotation, reuseIdentifier: resultID)
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30.0, height: 30.0))
                imageView.image = #imageLiteral(resourceName: "shark")
                result?.leftCalloutAccessoryView = imageView
                result?.canShowCallout = true
                result?.image = #imageLiteral(resourceName: "buoy").resize(newSize: CGSize(width: 30.0, height: 30.0))
                let button = UIButton(type: .close)
                button.addTarget(self, action: #selector(deleteDiveSite(_:)), for: .touchUpInside)
                result?.rightCalloutAccessoryView = button //加 isreload = false
                isReloadData = false
                
                
            } else {
                result = MKAnnotationView(annotation: annotation, reuseIdentifier: resultID)
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30.0, height: 30.0))
                imageView.image = #imageLiteral(resourceName: "shark")
                result?.leftCalloutAccessoryView = imageView
                result?.canShowCallout = true
                result?.image = #imageLiteral(resourceName: "buoy").resize(newSize: CGSize(width: 30.0, height: 30.0))
                let button = UIButton(type: .close)
                button.addTarget(self, action: #selector(deleteDiveSite(_:)), for: .touchUpInside)
                result?.rightCalloutAccessoryView = button
            }
        } else {
            //Use exist one!
            result?.annotation = annotation
        }
        
        return result
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didselect view:")
        //得到view
        selectedView = view
        isAnnotationDrag = true
    }
    
}
//MARK: UIPopoverPresentationControllerDelegate
extension MapViewController: UIPopoverPresentationControllerDelegate{
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
