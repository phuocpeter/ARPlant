//
//  TPPlantAnnotationView.swift
//  ARPlant
//
//  Created by Tran Thai Phuoc on 2016-09-01.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import HDAugmentedReality

class TPPlantAnnotationView: ARAnnotationView, UIGestureRecognizerDelegate {
  
  var distanceLabel: UILabel?
  var imageView: UIImageView?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    loadUI()
    bindUi()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layoutUI()
  }
  
  override func bindUi() {
    if let distanceFromUser = annotation?.distanceFromUser {
      let distance = distanceFromUser > 1000 ? String(format: "%.1fkm", distanceFromUser / 1000) : String(format:"%.0fm", distanceFromUser)
      distanceLabel?.text = "Distance: \(distance)"
      layoutUI()
    }
  }
  
  func loadUI() {
    // Image View
    imageView?.removeFromSuperview()
    let image = UIImageView(image: UIImage(named: "Plant"))
    addSubview(image)
    imageView = image
    
    // Distance Label
    distanceLabel?.removeFromSuperview()
    let label = UILabel()
    label.font = UIFont.systemFontOfSize(15)
    label.textAlignment = .Center
    label.numberOfLines = 0
    label.backgroundColor = UIColor.clearColor()
    label.textColor = UIColor.whiteColor()
    self.addSubview(label)
    self.distanceLabel = label
  }
  
  func layoutUI() {
    imageView?.frame = CGRectMake(0, 0, imageView!.image!.size.width, imageView!.image!.size.height)
    distanceLabel?.frame = CGRectMake(0, imageView!.image!.size.height, self.frame.width, self.frame.height - imageView!.image!.size.height)
  }
  
}