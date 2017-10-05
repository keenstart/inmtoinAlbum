//
//  TableCell.swift
//  Album
//
//  Created by Gareth Harris on 10/4/17.
//  Copyright © 2017 Gareth Harris. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var tableCollection: UICollectionView!
    @IBOutlet weak var albumName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
