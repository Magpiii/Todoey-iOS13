//
//  ListCat.swift
//  Todoey
//
//  Created by Hunter Hudson on 10/25/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class ListCat: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String?
    
    /*When using Realm, the List data type basically makes an array of whatever is in the "<>" block for you:
    */
    let items = List<ListItem>()
}
