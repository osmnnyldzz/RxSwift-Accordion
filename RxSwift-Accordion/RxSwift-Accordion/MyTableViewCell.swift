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
    
    @IBOutlet weak var cellLeadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func extensileConfigurations(_ element: Categories) {
        self.arrowImageVisible(element.canExpand)
        
        if element.expanded {
            self.arrowImage.image = UIImage(systemName: "arrowtriangle.up.fill")
        } else {
            self.arrowImage.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
    }
    
    func arrowImageVisible(_ status: Bool) {
        arrowImage.isHidden = !status
    }
    
    func setBackgroundColor(_ element: Categories) {
        let color = UIColor(r: CGFloat(40 * element.level), g: CGFloat(10 * element.level), b: CGFloat(10 * element.level))
        self.backgroundColor = color
    }

}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
