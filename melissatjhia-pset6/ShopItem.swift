//
//  ShopItem.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 08-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//
//  A ShopItem contains all the information that is needed for it to be able
//  to be used for both the SearchViewController, FavoritesViewController and
//  the DetailedViewController.

import Foundation

struct ShopItem {
    
    let productId: String
    let shopUrl: String
    let productName: String
    let brand: String
    let currentPrice: String
    let originalPrice: String
    let imageThumbnailUrl: URL
    let imageSmallUrl1: URL
    let imageSmallUrl2: URL?
    
    /// The struct is initialized in a way that it can be used for different
    /// ViewControllers.
    init(json: Dictionary<String, AnyObject>) {
        self.productId = json["id"] as! String
        self.shopUrl = json["shopUrl"] as! String
        self.productName = json["name"] as! String
        self.brand = json["brand"]?["name"] as! String
        
        // Prices are saved per size in a dictionary called 'units'.
        let unit = (json["units"] as! [Dictionary<String, AnyObject>]).first
        self.currentPrice = unit?["price"]?["formatted"] as! String
        self.originalPrice = unit?["originalPrice"]?["formatted"] as! String
        
        // Product images are saved in a dictionray called 'media'.
        let media = json["media"]?["images"] as! [Dictionary<String, AnyObject>]
        let picture1 = media.first
        self.imageThumbnailUrl = URL(string: picture1!["smallUrl"] as! String)!
        self.imageSmallUrl1 = URL(string: picture1!["smallHdUrl"] as! String)!
        
        // In case there is or is not a second product picture.
        if media.count > 1 {
            let picture2 = media[1]
            self.imageSmallUrl2 = URL(string: (picture2["smallHdUrl"] as? String)!)!
        }
        else {
            self.imageSmallUrl2 = nil
        }
    }
}
