//
//  MyCell.swift
//  横向tableview
//
//  Created by liuweizhen on 2020/5/16.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
