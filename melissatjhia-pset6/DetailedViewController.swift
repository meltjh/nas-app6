//
//  DetailedViewController.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 08-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    var selectedItem: shopItem?
    
    @IBOutlet weak var browserButton: UIButton!
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UITextView!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var productPhotoImageView1: UIImageView?
    @IBOutlet weak var productPhotoImageView2: UIImageView?
    override func viewWillAppear(_ animated: Bool) {
        
        if selectedItem != nil {
            self.brandNameLabel.text = selectedItem!.brand
            self.productNameLabel.text = selectedItem!.productName
            self.originalPriceLabel.text = selectedItem!.originalPrice
            
            if selectedItem?.originalPrice == selectedItem!.currentPrice {
                self.currentPriceLabel.isHidden = true
            }
            else {
                self.currentPriceLabel.text = selectedItem!.currentPrice
                strikeThrough(label: originalPriceLabel)
            }
            
            let url1 = selectedItem?.imageSmallUrl1
            if let picture1 = NSData(contentsOf: url1!) {
                self.productPhotoImageView1?.image = UIImage(data: picture1 as Data)
            }
            let url2 = selectedItem?.imageSmallUrl2
            if let picture2 = NSData(contentsOf: url2!) {
                self.productPhotoImageView2?.image = UIImage(data: picture2 as Data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Strikes through the task string if it is checked.
    func strikeThrough(label: UILabel) {
        let attribute: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
            attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attribute.length))
        label.attributedText = attribute
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
