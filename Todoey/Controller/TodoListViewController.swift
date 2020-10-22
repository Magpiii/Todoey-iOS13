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
    
    /*Creates a data file path to the documents directory of the device the app is running on; creates a new component file called "Items.plist" to store the itemArray property:
    */
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Creates a new array of ListItem objects:
    var itemArray = [ListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*Sets the tableView delegate as "self" since it's extended below:
        */
        tableView.delegate = self
        
        /*Example of how to assign and optionally-downcasts itemArray as whatever is in the defaults .plist as long as it's not nil. NOTE: do not actually do it this way. UserDefaults is not meant to be used as an actual database for data for the app, like how one would use a SQL database or Firebase:
        
        if let items = defaults.array(forKey: K.listArray) as? [ListItem]{
            itemArray = items
        }
        */
        
        //Makes sure the database is working on start:
        print(dataFilePath)
        
        let newItem = ListItem()
        newItem.title = "Make to-do list."
        itemArray.append(newItem)
        
        //Loads data from .plist on startup:
        loadData()
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
            
            //Appends new item to itemArray as textField:
            let newItem = ListItem()
            newItem.title = textField.text ?? ""
            self.itemArray.append(newItem)
            
            /*Saves user data in defaults with key "ToDoListArray":
            self.defaults.set(self.itemArray, forKey: K.listArray)
            */
            
            //Saves user data to a .plist:
            self.saveData()
            
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
        
        /*Creates item constant for the currently selected item in the tableView so I don't have to type "itemArray[indexPath.row]" so many goddamn times:
        */
        let item = itemArray[indexPath.row]
        
        //Sets textLabel of each new cell as the appropriate item in itemArray:
        cell.textLabel?.text = item.title
        
        /*How to set the accessory type using the ternary operator (value = condition ? valueIfTrue : valueIfFalse) (just like in C++). Very useful when working with booleans:
        */
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        /*Ternary operator basically does this, but shorter:
         
        //If the item is done...
        if (item.done == true){
            //...applies checkmark to list item:
            cell.accessoryType = .checkmark
        }
        //Else if it's not done...
        else{
            //Removes the accessory. 
            cell.accessoryType = .none
        }
        */
            
        return cell
        }
    }

//MARK: - TableView Delegate Methods:

//Extends ViewController to conform to UITableViewDelegate:
 
extension TodoListViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*Creates item constant for the currently selected item in the tableView so I don't have to type "indexPath.row" so many goddamn times:
        */
        let item = indexPath.row
        
        print(item)
    
        
        //Prints the content of the array element at the indexPath:
        print(itemArray[item])
        
        /*Adds checkmark to ToDoItemCell for the item that's currently selected using indexPath:
        */
        
        /*Sets the "done" boolean to the opposite of its current state, allowing the checkmark to either show or not show using the "done" boolean:
        */
        itemArray[item].done = !itemArray[item].done
         
        DispatchQueue.main.async {
            tableView.reloadData()
        }
        
        //Deselects tableView cell at IndexPath in animated fashion:
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Model Manipulation Methods:

    func saveData(){
        //Creates a new encoder:
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            /*Only force-unwrap your file path if you know it's correct (usually best to use Cosntants file/struct(s) here):
            */
            try data.write(to: dataFilePath!)
        } catch {
            //Error catch:
            print("Error encoding itemArray: \(error)")
        }
    }
    
    func loadData(){
        /*Creates data object (NOTE: only force unwrap if you know the dataFilePath exists (best to use constants file in this case)); using question mark "?" operator after "try" makes the value optional:
        */
        do{
            if let data = try? Data(contentsOf: dataFilePath!){
                //Initializes decoder if there are no errors using optional binding:
                let decoder = PropertyListDecoder()
                /*Sets itemArray equal to the decoded data from the decoder (NOTE: must specify the data type in method call because Swift can't interpret the data type from the database yet. Hopefully that'll be a feature in the future):
                */
                try itemArray = decoder.decode([ListItem].self, from: data)
            }
        } catch {
            print("Error loading data: \(error)")
        }
        
    }
    
}







