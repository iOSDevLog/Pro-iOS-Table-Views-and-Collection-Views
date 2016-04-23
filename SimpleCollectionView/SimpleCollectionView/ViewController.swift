//
//  ViewController.swift
//  SimpleCollectionView
//
//  Created by huatian on 16/4/23.
//  Copyright © 2016年 iosdevlog. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - outlet
    @IBOutlet var collectionView: UICollectionView!
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
        // Configure collection view
        configureCollectionView()
    }
    
    // configure CollectionView
    func configureCollectionView() {
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
    }
    
    // MARK: - UICollectionViewDataSource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return suitsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cardsDictionary = self.suitsArray[section]
        let cardsArray = cardsDictionary["cards"] as! NSArray
        return cardsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CardCell", forIndexPath: indexPath)
        
        let suitDictionary = suitsArray[indexPath.section]
        let cardsArray = suitDictionary["cards"] as! [Dictionary<String, AnyObject>]
        let cardDictionary = cardsArray[indexPath.row]
        
        let cardImageName = cardDictionary["cardImage"] as! String
        
        if let cardImage = UIImage(named: cardImageName) {
            
            if let imageView = cell.contentView.viewWithTag(1000) as? UIImageView {
                imageView.image = cardImage
            }
            
        }
    
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 165, height: 240)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}

