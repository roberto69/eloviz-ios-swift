//
//  StreamsCellViewCollectionViewCell.swift
//  Eloviz
//
//  Created by guillaume labbe on 11/12/15.
//  Copyright © 2015 guillaume labbe. All rights reserved.
//

import UIKit

class StreamsCellView: UICollectionViewCell {

    @IBOutlet weak var streamImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}
