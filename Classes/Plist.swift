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
  enum PlistError: Error {
    case fileNotWritten
    case fileDoesNotExist
  }
  
  let name: String
  
  /// Source of the model plist in the bundle.
  var sourcePath: String? {
    guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
    return path
  }
  
  /// Destination of the plist in user's document.
  var destPath: String? {
    guard sourcePath != .none else { return .none }
    let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    return (dir as NSString).appendingPathComponent("\(name).plist")
  }
  
  // MARK: - Initialization
  
  init?(name: String) {
    self.name = name
    let fileManager = FileManager.default
    
    // Safety Checks
    guard let source = sourcePath else { return nil }
    guard let dest = destPath else { return nil }
    guard fileManager.fileExists(atPath: source) else { return nil }
    
    // No file exist in user's document
    if !fileManager.fileExists(atPath: dest) {
      do {
        try fileManager.copyItem(atPath: source, toPath: dest)
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
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: destPath!) {
      guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .none }
      return dict
    }
    return .none
  }
  
  /**
   * - Returns: A mutable dictionary of contents of the plist file.
   *            Returns nil if failed.
   */
  func getMutablePlistFile() -> NSMutableDictionary? {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: destPath!) {
      guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .none }
      return dict
    }
    return .none
  }
  
  /**
   * Adds values to plist File.
   * - Parameters:
   *   - dictionary: NSDictionary to be written
   * - Throws: FileNotWritten when operation failed.
   *           FileDoesNotExist when file cannot be found.
   */
  func addValuesToPlistFile(_ dictionary: NSDictionary) throws {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: destPath!) {
      if !dictionary.write(toFile: destPath!, atomically: false) {
        throw PlistError.fileNotWritten
      }
    } else {
      throw PlistError.fileDoesNotExist
    }
  }
  
}
