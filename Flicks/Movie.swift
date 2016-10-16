//
//  Movie.swift
//  Flicks
//
//  Created by Deeksha Prabhakar on 10/14/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var movieID:Int!
    var title: String!
    var overview:String!
    
    var releaseDate:String?
    var rating:Double!
    
    var posterPath:String?
    
    init(dict:NSDictionary) {
        
        super.init()
        
        if(dict.count > 0){
            movieID = dict["id"] as! Int
            title = dict["title"] as! String
            overview = dict["overview"] as! String
            releaseDate = formatDate(dtString: (dict["release_date"] as? String))
            rating = dict["vote_average"] as? Double
            
            if let poster = dict["poster_path"] as? String {
                let baseUrl = "https://image.tmdb.org/t/p/w500"
                posterPath =   baseUrl + poster
            }
            else{
                posterPath = nil
            }
        }
    }
    
    private func formatDate(dtString: String?) -> String {
        if let dateStr = dtString as String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let reldate = dateFormatter.date(from: dateStr)
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: reldate!)
        }
        else{
            return ""
        }
    }
}
