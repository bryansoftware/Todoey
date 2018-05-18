//
//  Category.swift
//  Todoey
//
//  Created by Bryan Rollins on 5/14/18.
//  Copyright © 2018 BryanSoftware. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
