//
//  SingleTableViewCell.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 07-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//
//  The SingleTableViewCell can be used for both the TableView in the
//  SearchViewController and the FavoritesViewController. It contains some
//  information about the product with a small image.

import UIKit

class SingleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productPhotoImageView: UIImageView?
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    
    // MARK: - Standard methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Sets the cell as selected.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Initialization
    
    /// Initialize the elements.
    func initializeElements(data: ShopItem) {
        self.brandNameLabel.text = data.brand
        self.productNameLabel.text = data.productName
        self.originalPriceLabel.text = data.originalPrice
        
        // If there is a discounted price, strike through the original price.
        // Otherwise, hide the second label.
        if data.currentPrice == data.originalPrice {
            self.currentPriceLabel.isHidden = true
        }
        else {
            self.currentPriceLabel.isHidden = false
            self.currentPriceLabel.text = data.currentPrice
            strikeThrough(label: self.originalPriceLabel)
        }
        
        let url = data.imageThumbnailUrl
        if let poster = NSData(contentsOf: url) {
            self.productPhotoImageView?.image = UIImage(data: poster as Data)
        }
    }
    
    // MARK: - Costumize label
    
    /// Strikes through the original price.
    func strikeThrough(label: UILabel) {
        let attribute: NSMutableAttributedString =  NSMutableAttributedString(
            string: label.text!)
        
        attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 2,
                               range: NSMakeRange(0, attribute.length))
        label.attributedText = attribute
    }
}
