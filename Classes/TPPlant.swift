//
//  TPPlant.swift
//  ARPlant
//
//  Created by Tran Thai Phuoc on 2016-09-01.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreLocation
import HDAugmentedReality

/**
 * TTPlant NSObject
 */
class TPPlant: NSObject {
  
  var latitude: Double!
  var longitude: Double!
  var currentEXP: Double = 0
  var currentStage: Int = 0
  
  /** Initializes object with location and default values for other parameters */
  init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
  
  /**
   * Initializes object with dictionary.
   * - Parameters:
   *   - plantData: NSDictionary with:
   *     - CurrentEXP and CurrentStage
   *     - Location (NSDictionary) with Latitude and Longitude
   */
  init(plantData: NSDictionary) {
    let plantLocation = plantData["Location"] as! NSDictionary
    latitude = plantLocation["Latitude"] as! Double
    longitude = plantLocation["Longitude"] as! Double
    currentEXP = plantData["CurrentEXP"] as! Double
    currentStage = plantData["CurrentStage"] as! Int
  }
  
  /// - Returns: ARAnnotation with the plant's location
  func getPlantAnnotation() -> ARAnnotation {
    let plantAnnotation = ARAnnotation()
    plantAnnotation.location = CLLocation(latitude: latitude, longitude: longitude)
    plantAnnotation.title = "Plant"
    return plantAnnotation
  }
  
}
