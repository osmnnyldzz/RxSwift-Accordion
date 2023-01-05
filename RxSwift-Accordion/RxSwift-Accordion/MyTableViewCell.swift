//
//  MyTableViewCell.swift
//  RxSwift-Accordion
//
//  Created by Osman Yıldız on 4.01.2023.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    static let identifier = "MyTableViewCell"

    @IBOutlet weak var arrowImage: UIImageView! {
        didSet {
            arrowImage.isHidden = true
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func extensileConfigurations(_ element: Categories) {
        self.arrowImageVisible(element.canExpand)
        
        if element.expand {
            self.arrowImage.image = UIImage(systemName: "chevron.up.circle.fill")
        } else {
            self.arrowImage.image = UIImage(systemName: "chevron.down.circle.fill")
        }
    }
    
    func arrowImageVisible(_ status: Bool) {
        arrowImage.isHidden = !status
    }

}
