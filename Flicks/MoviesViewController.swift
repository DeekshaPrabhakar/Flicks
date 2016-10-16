//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Deeksha Prabhakar on 10/11/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var movies: [Movie]?
    var endpoint:String!
    var refreshControl:UIRefreshControl!
    var loadingStateView:LoadingIndicatorView?
    var isDataLoading = false
    var viewToggleBtn: UIButton!
    
    @IBOutlet weak var networkErrorView: UIView!
    private var brain = MovieBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.isHidden = false
        collectionView.isHidden = true
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let picDimension = collectionView.frame.size.width/3
        flowLayout.itemSize =  CGSize(width:picDimension, height:picDimension)
        
        setUpToggleViewsButton()
        hideNetworkErrorView()
        setupRefreshControl()
        setUpLoadingIndicator()
        showLoadingIndicator()
        getOrRefreshMovies()
    }
    
    private func setUpToggleViewsButton(){
        viewToggleBtn = UIButton()
        viewToggleBtn.setImage(UIImage(named: "collectionview"), for: .normal)
        viewToggleBtn.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        viewToggleBtn.addTarget(self, action: #selector(MoviesViewController.toggleViews), for: .touchUpInside)
        
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = viewToggleBtn
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func showNetworkErrorView(){
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.networkErrorView.isHidden = false
            self.networkErrorView.frame.size.height = 44
            }, completion: nil)
    }
    
    private func hideNetworkErrorView(){
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.networkErrorView.isHidden = true
            self.networkErrorView.frame.size.height = 0
            }, completion: nil)
    }
    
    private func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getOrRefreshMovies), for: UIControlEvents.valueChanged)
        let attributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)]
        let attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = UIColor.black
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    private func setUpLoadingIndicator(){
        var middleY = UIScreen.main.bounds.size.height/2;
        middleY  = middleY - self.navigationController!.navigationBar.frame.height - self.tabBarController!.tabBar.frame.height
        let frame = CGRect(x: 0, y: middleY, width: tableView.bounds.size.width, height: LoadingIndicatorView.defaultHeight)
        loadingStateView = LoadingIndicatorView(frame: frame)
        loadingStateView!.isHidden = true
        tableView.addSubview(loadingStateView!)
    }
    
    private func showLoadingIndicator(){
        isDataLoading = true
        loadingStateView!.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        isDataLoading = false
        loadingStateView!.stopAnimating()
    }
    
    func getOrRefreshMovies() {
        
        brain.getMovies(endpoint: endpoint) { (movies, error) in
            if(error != nil) {
                self.hideLoadingIndicator()
                self.showNetworkErrorView()
            }
            else {
                self.movies = movies
                self.refreshControl.endRefreshing()
                self.hideLoadingIndicator();
                if(self.tableView.isHidden){
                    self.collectionView.reloadData()
                }
                else{
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleViews(sender: UIButton){
        
        if(tableView.isHidden){
            viewToggleBtn.setImage(UIImage(named: "collectionview"), for: .normal)
            collectionView.isHidden = true
            tableView.isHidden = false
            self.tableView.reloadData()
        }
        else
        {
            viewToggleBtn.setImage(UIImage(named: "tableview"), for: .normal)
            tableView.isHidden = true
            collectionView.isHidden = false
            self.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = movies![indexPath.item]
        
        if  movie.posterPath != nil {
            let imageUrl = NSURL(string: movie.posterPath!)
            //cell.posterView.setImageWith(imageUrl as! URL)
        }
        
        print("row \(indexPath.row)")
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            return movies.count
        }
        else
        {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = movie.overview
        cell.overviewLabel.sizeToFit()
        cell.ratingLabel.text = String(movie.rating)
        cell.ratingIcon.image = UIImage(named: "star")
        cell.releaseDateLabel.text = movie.releaseDate
        cell.releaseDateIcon.image = UIImage(named: "calendar")
        
        if  movie.posterPath != nil {
            let imageUrl = NSURL(string: movie.posterPath!)
            cell.posterView.setImageWith(imageUrl as! URL)
        }
        
        print("row \(indexPath.row)")
        return cell
    }
    
    func networkRequest(){
        let apiKey = "3fde3a7001c8039ba2283ebb55662938"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)?language=en-US&api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    //self.movies = (responseDictionary["results"] as! [NSDictionary])
                    
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UITableViewCell{
            let indexPath = tableView.indexPath(for: cell)
            let movie = movies![indexPath!.row]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
        else if let cell = sender as? UICollectionViewCell{
            let indexPath = collectionView.indexPath(for: cell)
            let movie = movies![indexPath!.row]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
        
    }
    
    
}
