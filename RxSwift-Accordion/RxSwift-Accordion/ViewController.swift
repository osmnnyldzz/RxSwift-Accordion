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
    
    private let categories: BehaviorRelay<[Categories]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.createDummyCategories()
        self.bindTableView()
        self.cellTapHandle()
        
    }
    
    private func bindTableView() {
        self.categories.asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: MyTableViewCell.identifier, cellType: MyTableViewCell.self))
            { index, element, cell in
                
                cell.titleLabel.text = element.categoryName
                cell.extensileConfigurations(element)

        }.disposed(by: disposeBag)
    }
    
    private func cellTapHandle() {
        self.tableView
            .rx
            .modelSelected(Categories.self)
            .subscribe(onNext:  { category in
                
                self.categories.value.forEach { tempCategory in
                    if tempCategory.categoryName == category.categoryName {
                        tempCategory.expand = !tempCategory.expand
                    } else {
                        tempCategory.expand = false
                    }
                }
                
                self.categories.accept(self.categories.value)
                
            }).disposed(by: disposeBag)
        
    }
    
    private func createDummyCategories() {
        var dummyCategories:[Categories] = []
        
        for category in 0...10 {
            let dummyCategory = Categories(categoryName: "Category \(category)",
                                           expand: false,
                                           level: 0,
                                           canExpand:  category % 2 == 0 ? true : false,
                                           children: [])
            dummyCategories.append(dummyCategory)
            self.categories.accept(dummyCategories)
        }
    }
}

class Categories {
    var categoryName:String
    var expand:Bool
    var level:Int
    var canExpand:Bool
    var children:[Categories]
    
    init(categoryName: String, expand: Bool, level: Int, canExpand: Bool, children: [Categories]) {
        self.categoryName = categoryName
        self.expand = expand
        self.level = level
        self.canExpand = canExpand
        self.children = children
    }
}

