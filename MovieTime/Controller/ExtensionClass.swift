//
//  ExtensionClass.swift
//  MovieTime
//
//  Created by crdr on 19/03/19.
//  Copyright © 2019 AAGroup. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension MovieMainPage: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoviewDetails.movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellForDetails
        var dict = MoviewDetails.movie[indexPath.row]
        cell.imageView.image = nil
        
        Alamofire.request("https://image.tmdb.org/t/p/w500\(dict["poster_path"] ?? "" as AnyObject)" ).responseImage { response in
            guard let image = response.result.value else {  return }
            cell.imageView.image = image
        }
        cell.title.text = dict["title"] as? String
        cell.dateOfR.text = ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MoviewDetails.movieDetails = MoviewDetails.movie[indexPath.row]
    }
}

