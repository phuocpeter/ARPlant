//
//  Plist.swift
//  ARPlant
//
//  Created by Tran Thai Phuoc on 2016-09-01.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import Foundation

/**
 * Handles Plist file reading and writing.
 */
struct Plist {
  
  /// Error cases of Plist.
  enum PlistError: ErrorType {
    case FileNotWritten
    case FileDoesNotExist
  }
  
  let name: String
  
  /// Source of the model plist in the bundle.
  var sourcePath: String? {
    guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else { return .None }
    return path
  }
  
  /// Destination of the plist in user's document.
  var destPath: String? {
    guard sourcePath != .None else { return .None }
    let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    return (dir as NSString).stringByAppendingPathComponent("\(name).plist")
  }
  
  // MARK: - Initialization
  
  init?(name: String) {
    self.name = name
    let fileManager = NSFileManager.defaultManager()
    
    // Safety Checks
    guard let source = sourcePath else { return nil }
    guard let dest = destPath else { return nil }
    guard fileManager.fileExistsAtPath(source) else { return nil }
    
    // No file exist in user's document
    if !fileManager.fileExistsAtPath(dest) {
      do {
        try fileManager.copyItemAtPath(source, toPath: dest)
      } catch let error as NSError {
        print("Unable to copy file. Error: \(error.localizedDescription)")
        return nil
      }
    }
  }
  
  // MARK: - Struct Methods
  
  /**
   * - Returns: A dictionary of contents of the plist file.
   *            Returns nil if failed.
   */
  func getValuesInPlistFile() -> NSDictionary? {
    let fileManager = NSFileManager.defaultManager()
    if fileManager.fileExistsAtPath(destPath!) {
      guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .None }
      return dict
    }
    return .None
  }
  
  /**
   * - Returns: A mutable dictionary of contents of the plist file.
   *            Returns nil if failed.
   */
  func getMutablePlistFile() -> NSMutableDictionary? {
    let fileManager = NSFileManager.defaultManager()
    if fileManager.fileExistsAtPath(destPath!) {
      guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .None }
      return dict
    }
    return .None
  }
  
  /**
   * Adds values to plist File.
   * - Parameters:
   *   - dictionary: NSDictionary to be written
   * - Throws: FileNotWritten when operation failed.
   *           FileDoesNotExist when file cannot be found.
   */
  func addValuesToPlistFile(dictionary: NSDictionary) throws {
    let fileManager = NSFileManager.defaultManager()
    if fileManager.fileExistsAtPath(destPath!) {
      if !dictionary.writeToFile(destPath!, atomically: false) {
        throw PlistError.FileNotWritten
      }
    } else {
      throw PlistError.FileDoesNotExist
    }
  }
  
}
