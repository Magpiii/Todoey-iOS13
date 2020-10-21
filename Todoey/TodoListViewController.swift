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
    
    let itemArray = ["Text Condor", "Text Nicc", "Text Nolaaaaaaaan"]

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
        
        //Deselects tableView cell at IndexPath:
        tableView.deselectRow(at: indexPath, animated: true)
    }
}





