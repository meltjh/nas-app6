//
//  SingleTableViewCell.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 07-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class SingleTableViewCell: UITableViewCell {

    @IBOutlet weak var productPhotoImageView: UIImageView?
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!

    // Setting and accessing the celldata
    func initializeElements(data: ShopItem) {
        self.brandNameLabel.text = data.brand
        self.productNameLabel.text = data.productName
        self.originalPriceLabel.text = data.originalPrice
        
        /// If there is a discounted price, strike through the original price. Otherwise, hide the second label.
        if data.currentPrice == data.originalPrice {
            self.currentPriceLabel.isHidden = true
        }
        else {
            self.currentPriceLabel.text = data.currentPrice
            strikeThrough(label: self.originalPriceLabel)
        }

        let url = data.imageThumbnailUrl
        if let poster = NSData(contentsOf: url) {
                self.productPhotoImageView?.image = UIImage(data: poster as Data)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// Strikes through the original price.
    func strikeThrough(label: UILabel) {
        let attribute: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
        attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attribute.length))
        label.attributedText = attribute
    }
}
