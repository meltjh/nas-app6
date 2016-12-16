//
//  SearchViewController.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 06-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//
//  The user can search through the Zalando catalogus by typing terms in the
//  search bar.

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    var shopItems: [ShopItem] = []
    var selectedItem: ShopItem?
    
    // MARK: - Loading of the View
    
    /// When loaded, fills the searchResultsTableView with results from the default search.
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Height of the UITableViewCell
        searchResultsTableView.rowHeight = UITableViewAutomaticDimension
        searchResultsTableView.rowHeight = 140
        
        // Default search when the view is loaded.
        getData(queryTerms: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Retrieving data from API
    
    /// Collects the search results in structs that can be used for the UITableView.
    func getData(queryTerms: String) {

        let searchString = queryTerms.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://api.zalando.com/articles/?fullText=" + searchString
        let request = URLRequest(url: URL(string: urlString)!)

        URLSession.shared.dataTask(with: request, completionHandler: { data,
            response, error in
            
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                self.shopItems = []
                print(error!)
                return
            }
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let json = try JSONSerialization.jsonObject(
                        with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if json["errors"] == nil {

                        // The list with results.
                        self.shopItems = []
                        let searchResults = json["content"] as! [Dictionary<String, AnyObject>]
                        for item in searchResults {
                            self.shopItems.append(ShopItem(json: item))
                        }
                        self.searchResultsTableView.reloadData()
                    }
                } catch {
                    self.shopItems = []
                    print(error)
                }
            }
        }).resume()
    }
    
    // MARK: - UISearchBar methods
    
    /// Dismisses the keyboard when the 'Cancel' Button is clicked.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    /// Dismisses the keyboard when the 'Seach' Button is clicked.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    /// Search for the input of the SearchBar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getData(queryTerms: searchText)
    }
    
    // MARK: - UITableView methods
    
    /// Go to the view with the details of the selected product.
    func tableView(_ didSelectRowAttableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        self.selectedItem = self.shopItems[indexPath.row]
        self.performSegue(withIdentifier: "detailResultSegue", sender: self)
    }
    
    /// Returns the number of TableViewCells that have to be filled.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {

            return shopItems.count
    }
    
    /// Fills the TableViewCell with the product data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

            let cell = self.searchResultsTableView.dequeueReusableCell(
                withIdentifier: "resultCell", for: indexPath) as! SingleTableViewCell
            cell.initializeElements(data: shopItems[indexPath.row])

            return cell
    }
    
    // MARK: - Segue
    
    /// Prepares the item information that has to be shown in the DetailedViewController.
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

