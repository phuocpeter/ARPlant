//
//  ViewController.swift
//  ARPlant
//
//  Created by Tran Thai Phuoc on 2016-09-01.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreLocation
import HDAugmentedReality

class MainViewController: UIViewController, CLLocationManagerDelegate, ARDataSource {

  let locationManager = CLLocationManager()
  var annotations = [ARAnnotation]()
  var latitude: Double!
  var longitude: Double!
  var plistManager: Plist!
  
  @IBOutlet weak var stageLabel: UILabel!
  @IBOutlet weak var expLabel: UILabel!
  @IBOutlet weak var plantImageView: UIImageView!
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    plistManager = Plist(name: "UserData")
    
    setupLocationService()
    checkIfPlanted()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - CL Location Manager Delegate

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocationCoordinate2D = (locationManager.location?.coordinate)!
    latitude = location.latitude
    longitude = location.longitude
  }
  
  // MARK: - AR Data Source
  
  func ar(arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
    let annotationView = TPPlantAnnotationView()
    annotationView.frame = CGRect(x: 0,y: 0,width: 181,height: 150)
    return annotationView
  }
  
  @IBAction func viewPlant(sender: AnyObject) {
    openAr(annotations)
  }
  
  // MARK: - Helper Methods
  
  /// Checks and start location service.
  func setupLocationService() {
    locationManager.requestWhenInUseAuthorization()
    if !CLLocationManager.locationServicesEnabled() {
      // Location Service not enabled -> app not usable
      let alert = UIAlertController(title: "Warning", message: "Please enable location service", preferredStyle: .Alert)
      parentViewController!.presentViewController(alert, animated: true, completion: nil)
    }
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
  
  /**
   * 
   */
  func checkIfPlanted() {
    if let dict = plistManager.getValuesInPlistFile() {
      let firstPlanted = dict["FirstPlanted"] as! Bool
      if !firstPlanted {
        let alert = UIAlertController(title: "Welcome", message: "Not planted", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Plant", style: .Default, handler: plantNew)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        parentViewController!.presentViewController(alert, animated: true, completion: nil)
      }
    }
  }
  
  func plantNew(action: UIAlertAction){
    guard let lat = latitude else { return }
    guard let lon = longitude else { return }
    
    let plantAnnotation = ARAnnotation()
    plantAnnotation.location = CLLocation(latitude: lat, longitude: lon)
    plantAnnotation.title = "Plant"
    annotations.append(plantAnnotation)
    
    openAr(annotations)
  }
  
  func openAr(annotations: [ARAnnotation]) {
    
    let arViewController = ARViewController()
    arViewController.debugEnabled = true
    arViewController.dataSource = self
    arViewController.maxDistance = 10
    arViewController.maxVisibleAnnotations = 100
    arViewController.maxVerticalLevel = 5
    arViewController.headingSmoothingFactor = 0.05
    arViewController.trackingManager.userDistanceFilter = 25
    arViewController.trackingManager.reloadDistanceFilter = 75
    arViewController.setAnnotations(annotations)
    self.presentViewController(arViewController, animated: true, completion: nil)
    
    let b = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    b.backgroundColor = UIColor.redColor()
    arViewController.view.addSubview(b)
  }

}

