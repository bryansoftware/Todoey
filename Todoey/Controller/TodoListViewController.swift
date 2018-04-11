//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Bryan Rollins on 4/7/18.
//  Copyright © 2018 BryanSoftware. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    // let defaults = UserDefaults.standard
    // let DEFAULTS_KEY = "TodoListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // if let tempArray = defaults.array(forKey: DEFAULTS_KEY) as? [Item] {
        //      itemArray = tempArray
        // }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].isComplete ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        saveData()

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK: - Add new items
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user taps Add Item button on UIAlert
            if let tempText = textField.text {
                let newItem = Item()
                newItem.title = tempText
                
                self.itemArray.append(newItem)
                // self.defaults.set(self.itemArray, forKey: self.DEFAULTS_KEY)  // save the user's new item into UserDefaults
                
                self.saveData()
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item?"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("error encoding array: \(error)")
        }
    }
    
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error reading data: \(error)")
            }
        }
    }
    
}

