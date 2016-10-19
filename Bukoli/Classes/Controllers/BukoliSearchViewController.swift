//
//  BukoliSearchViewController.swift
//  Pods
//
//  Created by Utku Yıldırım on 02/10/2016.
//
//

import UIKit
import Alamofire

class BukoliSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var bukoliMapViewController: BukoliMapViewController!
    
    var suggestions: [Suggestion] = []
    
    var request: Request?
    
    var lastSearchText: String?
    
    var error: String?
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let text = searchController.searchBar.text!
        
        if (text == lastSearchText) {
            return
        }
        lastSearchText = text
        
        error = nil
        
        if (text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count == 0) {
            // End
            self.suggestions = []
            self.tableView.reloadData()
            return
        }
        
        let parameters: [String: Any] = [
            "keyword" : text
        ]
        
        request?.cancel()
        request = WebService.GET(uri: "point/autocomplete", parameters: parameters, success: {
            (response: [Suggestion]) in
            self.suggestions = response
            self.tableView.reloadData()
        }) {
            (error: Error) in
            self.error = error.error
            self.suggestions = []
            self.tableView.reloadData()
        }
    }
    
    // MARK - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return error != nil ? 1 : 0
        }
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            return tableView.dequeueReusableCell(withIdentifier: "ErrorCell", for: indexPath)
        }
        return tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            cell.textLabel?.text = error
            return
        }
        let suggestion = suggestions[indexPath.row]
        cell.textLabel?.text = suggestion.name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            return
        }
        
        let suggestion = suggestions[indexPath.row]
        bukoliMapViewController.placeId = suggestion.id
        bukoliMapViewController.updatePoints()
        bukoliMapViewController.searchController.isActive = false
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
    }
    
}
