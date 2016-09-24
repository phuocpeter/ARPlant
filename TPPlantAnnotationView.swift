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
    label.font = UIFont.systemFont(ofSize: 15)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.backgroundColor = UIColor.clear
    label.textColor = UIColor.white
    self.addSubview(label)
    self.distanceLabel = label
  }
  
  func layoutUI() {
    imageView?.frame = CGRect(x: 0, y: 0, width: imageView!.image!.size.width, height: imageView!.image!.size.height)
    distanceLabel?.frame = CGRect(x: 0, y: imageView!.image!.size.height, width: self.frame.width, height: self.frame.height - imageView!.image!.size.height)
  }
  
}
