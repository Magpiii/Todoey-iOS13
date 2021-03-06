//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hunter Hudson on 10/22/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

//Must import Chameleon Framework to use it:
import ChameleonFramework

//The ViewController now inherits from the superclass for the swipable cells.
class CategoryViewController: SwipeTableViewController{
    
    /*Must initialize Realm in ViewController too, but can force the "try" using the "!" operator. This is because when initializing Realm for the first time on an app, it technically can fail if resources are constrained. However, since we already initialize Realm on the AppDelegate, there's no need to handle the error in the ViewController:
    */
    let realm = try! Realm()
    
    /*Initializes a context constant equal to the data obtained from the CoreData model by force-downcasting the UIApplication.shared (singleton) delegate as the AppDelegate.
    */
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Creates a new array of Category items from CoreData:
    var catArray = [Cat]()
    
    /*Creates new Results list (which is basically an array) of ListCat objects from Realm (NOTE: no need to "append" to a Results list because Realm does it for you automatically):
    */
    var cats: Results<ListCat>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Increases the height of the cell so the entire trash icon fits: 
        tableView.rowHeight = 80.0
        
        /*Removes the separator from the cells since the separator is pointless due to ChameleonFramework colors:
        */
        tableView.separatorStyle = .none
        
        /*Initializes tap as a gesture recognizer to close the keyboard if whitespace is tapped:
        */
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Loads data on view loading:
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller failed to load.") }
        
        //Sets the default backgroundColor to blue using hexidecimal code:
        navBar.backgroundColor = HexColor(hexString: "1D9BF6")
    }
    
    /*Causes the view (or one of its embedded text fields) to resign the first responder status and close the keyboard.
    */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Model Manipulation Methods:
    //Need to take in the ListCat so it can be saved to Realm:
    func saveData(with cat: ListCat){
        //Saves data to CoreData:
        do{
            try context.save()
        } catch {
            print("Error: \(error)")
        }
        
        //Saves data to Realm DB:
        do{
            try realm.write{
                //Saves the inputted category to Realm:
                realm.add(cat)
            }
        } catch {
            print("An error occurred while saving to Realm: \(error)")
        }
    }
    
    func loadData(with request: NSFetchRequest<Cat> = Cat.fetchRequest()){
        /*Creates a new request from CoreData using NSFetchRequest (data type is specified in the "<>" mainly for coder use, which is why it's important to specify the data type this way).
        */
        let request: NSFetchRequest<Cat> = Cat.fetchRequest()
        
        /*Uses the request constant to have the context fetch the data from CoreData and assign it to the catArray:
        */
        do{
            catArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        /*Sets a new cats constant equal to whatever is in Realm (NOTE: must use self in parameter that takes in Object type in Realm):
        */
        cats = realm.objects(ListCat.self)
    }
    
    //MARK: - Delete Data from Swipe:
    
    /*Overrides the superclass method updateModel() to delete data from Realm using the Swipe action:
    */
    override func updateModel(at indexPath: IndexPath){
        //Deletes the data from realm if item is not nil:
        if let catToBeDeleted = self.cats?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(catToBeDeleted)
                    }
            } catch {
                print("An error occurred while deleting data: \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories:
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        /*Creates new alert that prompts the user to type in a new to do list item:
        */
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            /*The following happens once the user taps the "Add Item" button on the alert
            */
            print("Processed successfully.")
            
            //Makes a new Cat as an Item from CoreData:
            let newCat = Cat(context: self.context)
            
            //Makes a new ListCat as a Realm object:
            let newRealmCat = ListCat()
            
            newCat.name = textField.text ?? ""
            newRealmCat.name = textField.text ?? ""
            
            //Sets the newRealmCat's color to a random UIColor from the Chameleon Framework:
            newRealmCat.color = UIColor.randomFlat()?.hexValue()
            
            //Appends newItem to the itemArray:
            self.catArray.append(newCat)
            
            /*Saves user data to a .plist:
            self.saveData()
            */
            
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
            alertTextField.placeholder = "New category"
            print(alertTextField.text ?? "\n")
            textField.text = alertTextField.text ?? ""
        }
        
        //Presents alert when the user presses the add button:
        present(alert, animated: true, completion: nil)
    }
    //Class closing brace:
}
    
    // MARK: - Table view data source
    extension CategoryViewController{
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            /*Returns the amount of categories in the catArray:
            return catArray.count
            */
            
            /*Can use the ".count" operator on Realm Objects, too (returns 1 if cats is nil):
            */
            return cats?.count ?? 1
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            /*Creates a new tableView cell with the prototype identified from the DB for element item in itemArray (downcasts as SwipeTableViewCell using predefined subclass):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.tableViewShit.catCellIdentifier, for: indexPath) as! SwipeTableViewCell
            */
            
            //Initializes tableView cells in this ViewController using superclass:
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
            //Sets the cell label as the selected indexPath for the appropriate category: 
            cell.textLabel?.text = cats?[indexPath.row].name ?? "Add a category to get started."
            
            /*Sets the backgroundColor of the textLabel as the contrasting color of the current category, else contrast-conforming white if nil (NOTE: nil coalescing a default hex color if it's nil is not actually a good way to do this. This is just an example of how to do so):
            */
            cell.textLabel?.backgroundColor = ContrastColorOf(backgroundColor: HexColor(hexString: cats?[indexPath.row].color ?? "FFFFFF"), returnFlat: true)
            
            //Sets the cell color to the stored color, or white if it's nil:
            cell.backgroundColor = HexColor(hexString: cats?[indexPath.row].color ?? "FFFFFF")
            
            
            /*Sets the cell delegate to self in order to use SwipeCellKit:
            cell.delegate = self
            */
            
            return cell
        }
    
    /*The following is example code to help understand how UITableViews work:
         
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
    
    //MARK: - TableView Delegate Methods:
extension CategoryViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*Takes the user to the list for the particular category using a segue with sender "self" (self becomes the IBAction):
        */
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //Goes to the list related to the category that is selected (in CoreData):
        if let indexPath = tableView.indexPathForSelectedRow{
            /*Makes the TodoListViewController go to the list related to the appropriate category in the array of categories:
            
            destinationVC.selectedCat = catArray[indexPath.row]
            */
            
            destinationVC.selectedCat = cats?[indexPath.row]
        }
    }
}
