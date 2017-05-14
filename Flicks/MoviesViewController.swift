//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Deeksha Prabhakar on 10/11/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie]?
    var filteredData:[Movie] = []
    var endpoint:String!
    var refreshControl:UIRefreshControl!
    var loadingStateView:LoadingIndicatorView?
    var isDataLoading = false
    var viewToggleBtn: UIButton!
    private var brain = MovieBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let picDimension = collectionView.frame.size.width/3
        flowLayout.itemSize =  CGSize(width:picDimension, height:picDimension)
        
        searchBar.delegate = self
        
        setUpToggleViewsButton()
        hideNetworkErrorView()
        setupRefreshControl()
        setUpLoadingIndicator()
        showLoadingIndicator()
        getOrRefreshMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateToggleButtonNView()
        
        if (endpoint == "now_playing"){
             navigationItem.title = "Now Playing"
        }
        else if (endpoint == "top_rated"){
            navigationItem.title = "Top Rated"
        }
    }
    
    private func updateToggleButtonNView(){
        let currView = brain.getCurrentView()
        if(currView == "table"){
            viewToggleBtn.setImage(UIImage(named: "collectionview"), for: .normal)
            collectionView.isHidden = true
            tableView.isHidden = false
            self.tableView.reloadData()
        }
        else if(currView == "collection"){
            viewToggleBtn.setImage(UIImage(named: "tableview"), for: .normal)
            tableView.isHidden = true
            collectionView.isHidden = false
            self.collectionView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            getOrRefreshMovies()
        } else {
            movies = (movies?.filter({(movieObj: Movie) -> Bool in
                return (movieObj.title.range(of: searchText, options: .caseInsensitive) != nil)
            }))!
            
            if(!tableView.isHidden){
                tableView.reloadData()
            }
            else if(!collectionView.isHidden){
                collectionView.reloadData()
            }
        }
    }
    
    
     func setUpToggleViewsButton(){
        viewToggleBtn = UIButton()
        viewToggleBtn.setImage(UIImage(named: "collectionview"), for: .normal)
        viewToggleBtn.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        viewToggleBtn.addTarget(self, action: #selector(toggleViews), for: .touchUpInside)
        
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = viewToggleBtn
        navigationItem.leftBarButtonItem = leftBarButtonItem
        updateToggleButtonNView()
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
                
                if(!self.tableView.isHidden){
                    self.tableView.reloadData()
                }
                else if(!self.collectionView.isHidden){
                    self.collectionView.reloadData()
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
            cell.posterView.alpha = 0
           
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                 cell.posterView.setImageWith(imageUrl as! URL)
                cell.posterView.alpha = 1
                }, completion: nil)
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(tableView.isHidden){
            brain.updateCurrentView(currView: "collection")
        }
        else if(collectionView.isHidden){
            brain.updateCurrentView(currView: "table")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell{
            let indexPath = tableView.indexPath(for: cell)
            let movie = movies![indexPath!.row]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
            brain.updateCurrentView(currView: "table")
        }
        else if let cell = sender as? UICollectionViewCell{
            let indexPath = collectionView.indexPath(for: cell)
            let movie = movies![indexPath!.row]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
            brain.updateCurrentView(currView: "collection")
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
}
