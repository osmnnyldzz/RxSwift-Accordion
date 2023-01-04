//
//  ViewController.swift
//  RxSwift-Accordion
//
//  Created by Osman Yıldız on 3.01.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private let dummyArray = ["Lorem","Lorem","Lorem"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Observable.of(self.dummyArray).asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: MyTableViewCell.identifier, cellType: MyTableViewCell.self))
            { index, element, cell in
                
            cell.titleLabel.text = element
                
        }.disposed(by: disposeBag)
        
    }
}

