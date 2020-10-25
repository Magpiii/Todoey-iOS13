//
//  Data.swift
//  Todoey
//
//  Created by Hunter Hudson on 10/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//
//Note: this file is just an example of how to initialize a Realm object (class). It is not
//actually used in the project. 


import Foundation
import RealmSwift

//Create new class Data that derives from Object (Realm data always derives from Object):
class Data: Object{
    /*Realm variables must be marked with @objc as they are coded in the objective-C language:
    */
    @objc dynamic var name: String = ""
    
    @objc dynamic var age: Int = 0
}
