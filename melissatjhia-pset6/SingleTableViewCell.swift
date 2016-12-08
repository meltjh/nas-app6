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
    func initializeElements(data: shopItem) {
        self.brandNameLabel.text = data.brand
        self.productNameLabel.text = data.productName
        self.originalPriceLabel.text = data.originalPrice
        
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// Strikes through the task string if it is checked.
    func strikeThrough(label: UILabel) {
        let attribute: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
        attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attribute.length))
        label.attributedText = attribute
    }
    
//    // Set the alpha value of an imageview using an smooth fading animation
//    func updateImageVisibility(alpha: Double, duration: Double = 0.5){
//        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: { () -> Void in
//            self.productPhotoImageView.alpha = CGFloat(alpha)
//        }, completion: { (Bool) -> Void in    }
//        )
//    }
}
