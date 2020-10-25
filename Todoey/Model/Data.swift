//
//  Data.swift
//  Todoey
//
//  Created by Hunter Hudson on 10/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

//Create new class Data that derives from Object (Realm data always derives from object):
class Data: Object{
    /*Realm variables must be marked with @objc as they are coded in the objective-C language:
    */
    @objc dynamic var name: String = ""
    
    @objc dynamic var age: Int = 0
}
