//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Hunter Hudson on 10/26/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

/* This class conforms to SwipeTableViewCellDelegate so it can be used as a superclass in the other ViewControllers:
*/
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*Creates a new tableView cell with the prototype identified from the DB for element item in itemArray (downcasts as SwipeTableViewCell using predefined subclass):
        */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //Sets the delegate of the cell to self:
        cell.delegate = self
        
        return cell
    }
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

                let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                    // handle action by updating model with deletion
                    self.updateModel(at: indexPath)
                    
                    //Prints to the console when this method is called:
                    print("Delete cell.")
                    
                    /*Deletes the data from realm if item is not nil:
                    if let cat = self.cats?[indexPath.row]{
                        do{
                            try self.realm.write{
                                self.realm.delete(cat)
                                }
                        } catch {
                            print("An error occurred while deleting data: \(error)")
                        }
                    }
                    */
                }
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }

                // customize the action appearance
                deleteAction.image = UIImage(named: "Trash Icon")

                return [deleteAction]
        }
        
        /*Allows far-right swipe to delete the cell without having to actually tap on the trash icon:
        */
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            
            options.expansionStyle = .destructive
            options.transitionStyle = .border
            
            return options
        }
    
    func updateModel(at indexPath: IndexPath){
        
    }
}
