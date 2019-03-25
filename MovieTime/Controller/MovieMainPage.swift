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

class MovieMainPage: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
   
    //properties
    private var searchController = UISearchController(searchResultsController: nil)
    var activityIndiator: UIActivityIndicatorView?
    var totalCount: NSInteger?
    
    //outlets
    @IBOutlet weak var LefyBarButtonItemTitle: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        activityIndicatorMenu()
        searchBarControllerMenu()
    }
   
    func searchBarControllerMenu(){
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
    
    func activityIndicatorMenu() {
        activityIndiator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.midX - 15, y: self.view.frame.height - 140, width: 30, height: 30))
        activityIndiator?.style = .white
        activityIndiator?.color = UIColor.black
        activityIndiator?.hidesWhenStopped = true
        activityIndiator?.backgroundColor = UIColor.groupTableViewBackground
        activityIndiator?.layer.cornerRadius = 15
        self.view.addSubview(activityIndiator!)
        self.view.bringSubviewToFront(activityIndiator!)
    }
    
    @objc func refresh(){
        API.isGetResponse = false
        activityIndiator?.startAnimating()
        self.view.bringSubviewToFront(activityIndiator!)
        API.currentPage = API.currentPage + 1
        getDetails()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if API.isGetResponse {
            if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height)
            {
                if totalCount! > MoviewDetails.movie.count{
                    refresh()
                }
            }
        }
    }
    
    func getDetails() -> Void {
        Alamofire.request("https://api.themoviedb.org/3/movie/\(API.api)?api_key=\(API.apiKey)&page=\(API.currentPage)").responseJSON { (responseData) -> Void  in
            if ((responseData.result.value) != nil){
                let jsonData = JSON(responseData.result.value!)
                if let movies = jsonData["results"].arrayObject {
                    MoviewDetails.movie.append(contentsOf: movies as! [[String: AnyObject]])
                    self.activityIndiator?.stopAnimating()
                    API.isGetResponse = true
                }
                if let totalMoviesArray = jsonData["total_results"].int {
                    self.totalCount = totalMoviesArray
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func setApi(newApi: String) {
        MoviewDetails.movie.removeAll()
        API.currentPage = 1
        API.api = newApi
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
            Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=\(API.apiKey)&query=\(searchText)").responseJSON { (responseData) -> Void  in
                if ((responseData.result.value) != nil){
                    let jsonData = JSON(responseData.result.value!)
                    if let searchMovies = jsonData["results"].arrayObject {
                        MoviewDetails.movie = searchMovies as! [[String : AnyObject]]
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

