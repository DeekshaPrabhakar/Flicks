//
//  MovieBrain.swift
//  Flicks
//
//  Created by Deeksha Prabhakar on 10/14/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class MovieBrain: NSObject {
    
    func getMovies(endpoint: String, success:@escaping (_ movies:[Movie]?, _ error:AnyObject?)->()){
        
        let apiKey = "3fde3a7001c8039ba2283ebb55662938"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?language=en-US&api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let err = error {
                success(nil, err as NSError?)
            }
            else {
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        NSLog("response: \(responseDictionary)")
                        
                        if let allMovies = responseDictionary["results"] as? [NSDictionary] {
                        var moviesList = [Movie]()
                        var movieObj:Movie
                        
                        for mObj in allMovies
                        {
                            movieObj =  Movie(dict: mObj)
                            moviesList.append(movieObj)
                        }
                         success(moviesList, nil)
                        }
                        else{
                            success(nil, "Resource not found" as AnyObject?)
                        }
                    }
                }
            }
        });
        task.resume()
    }
}
/* */
