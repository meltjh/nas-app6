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
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    let ref = FIRDatabase.database().reference(withPath: "saved-items")

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
            self.brandNameLabel.text = selectedItem.brand
            self.productNameLabel.text = selectedItem.productName
            self.originalPriceLabel.text = selectedItem.originalPrice
            
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
            let url2 = selectedItem?.imageSmallUrl2
            if let picture2 = NSData(contentsOf: url2!) {
                self.productPhotoImageView2?.image = UIImage(data: picture2 as Data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds user to the online users.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Signs out the user.
    @IBAction func signOutDidTouch(_ sender: Any) {
        do {
            try FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }

    /// Strikes through the task string if it is checked.
    func strikeThrough(label: UILabel) {
        let attribute: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
        attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attribute.length))
        label.attributedText = attribute
    }
    
    /// Adds the productId to the userId branch in FireBase.
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
                                        let savedItem = SavedItem(productId: selectedItem.productId, savedByUser: self.user.email)
                                        let savedItemRef = self.ref.child(user.uid).child(selectedItem.productId)
                                        savedItemRef.setValue(savedItem.toAnyObject())
    }
}
