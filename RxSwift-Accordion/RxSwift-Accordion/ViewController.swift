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
    
    private let indentation = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.categories.accept(self.createDummyCategories())
        
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
                cell.cellLeadingConstraint.constant = CGFloat(element.level * self.indentation)
                
        }.disposed(by: disposeBag)
    }
    
    private func cellTapHandle() {
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(Categories.self)
        ).subscribe(onNext: { indexPath, category in
                
            if category.canExpand {
                self.categories.value.forEach { tempCategory in
                    if tempCategory.categoryId == category.categoryId {
                        if tempCategory.expanded {
                            self.collapse(tempCategory, index: indexPath.row)
                        } else {
                            self.expand(tempCategory, index: indexPath.row)
                        }
                    }
                }
            }

                            
            }).disposed(by: disposeBag)
        
    }
    
    private func createDummyCategories() -> [Categories] {
        var dummyCategories:[Categories] = []
        
        for category in 0...4 {
            
            let dummyCategory = Categories(categoryId: .random(in: 0...10000),
                                           categoryName: "Category \(category)",
                                           expanded: false,
                                           level: 0,
                                           canExpand: category % 2 == 0 ? true : false,
                                           children: [])
            dummyCategories.append(dummyCategory)
        }
        
        return dummyCategories
    }
    
    private func createChildDummyCategories(_ parentCategory: Categories) {
        for category in 0...4 {
            
            let dummyCategory = Categories(categoryId: .random(in: 0...10000),
                                           categoryName: "Category \(parentCategory.level)",
                                           expanded: false,
                                           level: parentCategory.level + 1,
                                           canExpand: category % 2 == 0 ? true : false,
                                           children: [])
            parentCategory.children.append(dummyCategory)
        }
    }
    
    private func removeChildDummyCategories(_ parentCategory: Categories) {
        parentCategory.children.removeAll()
    }
    
    private func expand(_ category: Categories, index:Int) {
        self.createChildDummyCategories(category)
        
        category.expanded = true
        var tempCategories = self.categories.value
        tempCategories.insert(contentsOf: category.children, at: index + 1)

        self.categories.accept(tempCategories)
    }
    
    private func collapse(_ category: Categories, index:Int) {
        let count = numberOfChildDummyCategory(category)
        self.removeChildDummyCategories(category)

        var tempCategories = self.categories.value

        tempCategories.removeSubrange((index+1)...(index+count))

        self.categories.accept(tempCategories)
    }
    
    private func numberOfChildDummyCategory(_ category: Categories) -> Int {
        var totalCount = 0
        
        if category.expanded {
            category.expanded = false

            totalCount = category.children.count
            category.children.forEach { child in
                totalCount += numberOfChildDummyCategory(child)
            }
        }
        return totalCount
    }
}

class Categories {
    var categoryId:Int
    var categoryName:String
    var expanded:Bool
    var level:Int
    var canExpand:Bool
    var children:[Categories]
    
    init(categoryId: Int, categoryName: String, expanded: Bool, level: Int, canExpand: Bool, children: [Categories]) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.expanded = expanded
        self.level = level
        self.canExpand = canExpand
        self.children = children
    }
}

