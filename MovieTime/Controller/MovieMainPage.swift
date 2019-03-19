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

//class Movie: NSObject{
//
//    var imageUrl: String?
//    var title: String?
//    var releaseDate: String?
//    var descrip: String?
//
//
//    init(imageUrl: String?, title: String, releaseDate: String, descrip: String) {
//        if let u = imageUrl {
//            self.imageUrl = "https://image.tmdb.org/t/p/w500\(u)"
//        }
//        self.title = title
//        self.releaseDate = releaseDate
//        self.descrip = descrip
//    }
//}

class MovieMainPage: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    var limit = 20
    var currentPage : Int = 0
    var isLoadingList : Bool = false
    var movie = [[String:AnyObject]]()
    var paginationRecords = [String]()
    let apiKey = "2758fdf8c2125bb54354ddc86d04c4a2"
    var api = "popular"
    private var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var LefyBarButtonItemTitle: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
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
    //   Pagination
//    func getListFromServer(_ pageNumber: Int){
//        self.isLoadingList = false
//        self.collectionView.reloadData()
//    }
//    func loadMoreItemsForList(){
//        currentPage += 1
//        getListFromServer(currentPage)
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
//            self.isLoadingList = true
//            self.loadMoreItemsForList()
//        }
//    }
    func getDetails() -> Void {
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(api)?api_key=\(apiKey)").responseJSON { (responseData) -> Void  in
            if ((responseData.result.value) != nil){
                let jsonData = JSON(responseData.result.value!)
                if let movies = jsonData["results"].arrayObject {
                    
                    self.movie = movies as! [[String : AnyObject]]
                    
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func setApi(newApi: String) {
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
    
    func topRatedClicked() -> Void {
        setApi(newApi: "top_rated")
        self.LefyBarButtonItemTitle.title = "Top Rated Movies"
    }
    
    func popularClicked() -> Void {
        setApi(newApi: "popular")
        self.LefyBarButtonItemTitle.title = "Most Popular Movies"
    }
    
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

