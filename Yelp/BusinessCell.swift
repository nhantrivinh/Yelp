//
//  BusinessCell.swift
//  Yelp
//
//  Created by Jayven Nhan on 2/23/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var imgViewThumbnail: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgViewRatings: UIImageView!
    @IBOutlet weak var lblReviewsCount: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCategories: UILabel!
    
    var business: Business! {
        didSet {
            lblName.text = business.name
            imgViewThumbnail.setImageWith(business.imageURL!)
            lblCategories.text = business.categories
            lblAddress.text = business.address
            lblReviewsCount.text = "\(business.reviewCount!) Reviews"
            imgViewRatings.setImageWith(business.ratingImageURL!)
            lblDistance.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgViewThumbnail.layer.cornerRadius = 3
        imgViewThumbnail.clipsToBounds = true
//        lblName.preferredMaxLayoutWidth = lblName.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        lblName.preferredMaxLayoutWidth = lblName.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
