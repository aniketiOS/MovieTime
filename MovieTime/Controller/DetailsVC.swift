//
//  DetailsVC.swift
//  MovieTime
//
//  Created by crdr on 18/03/19.
//  Copyright © 2019 AAGroup. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class DetailsVC: UIViewController {

    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overView: UITextView!
    @IBOutlet weak var userRating: UILabel!
    
    let formatter = DateFormatter()
    let dateFormatterToDisplay = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailsAreHere()
    }

    func DetailsAreHere() -> Void {
        formatter.dateFormat = "yyyy-MM-dd"
        dateFormatterToDisplay.dateFormat = "MMM dd,yyyy"
        let dateInDateFormat = formatter.date(from: (MoviewDetails.movieDetails["release_date"] as? String)!)
        
        Alamofire.request("https://image.tmdb.org/t/p/w500\(MoviewDetails.movieDetails["backdrop_path"] ?? "" as AnyObject)" ).responseImage { response in
            guard let image = response.result.value else {  return }
            self.imageThumbnail.image = image
            self.imageThumbnail.contentMode = .scaleAspectFit
        }
        
        originalTitle.text = MoviewDetails.movieDetails["original_title"] as? String
        releaseDate.text = dateFormatterToDisplay.string(from: dateInDateFormat!)
        overView.text = MoviewDetails.movieDetails["overview"] as? String
        let ratingsInNumber = ((MoviewDetails.movieDetails["vote_average"] as! Double) * 100).rounded()/100
        userRating.text = "\(ratingsInNumber)"
    }
}
