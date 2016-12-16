//
//  DetailedViewController.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 08-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit
import Firebase

class DetailedViewController: UIViewController {
    var selectedItem: ShopItem!
    var user: User!
    let ref = FIRDatabase.database().reference(withPath: "saved-items")
    
    @IBOutlet weak var browserButton: UIButton!
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UITextView!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var productPhotoImageView1: UIImageView?
    @IBOutlet weak var productPhotoImageView2: UIImageView?
    
    /// Gives the attributes of the UIView the right values.
    override func viewWillAppear(_ animated: Bool) {
        if selectedItem != nil {
            self.brandNameLabel.text = selectedItem.brand
            self.productNameLabel.text = selectedItem.productName
            self.originalPriceLabel.text = selectedItem.originalPrice
            
            // If discounted price is available, strike through the original price.
            if selectedItem?.originalPrice == selectedItem.currentPrice {
                self.currentPriceLabel.isHidden = true
            }
            else {
                self.currentPriceLabel.text = selectedItem.currentPrice
                strikeThrough(label: originalPriceLabel)
            }
            
            let url1 = selectedItem?.imageSmallUrl1
            if let picture1 = NSData(contentsOf: url1!) {
                self.productPhotoImageView1?.image = UIImage(data: picture1 as Data)
            }
            
            // There is not always a second product image.
            let url2 = selectedItem?.imageSmallUrl2
            if let picture2 = NSData(contentsOf: url2!) {
                self.productPhotoImageView2?.image = UIImage(data: picture2 as Data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            // Check whether the product is (not) in the favorites, change button title accordingly.
            self.ref.child(user.uid).observe(FIRDataEventType.value, with: { (snapshot) in
                if snapshot.hasChild(self.selectedItem.productId) {
                    self.addFavoriteButton.setTitle("Remove from favorites 💔", for: .normal)
                }
                else {
                    self.addFavoriteButton.setTitle("Add to favorites! ⭐️", for: .normal)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Strikes through the task string if it is checked.
    func strikeThrough(label: UILabel) {
        let attribute: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
        attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attribute.length))
        label.attributedText = attribute
    }
    
    /// Adds the productId to the userId branch in FireBase.
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let userRef = self.ref.child(user.uid)
        
        // If the item is a favorite, remove it. Otherwise, add it to favorites.
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(self.selectedItem.productId) {
                userRef.child(self.selectedItem.productId).removeValue()
            }
            else {
                // Put the current date (converted to double) in Firebase.
                let date = NSDate()
                let interval = date.timeIntervalSince1970
                
                userRef.child(self.selectedItem.productId).setValue(["ProductId": self.selectedItem.productId, "Date": interval])
            }
        })
    }
    
    // MARK: - Sign out

    /// Signs out the user.
    @IBAction func signOutDidTouch(_ sender: Any) {
        do {
            try FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(NSDate(), forKey: "ZalandoLastUsed")
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
