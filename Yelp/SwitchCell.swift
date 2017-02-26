//
//  SwitchCell.swift
//  Yelp
//
//  Created by Jayven Nhan on 2/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var lblSwitch: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged(_:)), for: .valueChanged)
        
    }

    func switchValueChanged(_ sender: UISwitch) {
        print("Switch value changed")
        delegate?.switchCell?(switchCell: self, didChangeValue: sender.isOn)
    }
    
    

}
