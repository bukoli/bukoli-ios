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
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let text = searchController.searchBar.text!
        
        if (text == lastSearchText) {
            return
        }
        lastSearchText = text
        
        error = nil
        
        if (text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).characters.count == 0){
            self.suggestions = []
            self.tableView.reloadData()
            return
        }
        
        let parameters: [String: AnyObject] = [
            "keyword" : text
        ]
        
        request?.cancel()
        request = WebService.GET("point/autocomplete", parameters: parameters, success: {
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
                if (section == 0) {
                    return error != nil ? 1 : 0
                }
                return suggestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            return tableView.dequeueReusableCellWithIdentifier("ErrorCell", forIndexPath: indexPath)
        }
       return tableView.dequeueReusableCellWithIdentifier("SuggestionCell", forIndexPath: indexPath)
    }
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0){
            cell.textLabel?.text = error
            return
        }
        let suggestion = suggestions[indexPath.row]
        cell.textLabel?.text = suggestion.name
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0){
            return
    }
    
        let suggestion = suggestions[indexPath.row]
        bukoliMapViewController.placeId = suggestion.id
        bukoliMapViewController.updatePoints()
        bukoliMapViewController.searchController.active = false
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
    }
    
}
