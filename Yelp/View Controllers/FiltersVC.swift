//
//  FiltersVC.swift
//  Yelp
//
//  Created by Jayven Nhan on 2/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FiltersVCDelegate {
    @objc optional func filtersVC(filterVC: FiltersVC, didUpdateFilters filters: [String: AnyObject])
}

class FiltersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories:[[String: String]]!
    var switchStates = [Int: Bool]()
    var filterCategories = ["Categories", "Sort", "Distance", "Deals"]
    weak var delegate: FiltersVCDelegate?
    var showMorePressed = false
    var sortPressed = false
    var sortTypes: [Int: String] = [0: "Best matched", 1: "Distance", 2: "Highest Rated"]
    var chosenSort = 0
    var dealsOn = false
    var showMoreSort = false
    
    var distanceOptions: [Float] = [1, 1000, 3000, 5000]
    var chosenDistance: Float = 1000.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = yelpCategories
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func btnCancelDidTouch(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSearchDidTouch(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        if chosenSort == 1 {
            filters["radius_filter"] = chosenDistance as AnyObject?
        }
        filters["sort"] = chosenSort as AnyObject?
        filters["deals_filter"] = dealsOn as AnyObject?
        
        print(filters)
        
        delegate?.filtersVC?(filterVC: self, didUpdateFilters: filters)
    }
}

extension FiltersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterCategories[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if !showMorePressed {
                return 4
            }
            return categories.count
        case 1:
            if showMoreSort {
                return sortTypes.count
            }
            return 1
        case 2:
            return distanceOptions.count
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let lblHeader = UILabel(frame: CGRect(x: 15, y: 13, width: tableView.bounds.size.width - 10, height: 24))
        lblHeader.text = filterCategories[section]
        lblHeader.font = UIFont.boldSystemFont(ofSize: 16)
        header.backgroundColor = UIColor.clear
        header.addSubview(lblHeader)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
        case 0:
            if !showMorePressed {
                if row == 3 {
                    let showMoreCell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreCell", for: indexPath) as! ShowMoreCell
                    return showMoreCell
                }
                
                let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                switchCell.lblSwitch.text = categories[indexPath.row]["name"]
                switchCell.delegate = self
                switchCell.onSwitch.isOn = switchStates[indexPath.row] ?? false
                return switchCell
            }
            
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            switchCell.lblSwitch.text = categories[row]["name"]
            switchCell.delegate = self
            switchCell.onSwitch.isOn = switchStates[row] ?? false
            return switchCell
        case 1:
            if showMoreSort {
                let sortCell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortCell
                let title = sortTypes[row]
                sortCell.lblTitle.text = title
                sortCell.imgViewSuccess.isHidden = true
                if chosenSort == row {
                    sortCell.imgViewSuccess.isHidden = false
                }
                return sortCell
            }
            
            let expandCell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell", for: indexPath) as! ExpandCell
            let title = sortTypes[chosenSort]!
            expandCell.lblTitle.text = "\(title)"
            return expandCell
            
        case 2:
            let sortCell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortCell
            let distance = distanceOptions[row]
            sortCell.lblTitle.text = "\(distance) m"
            sortCell.imgViewSuccess.isHidden = true
            if distance == chosenDistance {
                sortCell.imgViewSuccess.isHidden = false
            }
            return sortCell
        case 3:
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            switchCell.lblSwitch.text = "Deals"
            switchCell.onSwitch.isOn = dealsOn
            return switchCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        switch section {
        case 0:
            if !showMorePressed, row == 3{
                print("Show More Pressed")
                self.showMorePressed = true
                tableView.reloadSections([section], with: .automatic)
            }
        case 1:
//            self.chosenSort = nil
            if showMoreSort {
                chosenSort = row
                self.showMoreSort = false
            } else {
                self.showMoreSort = true
            }
            tableView.reloadSections([section], with: .automatic)
        case 2:
            self.chosenDistance = distanceOptions[row]
            tableView.reloadSections([section], with: .automatic)
        case 3:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            return 80
        case 2:
            return 80
        default:
            return  80
        }
    }
}

extension FiltersVC: SwitchCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        if switchCell.lblSwitch.text == "Deals" {
            print("Deals in \(value)")
            dealsOn = value
        } else {
            let indexPath = tableView.indexPath(for: switchCell)!
            switchStates[indexPath.row] = value
        }
    }
}
