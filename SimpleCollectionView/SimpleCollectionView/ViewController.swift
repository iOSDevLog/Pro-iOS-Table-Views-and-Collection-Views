//
//  ViewController.swift
//  SimpleCollectionView
//
//  Created by huatian on 16/4/23.
//  Copyright © 2016年 iosdevlog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - perporty
    var suitsArray = [Dictionary<String, AnyObject>]()
    
    enum ParsingError: ErrorType {
        case MissingJson
        case JsonParsingError
    }
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configure data
        do {
            try setupData()
        } catch ParsingError.MissingJson {
            print("Error loading JSON")
        } catch ParsingError.JsonParsingError {
            print("Error parsing JSON")
        } catch {
            print("Something went wrong")
        }
    }
    
    // MARK: Data setup
    func setupData () throws {
        guard let filePath = NSBundle.mainBundle().pathForResource("cards", ofType: "json"), jsonData = NSData(contentsOfFile: filePath) else {
            throw ParsingError.MissingJson
        }
        
        do {
            let parsedObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            suitsArray = parsedObject["suits"] as! Array
        } catch {
            throw ParsingError.JsonParsingError
        }
    }
}

