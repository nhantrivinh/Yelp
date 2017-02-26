//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var selectedBusiness: Business!
    
    var limit = 10
    var offset = 100
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        setupLoadingMoreView()
//        loadMoreData(searchString: "Thai")
        loadMoreData(searchString: "Restaurants", sort: 0, categories: nil, deals: nil, radius: nil)
    }
    
    func setupLoadingMoreView() {
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let busineses = businesses {
            return businesses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell {
            cell.business = businesses[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBusiness = self.businesses[indexPath.row]
        self.selectedBusiness = selectedBusiness
        performSegue(withIdentifier: "ShowMap", sender: nil)
    }
}

extension BusinessesViewController: FiltersVCDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController {
            let filtersVC = navigationController.topViewController as! FiltersVC
            filtersVC.delegate = self
        } else {
            let mapVC = segue.destination as! MapVC
            mapVC.business = selectedBusiness
        }
        
    }
    
    func filtersVC(filterVC: FiltersVC, didUpdateFilters filters: [String : AnyObject]) {
        var categories = filters["categories"] as? [String]
        var sort = filters["sort"] as! Int
        var radius: Float? = nil
        if sort == 1 {
            radius = filters["radius_filter"] as! Float
        }
        var deals = filters["deals_filter"] as! Bool
        
        loadMoreData(searchString: "Restaurants", sort: sort, categories: categories, deals: deals, radius: radius)
    }
    
//    func filterVCSortType(filterVC: FiltersVC, didUpdateSortType chosenSort: Int) {
//        print("Sort Type: \(chosenSort)")
//        loadMoreData(searchString: "Restaurants", sort: chosenSort)
//    }
}

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                if self.limit == self.offset {
                    return
                }
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                self.limit += 5
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()		
            }
        }
    }
    
    func loadMoreData(searchString: String = "Restaurant", sort: Int = 0, categories: [String]? = nil, deals: Bool? = nil, radius: Float? = nil) {
        
        var yelpSortMode: YelpSortMode?
        switch sort {
        case 0:
            yelpSortMode = YelpSortMode.bestMatched
        case 1:
            yelpSortMode = YelpSortMode.distance
        case 2:
            yelpSortMode = YelpSortMode.highestRated
        default:
            yelpSortMode = YelpSortMode.bestMatched
        }
        
        Business.search(with: searchString, sort: yelpSortMode, categories: categories, deals: deals, radius: radius, limit: limit, offset: offset) { (businesses, error) in
            if let businesses = businesses {
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                self.businesses = businesses
                self.tableView.reloadData()
                
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }

    }
}

extension BusinessesViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        loadMoreData(searchString: "\(searchBar.text)")
//        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
