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
  var latitude: Double!
  var longitude: Double!
  var plistManager: Plist!
  var plant: TPPlant!
  
  @IBOutlet weak var stageLabel: UILabel!
  @IBOutlet weak var expLabel: UILabel!
  @IBOutlet weak var plantImageView: UIImageView!
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    plistManager = Plist(name: "UserData")
    
    setupLocationService()
    if !checkIfPlanted() { promptNewPlant() }
    loadPreviousPlant()
    stageLabel.text = "\(plant.latitude)"
    expLabel.text = "\(plant.longitude)"
    plantImageView.image = UIImage(named: "Plant")
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
    annotationView.frame = CGRect(x: 0,y: 0,width: 200,height: 200)
    return annotationView
  }
  
  @IBAction func viewPlant(sender: AnyObject) {
    openAr([plant.getPlantAnnotation()])
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
   * Checks if the plant already recorded in the plist.
   * - Returns: true or false
   */
  func checkIfPlanted() -> Bool {
    if let dict = plistManager.getValuesInPlistFile() {
      return dict["FirstPlanted"] as! Bool
    }
    return false
  }
  
  /**
   * Prompts the user to plant new.
   */
  func promptNewPlant() {
    let alert = UIAlertController(title: "Welcome", message: "Plant here at this location?", preferredStyle: .Alert)
    let ok = UIAlertAction(title: "Plant", style: .Default, handler: plantNew)
    alert.addAction(ok)
    parentViewController!.presentViewController(alert, animated: true, completion: nil)
  }
  
  /// Handler to plant new
  func plantNew(action: UIAlertAction){
    guard let lat = latitude else { return }
    guard let lon = longitude else { return }
    
    plant = TPPlant(latitude: lat, longitude: lon)
    
    if let dict = plistManager.getMutablePlistFile() {
      dict["FirstPlanted"] = true
      let plantData = dict["PlantData"] as! NSMutableDictionary
      let plantLocation = plantData["Location"] as! NSMutableDictionary
      plantLocation["Latitude"] = lat
      plantLocation["Longitude"] = lon
      plantData["Location"] = plantLocation
      dict["PlantData"] = plantData
      do {
          try plistManager.addValuesToPlistFile(dict)
      } catch {
        print(error)
      }
    }
    
    openAr([plant.getPlantAnnotation()])
  }
  
  /**
   * Loads previous plant.
   */
  func loadPreviousPlant() {
    if let dict = plistManager.getValuesInPlistFile() {
      let plantData = dict["PlantData"] as! NSDictionary
      plant = TPPlant(plantData: plantData)
    }
  }
  
  /**
   * Presents the AR View.
   * - Parameters:
   *   - annotations: array of ARAnnotation to be included in the view.
   */
  func openAr(annotations: [ARAnnotation]) {
    let arViewController = ARViewController()
    arViewController.debugEnabled = true
    arViewController.dataSource = self
    arViewController.maxDistance = 200
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
    arViewController.view.bringSubviewToFront(b)
  }

}

