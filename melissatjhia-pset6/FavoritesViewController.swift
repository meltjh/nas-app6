//
//  FavoritesViewController.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 06-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User!
    var selectedItem: ShopItem?
    var favoriteItems: [ShopItem] = []
    let ref = FIRDatabase.database().reference(withPath: "saved-items")
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Height of a UITableViewCell
        favoritesTableView.rowHeight = UITableViewAutomaticDimension
        favoritesTableView.rowHeight = 140
        
        // If the user exists, collect its favorite items.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.allFavoriteItems()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - Favorite items
    
    func allFavoriteItems() {
        self.ref.child(user.uid).queryOrdered(byChild: "Date").observe(FIRDataEventType.value, with: { (snapshot) in
            self.favoriteItems = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                if let childDictionary = child.value as? [String: AnyObject] {
                    self.favoriteToShopItem(productId: childDictionary["ProductId"]! as! String)
                }
            }
        })
    }
    
    func favoriteToShopItem(productId: String) {
        let urlString = "https://api.zalando.com/articles/" + productId
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]

                    // Check if the response is true.
                    if json["errors"] != nil {
                    }
                    else {
                        self.favoriteItems.append(ShopItem(json: json))
                        self.favoritesTableView.reloadData()
                    }
                } catch {
                }
            }
        }).resume()
    }
    
    // MARK: - UITableView methods
    
    /// Go to the view with the details of the selected product.
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = self.favoriteItems[indexPath.row]
        self.performSegue(withIdentifier: "detailFavoriteSegue", sender: self)
    }
    
    /// Returns the number of UITableViewCells that have to be filled.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItems.count
    }
    
    /// Fills the UITableViewCell with the product data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteCell",for: indexPath) as! SingleTableViewCell
        cell.initializeElements(data: favoriteItems[indexPath.row])
        return cell
    }
    
    /// Deletes the UITableViewCell from the UITableView.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToRemove = favoriteItems[indexPath.row]
            self.ref.child(user.uid).child(itemToRemove.productId).removeValue()
        }
    }
    
    // MARK: - Segue preparation
    
    /// Prepares the movie information that has to be shown in the DetailedViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as?
            DetailedViewController {
            vc.selectedItem = self.selectedItem
        }
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

