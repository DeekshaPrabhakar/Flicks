//
//  DetailViewController.swift
//  Flicks
//
//  Created by Deeksha Prabhakar on 10/12/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ratingIcon: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var releaseDateIcon: UIImageView!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    var movie:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: (scrollView.frame.size.height + (infoView.frame.origin.y - infoView.frame.size.height)))
        
        let title = movie.title
        let overview = movie.overview
        
        titleLabel.text = title
        titleLabel.sizeToFit()
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        ratingLabel.text = String(movie.rating)
        ratingIcon.image = UIImage(named: "starWhite64")
        releaseDateLabel.text = movie.releaseDate
        releaseDateIcon.image = UIImage(named: "calendarWhite64")
        
        if  movie.posterPath != nil {
            let imageUrl = NSURL(string: movie.posterPath!)
            posterImageView.setImageWith(imageUrl as! URL)
        }
        
        navigationItem.title = title
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector(("toggleDetailsView:")))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeUp.delegate = self
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector(("toggleDetailsView:")))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        swipeDown.delegate = self
        self.view.addGestureRecognizer(swipeDown)
    }
    

    func toggleDetailsView(gesture: UIGestureRecognizer){
        let top:CGPoint = infoView.frame.origin
        let middle:CGPoint = CGPoint(x: infoView.frame.origin.x, y:(infoView.frame.size.height/2) as CGFloat)
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                
                UIView.animate(withDuration: 1.5, animations: {
                    self.infoView.frame.origin = top
                })
            case UISwipeGestureRecognizerDirection.down:
                
                UIView.animate(withDuration: 1.5, animations: {
                    self.infoView.frame.origin = middle
                })
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem?.title = "Back"
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
