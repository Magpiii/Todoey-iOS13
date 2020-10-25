//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

//Must import CoreData to use it:
import CoreData

/*Change superclass to UITableViewController since that's what the view is. Also, no need for IBOutlets if you make the View Controller a subclass of the TableViewController (also conforms to UISearchBarDelegate since there's a search bar):
*/
class TodoListViewController: UITableViewController {
    
    //Initializes user defaults:
    let defaults = UserDefaults.standard
    
    /*Creates a data file path to the documents directory of the device the app is running on; creates a new component file called "Items.plist" to store the itemArray property:
    */
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Creates optional variable for selected category in the CategoryView:
    var selectedCat: Cat?{
        /*"didSet" operator only gets executed once the computed property is in fact set with a value:
        */
        didSet{
            //Loads data as soon as selectedCat is assigned a value:
            loadData()
        }
    }
    
    /*Initializes a context constant equal to the data obtained from the CoreData model by force-downcasting the UIApplication.shared (singleton) delegate as the AppDelegate.
    */
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Creates a new array of Item objects from CoreData:
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*Initializes tap as a gesture recognizer to close the keyboard if whitespace is tapped:
        */
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
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
        
        //Initializes new item with context of the context constant above.
        let newItem = Item(context: context)
        newItem.title = "Make to-do list."
        
        //Sets the parentCat property of the newItem to the global selectedCat variable:
        newItem.parentCat = self.selectedCat
        
        itemArray.append(newItem)
    }
    
    /*Causes the view (or one of its embedded text fields) to resign the first responder status and close the keyboard.
    */
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
            
            //Makes a new item as an Item from CoreData:
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text ?? ""
            
            //Sets the "done" Bool to false by default so it isn't checked:
            newItem.done = false
            
            //Appends newItem to the itemArray:
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
    


//MARK: - Model Manipulation Methods:

func saveData(){
    //Creates a new encoder:
    let encoder = PropertyListEncoder()
    do{
        /*
        let data = try encoder.encode(itemArray)
        Only force-unwrap your file path if you know it's correct (usually best to use Cosntants file/struct(s) here):
        
        try data.write(to: dataFilePath!)
        */
        try context.save()
    } catch {
        //Error catch:
        print("Error saving data: \(error)")
    }
}
    
    /*Using "=" provides a default input value for a function that takes inputs (function takes in NSPredicate as well, allowing the use of multiple predicate per file with nil default value; NSPredicate must be optional in order to be assigned nil value):
    */
func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
    /*The folowing example is how to save data using a .plist:
    
    /*Creates data object (NOTE: only force unwrap if you know the dataFilePath exists (best to use constants file in this case)); using question mark "?" operator after "try" makes the value optional:
    */
    do{
        /*
        if let data = try? Data(contentsOf: dataFilePath!){
            //Initializes decoder if there are no errors using optional binding:
            let decoder = PropertyListDecoder()
            /*Sets itemArray equal to the decoded data from the decoder (NOTE: must specify the data type in method call because Swift can't interpret the data type from the database yet. Hopefully that'll be a feature in the future):
            */
         */
            try context.save()
        } catch {
        print("Error loading data: \(error)")
    }
}
    */
    
    /*Creates a new search query for the parentcategory that exactly matches the string of the selected category (NOTE: MATCHES does not include [cd] in this case because it wouldn't need ignore case or diacritics for the variable anyway):
    */
    let catPredicate = NSPredicate(format: "parentCat.name MATCHES %@", selectedCat!.name!)
    
    //Optionally binds additionalPredicate to inputted predicate if it's not nil:
    if let additionalPredicate = predicate{
        /*Sets the search query equal to a compound predicate of the inputted predicate as well as the category so both can be searched in CoreData simultaneously:
        */
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate, additionalPredicate])
    }
    //Else if it is nil...
    else{
        request.predicate = catPredicate
    }
        
    /*Creates a new request from CoreData using NSFetchRequest (data type is specified in the "<>" mainly for coder use, which is why it's important to specify the data type this way).
    */
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    /*Uses the request constant to have the context fetch the data from CoreData and assign it to the itemArray:
    */
    do{
        itemArray = try context.fetch(request)
    } catch {
        print("Error fetching data from context: \(error)")
    }
}
}

//MARK: - TableView Datasource Methods:

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Returns the amount of items in the itemArray:
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
        
        /*Sets the title of the todo list item to "Completed" when the user taps on the item:
        */
        itemArray[item].setValue("Completed", forKey: "title")
        
        print(item)
        
        //Prints the content of the array element at the indexPath:
        print(itemArray[item])
        
        /*Adds checkmark to ToDoItemCell for the item that's currently selected using indexPath:
        */
        
        /*Sets the "done" boolean to the opposite of its current state, allowing the checkmark to either show or not show using the "done" boolean:
        */
        itemArray[item].done = !itemArray[item].done
        
        /*IMPORTANT NOTE: The following is an example of how to delete items from a CoreData database. The next 2 lines of code must be in order. Always operate on database objects before local objects:
        
        
        //Deletes the item from the CoreData using "delete" predefined method of context:
        context.delete(itemArray[item])
        
        //Removes the tapped item from itemArray at the index indexPath.row:
        itemArray.remove(at: item)
        */
        
        //Saves data to CoreData:
        saveData()
         
        DispatchQueue.main.async {
            tableView.reloadData()
        }
        
        //Deselects tableView cell at IndexPath in animated fashion:
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Search Bar Delegate Methods:

    extension TodoListViewController: UISearchBarDelegate{
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            //Creates request from the CoreData for entity "Item":
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            /*Creates predicate for CoreData database search ("%@" escape sequence is replaced by whatever is in the searchBar "searchBar.text!" and CONTAINS operator is placed after the key so that the value can be found if it matches the query). The "[cd]" tells the query to ignore case and diacritics (diacritics is basically stuff like á and é) similarly to .toUpper() and .toLower() in C#:
            */
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            /*Sets the request's predicate (query) equal to the predicate constant that I just made:
            */
            request.predicate = predicate
            
            /*Since sortDescriptors is an array type (since you can technically search based on multiple criteria) the sortDescriptor for the key "title" (sorts by alphabetical order with the input "ascending: true.") is the only item in the array:
            */
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            //Fetches the itemArray from the CoreData database with the input "request":
            loadData(with: request, predicate: predicate)
            
            //Need to reload the tableView again since it'll have new data:
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            
            print(searchBar.text ?? "")
        }
        
        /*This function resets the array to its previous state when the "x" button is pressed on the searchBar:
        */
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
            /*If there are no characters in the searchBar (which would only happen if the user didn't type anything, the user pushed the "x" button, or the user deleted all the text)...
            */
            if (searchBar.text?.count == 0){
                //Loads the data, which now has no query, so the original data is loaded:
                loadData()
                
                /*Puts the keyboard away once the user taps the "x" on the searchBar or deletes all the text (need DispatchQueue since it's a UI foreground operation):
                */
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
    





