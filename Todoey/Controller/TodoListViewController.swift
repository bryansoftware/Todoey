//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Bryan Rollins on 4/7/18.
//  Copyright © 2018 BryanSoftware. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    // let defaults = UserDefaults.standard
    // let DEFAULTS_KEY = "TodoListArray"
    
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        // if let tempArray = defaults.array(forKey: DEFAULTS_KEY) as? [Item] {
        //      itemArray = tempArray
        // }
    }
    

    //MARK: - Add new items
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user taps Add Item button on UIAlert
            if let tempText = textField.text {
                
                let newItem = Item(context: self.context)
                
                newItem.title = tempText
                newItem.isComplete = false
                newItem.parentCategory = self.selectedCategory
                
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
    
    
    // Codable version of saveData()
    // func saveData() {
    //      let encoder = PropertyListEncoder()
    
    //      do {
    //          let data = try encoder.encode(itemArray)
    //          try data.write(to: self.dataFilePath!)
    //      } catch {
    //          print("error encoding array: \(error)")
    //      }
    // }
    
    
    // Codable version of loadData()
    // func loadData() {
    //     if let data = try? Data(contentsOf: dataFilePath!) {
    //         let decoder = PropertyListDecoder()
    //
    //         do {
    //             itemArray = try decoder.decode([Item].self, from: data)
    //         } catch {
    //             print("error reading data: \(error)")
    //         }
    //     }
    // }
    
}


//MARK: - Tableview delegate methods
extension TodoListViewController {
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
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        saveData()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Search bar delegate methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            // add a predicate (i.e. what to search for) and a sortDescriptors (i.e. how to sort our query results) to our request
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadData(with: request, searchingFor: predicate)
        }
        tableView.reloadData()
    }
}


extension TodoListViewController {
    func saveData() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("error saving context: \(error)")
        }
    }
    
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), searchingFor predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let tempPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, tempPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching date from context: /(error)")
        }
    }
}




