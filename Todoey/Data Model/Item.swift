//
//  Item.swift
//  Todoey
//
//  Created by Taha Enes Aslantürk on 3.05.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: MyCategory.self, property: "items")
}
