//
//  Data.swift
//  Todoey
//
//  Created by Taha Enes Aslantürk on 3.05.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
