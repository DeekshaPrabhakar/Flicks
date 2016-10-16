//
//  DetailViewController.swift
//  Flicks
//
//  Created by Deeksha Prabhakar on 10/12/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var infoView: UIView!
    
    var movie:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie.title
        let overview = movie.overview
        
        titleLabel.text = title
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit()
        
        if  movie.posterPath != nil {
            let imageUrl = NSURL(string: movie.posterPath!)
            posterImageView.setImageWith(imageUrl as! URL)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
