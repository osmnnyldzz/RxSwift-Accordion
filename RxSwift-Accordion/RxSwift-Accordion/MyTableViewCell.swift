//
//  MyTableViewCell.swift
//  RxSwift-Accordion
//
//  Created by Osman Yıldız on 4.01.2023.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    static let identifier = "MyTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
