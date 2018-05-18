//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Bryan Rollins on 4/7/18.
//  Copyright © 2018 BryanSoftware. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class TodoListViewController: UITableViewController {

    // let defaults = UserDefaults.standard
    // let DEFAULTS_KEY = "TodoListArray"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    // var itemArray = [Item]()
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
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
                    
//                let newItem = Item(context: self.context)
                
                // the category must exist to add an item to the category (selectedCategory is an optional)
                if let tempSelectedCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = tempText
                            newItem.dateCreated = Date()
                            print("### DATE CREATED: \(newItem.dateCreated) ###")
                            tempSelectedCategory.items.append(newItem)  // append the newItem to the Category's items[]
                        }
                    } catch {
                        print("error saving new todo item: \(error)")
                    }
                }
                
//                self.itemArray.append(newItem)
                // self.defaults.set(self.itemArray, forKey: self.DEFAULTS_KEY)  // save the user's new item into UserDefaults
                
                // self.saveData()
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
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isComplete ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Todo Items Added Yet!"
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isComplete = !item.isComplete
                    // realm.delete(item)
                }
            } catch {
                print("error updating .isComplete on item: \(error)")
            }
        }
        
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        // todoItems[indexPath.row].isComplete = !todoItems[indexPath.row].isComplete
        // saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}


// MARK: - Search bar delegate methods
extension TodoListViewController: UISearchBarDelegate {
    
    // when the user actually taps on the magnifying glass/search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    
    // tracks when text has been entered/changed in the searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//            // add a predicate (i.e. what to search for) and sortDescriptors (i.e. how to sort our query results) to our request
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadData(with: request, searchingFor: predicate)
        }
        tableView.reloadData()
    }
}


// MARK: - Save/Load Data methods
extension TodoListViewController {
//    func saveData() {
//        do {
//            if context.hasChanges {
//                try context.save()
//            }
//        } catch {
//            print("error saving context: \(error)")
//        }
//    }
    
    func loadData() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    // CoreData loadData() method
//    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), searchingFor predicate: NSPredicate? = nil) {
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        
//        if let tempPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, tempPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("error fetching date from context: /(error)")
//        }
//    }
}




