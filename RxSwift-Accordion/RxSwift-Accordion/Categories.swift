//
//  Categories.swift
//  RxSwift-Accordion
//
//  Created by Osman Yıldız on 6.01.2023.
//

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
