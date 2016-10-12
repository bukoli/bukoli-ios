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
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let text = searchController.searchBar.text!
        
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
            //TODO: Error Handling
        }
    }
    
    // MARK - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let suggestion = suggestions[indexPath.row]
        cell.textLabel?.text = suggestion.name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
