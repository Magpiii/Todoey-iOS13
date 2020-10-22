//
//  ListItem.swift
//  Todoey
//
//  Created by Hunter Hudson on 10/21/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

/*Creates a data type for each item in the list (conforms to Codable so it can be coded and decoded into the database). REMEMBER: in order to conform to Codable (or Encodable or Decodable), all properties must be standard data types (i.e. Int and String) and not custom data types that you, the coder, made up:
*/
class ListItem: Codable{
    var title: String = ""
    var done: Bool = false
}
