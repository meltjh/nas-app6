//
//  ShopItem.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 08-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

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
    let imageMediumUrl1: URL
    let imageMediumUrl2: URL?
    
    init(json: Dictionary<String, AnyObject>) {
        self.productId = json["id"] as! String
        self.shopUrl = json["shopUrl"] as! String
        self.productName = json["name"] as! String
        self.brand = json["brand"]?["name"] as! String
        let unit = (json["units"] as! [Dictionary<String, AnyObject>]).first
        self.currentPrice = unit?["price"]?["formatted"] as! String
        self.originalPrice = unit?["originalPrice"]?["formatted"] as! String
        
        let media = json["media"]?["images"] as! [Dictionary<String, AnyObject>]
        let picture1 = media.first
        self.imageThumbnailUrl = URL(string: picture1!["smallUrl"] as! String)!
        self.imageSmallUrl1 = URL(string: picture1!["smallHdUrl"] as! String)!
        self.imageMediumUrl1 = URL(string: picture1!["mediumHdUrl"] as! String)!
        
        if media.count > 1 {
            let picture2 = media[1]
            self.imageSmallUrl2 = URL(string: (picture2["smallHdUrl"] as? String)!)!
            self.imageMediumUrl2 = URL(string: (picture2["mediumHdUrl"] as? String)!)!
        }
        else {
            self.imageSmallUrl2 = nil
            self.imageMediumUrl2 = nil
        }
    }
}
