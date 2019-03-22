//
//  MovieMainPage.swift
//  MovieTime
//
//  Created by crdr on 16/03/19.
//  Copyright © 2019 AAGroup. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import CCBottomRefreshControl

class MovieMainPage: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    var limit = 20
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var movie = [[String:AnyObject]]()
    var paginationRecords = [String]()
    let apiKey = "2758fdf8c2125bb54354ddc86d04c4a2"
    var api = "popular"
    private var searchController = UISearchController(searchResultsController: nil)
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var LefyBarButtonItemTitle: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        refreshControl.triggerVerticalOffset = 100.0
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.bottomRefreshControl = refreshControl
        
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.delegate = self
            controller.searchBar.delegate = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = true
            controller.searchBar.placeholder = "Search here"
            controller.searchBar.sizeToFit()
            return controller
        })()
    }
   
    @objc func refresh(){
        currentPage += 1
        getDetails()
    }

    func getDetails() -> Void {
        Alamofire.request("https://api.themoviedb.org/3/movie/\(api)?api_key=\(apiKey)&page=\(currentPage)").responseJSON { (responseData) -> Void  in
            if ((responseData.result.value) != nil){
                let jsonData = JSON(responseData.result.value!)
                if let movies = jsonData["results"].arrayObject {
                    self.movie.append(contentsOf: movies as! [[String: AnyObject]])
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func setApi(newApi: String) {
        self.movie.removeAll()
        currentPage = 1
        self.api = newApi
        getDetails()
    }
    
    @IBAction func Settings(_ sender: Any) {
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Top Rated", style: .default, handler: { action in
            self.topRatedClicked() }))
        
        alert.addAction(UIAlertAction(title: "Most Popular", style: .default, handler: { action in
            self.popularClicked() }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    //when top rated tapped
    func topRatedClicked() -> Void {
        setApi(newApi: "top_rated")
        self.LefyBarButtonItemTitle.title = "Top Rated Movies"
    }
    //when popular tapped
    func popularClicked() -> Void {
        setApi(newApi: "popular")
        self.LefyBarButtonItemTitle.title = "Most Popular Movies"
    }
    //when search icon clicked
    @IBAction func searchIcon(_ sender: Any) {
        configureSearch()
    }
    
    private func configureSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        //searchActive = false
        getDetails()
        self.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchText)").responseJSON { (responseData) -> Void  in
                if ((responseData.result.value) != nil){
                    let jsonData = JSON(responseData.result.value!)
                    if let searchMovies = jsonData["results"].arrayObject {
                        self.movie = searchMovies as! [[String : AnyObject]]
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

