//
//  SortCell.swift
//  Yelp
//
//  Created by Jayven Nhan on 2/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

class SortCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewSuccess: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
