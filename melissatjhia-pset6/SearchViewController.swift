//
//  SearchViewController.swift
//  melissatjhia-pset6
//
//  Created by Melissa Tjhia on 06-12-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    var searchResults: [Dictionary<String, AnyObject>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.rowHeight = UITableViewAutomaticDimension
        searchResultsTableView.rowHeight = 140
        
        let searchString = "Vagabond grace"
        getData(queryTerms: searchString)
        print(searchResults)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutDidTouch(_ sender: Any) {
        print("out")
        do {
            try FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func getData(queryTerms: String) {
        let searchString = queryTerms.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://api.zalando.com/articles/?fullText=" + searchString
        print("URLSTRING", urlString)
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            // Guards execute when the condition is NOT met.
            guard let data = data, error == nil else {
                return
            }
            print("RESULT")
            DispatchQueue.main.async {
                do {
                    // Convert data to json.
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                    
                    // Check if the response is true.
                    if json["Error"] != nil {
                    }
                    else {
                        // The list with results.
                        self.searchResults = json["content"] as! [Dictionary<String, AnyObject>]
                        print("JSON", json["content"])
                        self.searchResultsTableView.reloadData()
                    }
                } catch {
                }
            }
        }).resume()
    }
    
//    /// Go to the view with the details of the selected movie TableViewCell.
//    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellInfo = searchResults[indexPath.row]
//        selectedId = cellInfo["imdbID"] as! String
//        self.performSegue(withIdentifier: "detailedResultSegue", sender: self)
//    }
    
    /// Returns the number of TableViewCells that have to be filled.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    /// Fills the TableViewCell with the movie data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchResultsTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! SingleTableViewCell
        let cellInfo =  searchResults[indexPath.row]
        cell.brandNameLabel.text = cellInfo["brand"]!["name"] as! String?
        cell.productNameLabel.text = cellInfo["name"] as! String?

        cell.priceLabel.text = ""
        
        cell.productPhotoImageView.image = nil
        
//        if let url = cellInfo["media"]?["images"][0]["thumbnailHdUrl"] as? String {
//            if let productImage = NSData(contentsOf: url as! URL) {
//                cell.productPhotoImageView.image = UIImage(data: productImage as Data)
//            }
//        }
        return cell
    }

    
}

