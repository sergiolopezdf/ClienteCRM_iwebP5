//
//  VisitsTableViewCell.swift
//  CRMClient
//
//  Created by Sergio López on 26/11/2017.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit

class VisitsTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var subText: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var infoExtra1: UILabel!
    @IBOutlet var infoExtra2: UILabel!
    @IBOutlet var id: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
