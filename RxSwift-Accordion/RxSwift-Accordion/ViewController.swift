//
//  ViewController.swift
//  RxSwift-Accordion
//
//  Created by Osman Yıldız on 3.01.2023.
//

import UIKit
import RxSwift
import RxCocoa

enum Extensile {
    case collapse
    case expand
    case none
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private let categories      : BehaviorRelay<[Categories]>      = BehaviorRelay(value: [])
    private let selectedCategory: BehaviorRelay<[Int: Categories]> = BehaviorRelay(value: [:])
    private let cellStatus      : BehaviorRelay<Extensile>         = BehaviorRelay(value: .none)
    
    private let indentation = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.categories.accept(self.createDummyCategories())
        
        self.bindTableView()
        self.cellClickSubscribe()
        self.cellStatusSubscribe()
    }
    
    private func bindTableView() {
        self.categories.asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: MyTableViewCell.identifier, cellType: MyTableViewCell.self))
        { index, element, cell in
            
            cell.titleLabel.text = element.categoryName
            cell.extensileConfigurations(element)
            cell.cellLeadingConstraint.constant = CGFloat(element.level * self.indentation)
            cell.setBackgroundColor(element)

        }.disposed(by: disposeBag)
    }
    
    private func cellClickSubscribe() {
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(Categories.self)
        ).subscribe(onNext: { indexPath, category in
            
            if category.canExpand {
                self.selectedCategory.accept([indexPath.row : category])
                
                if category.expanded {
                    self.cellStatus.accept(.collapse)
                } else {
                    self.cellStatus.accept(.expand)
                }
            }
            
        })
        .disposed(by: disposeBag)
        
    }
    
    private func cellStatusSubscribe() {
        self.cellStatus.asObservable().subscribe { extensile in
            guard let index = self.selectedCategory.value.first?.key else { return }
            guard let category = self.selectedCategory.value.first?.value else { return }
            
            switch extensile.element {
                
            case .expand:
                self.createChildDummyCategories(category)
                
                category.expanded = true
                var tempCategories = self.categories.value

                tempCategories.insert(contentsOf: category.children, at: index + 1)
                
                self.categories.accept(tempCategories)
                
            case .collapse:
                
                let count = self.numberOfChildDummyCategory(category)
                category.children.removeAll()
                
                var tempCategories = self.categories.value
                
                tempCategories.removeSubrange((index+1)...(index+count))
                
                self.categories.accept(tempCategories)
                
            default:
                return
                
            }
            
        }.disposed(by: self.disposeBag)
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

extension ViewController {
    private func createDummyCategories() -> [Categories] {
        var dummyCategories:[Categories] = []
        
        for category in 0...4 {
            
            let dummyCategory = Categories(categoryId: .random(in: 0...10000),
                                           categoryName: "Category \(category)",
                                           expanded: false,
                                           level: 1,
                                           canExpand: category % 2 == 0 ? true : false,
                                           children: [])
            dummyCategories.append(dummyCategory)
        }
        
        return dummyCategories
    }
    
    private func createChildDummyCategories(_ parentCategory: Categories) {
        for category in 0...4 {
            
            let dummyCategory = Categories(categoryId: .random(in: 0...10000),
                                           categoryName: "Child Category \(parentCategory.level)",
                                           expanded: false,
                                           level: parentCategory.level + 1,
                                           canExpand: category % 2 == 0 ? true : false,
                                           children: [])
            parentCategory.children.append(dummyCategory)
        }
    }
}

