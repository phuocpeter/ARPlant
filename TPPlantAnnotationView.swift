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
  
  var imageView: UIImageView?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    imageView?.removeFromSuperview()
    let image = UIImageView(image: UIImage(named: "Plant"))
    addSubview(image)
    imageView = image
    
    bindUi()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layoutUI()
  }
  
  func layoutUI() {
    imageView?.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
  }
  
}