//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hunter Hudson on 10/22/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    /*Initializes a context constant equal to the data obtained from the CoreData model by force-downcasting the UIApplication.shared (singleton) delegate as the AppDelegate.
    */
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Creates a new array of Category items from CoreData:
    var catArray = [Cat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Initializes tap as a gesture recognizer to close the keyboard if whitespace is tapped:
        */
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    /*Causes the view (or one of its embedded text fields) to resign the first responder status and close the keyboard.
    */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Model Manipulation Methods:
    func saveData(){
        do{
            try context.save()
        } catch {
            print("Error: \(error)")
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
            
            newCat.name = textField.text ?? ""
            
            //Appends newItem to the itemArray:
            self.catArray.append(newCat)
            
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
            //Returns the amount of categories in the catArray: 
            return catArray.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            /*Creates a new tableView cell with the prototype identified from the Constants file for element item in itemArray:
            */
            let cell = tableView.dequeueReusableCell(withIdentifier: K.tableViewShit.catCellIdentifier, for: indexPath)
            
            /*Creates item constant for the currently selected item in the tableView so I don't have to type "itemArray[indexPath.row]" so many goddamn times:
            */
            let cat = catArray[indexPath.row]
            
            //Sets textLabel of each new cell as the appropriate item in itemArray:
            cell.textLabel?.text = cat.name
            
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
    
