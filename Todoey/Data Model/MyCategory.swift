//
//  MyCategory.swift
//  Todoey
//
//  Created by Taha Enes Aslantürk on 3.05.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class MyCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
