//
//  Item.swift
//  Todoey
//
//  Created by Bryan Rollins on 5/14/18.
//  Copyright © 2018 BryanSoftware. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var isComplete: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
