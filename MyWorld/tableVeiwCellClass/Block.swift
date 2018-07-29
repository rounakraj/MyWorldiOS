//
//  Block.swift
//  MyWorld
//
//  Created by mac on 28/07/18.
//  Copyright © 2018 MyWorld. All rights reserved.
//

import UIKit

class Block: UITableViewCell {

    @IBOutlet weak var blockUserImage: UIImageView!
    
    @IBOutlet weak var btnUnblock: UIButton!
    @IBOutlet weak var blockUserStutas: UILabel!
    @IBOutlet weak var blockUserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
