//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

/*Change superclass to UITableViewController since that's what the view is. Also, no need for IBOutlets if you make the View Controller a subclass of the TableViewController:
*/
class TodoListViewController: UITableViewController {
    
    //Initializes user defaults:
    let defaults = UserDefaults.standard
    
    var itemArray = ["Text Condor", "Text Nicc", "Text Nolaaaaaaaan"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*Sets the tableView delegate as "self" since it's extended below:
        */
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated. 
    }
    
    //MARK: - Add New Item to List:
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        /*Creates new alert that prompts the user to type in a new to do list item:
        */
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            /*The following happens once the user clicks the "Add Item" button on the alert:
            */
            print("Processed successfully.")
            
            //Appends new item to itemArray as enteredText:
            self.itemArray.append(textField.text ?? "")
            
            //Saves user data in defaults with key "ToDoListArray":
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            //Reloads the data after the new item is added:
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        //Adds the action to the alert:
        alert.addAction(action)
        
        /*Adds a textField to the alert so the user can enter text to add to the todo list:
        */
        alert.addTextField { (alertTextField) in
            /*Sets the placeholder (grayed out) text to "New item":
            */
            textField = alertTextField
            alertTextField.placeholder = "New item"
            print(alertTextField.text ?? "\n")
            textField.text = alertTextField.text ?? ""
        }
        
        //Presents alert when the user presses the add button:
        present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK: - TableView Datasource Methods:

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*Returns the amount of items in the itemArray (this allows the code to load new messages being sent/received):
        */
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*Creates a new tableView cell with the prototype identified from the Constants file for element item in itemArray:
        */
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableViewShit.cellIdentifier, for: indexPath)
        
        //Sets textLabel of each new cell as the appropriate item in itemArray:
        cell.textLabel?.text = itemArray[indexPath.row]
            
        return cell
        }
    }

//MARK: - TableView Delegate Methods:

//Extends ViewController to conform to UITableViewDelegate:
 
extension TodoListViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        //Prints the content of the array element at the indexPath:
        print(itemArray[indexPath.row])
        
        /*Adds checkmark to ToDoItemCell for the item that's currently selected using indexPath:
        */
        
        //If it already has a checkmark...
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            //...remove the checkmark:
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        //else if it doesn't...
        else{
            //...add the checkmark:
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //Deselects tableView cell at IndexPath in animated fashion:
        tableView.deselectRow(at: indexPath, animated: true)
    }
}





