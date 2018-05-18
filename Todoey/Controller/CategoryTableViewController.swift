//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Bryan Rollins on 4/20/18.
//  Copyright © 2018 BryanSoftware. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class CategoryTableViewController: UITableViewController { 

    let realm = try! Realm()
    var categories: Results<Category>?
    // var categoryArray = [Category]()
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        // let newCategory = Category(context: context)
        // newCategory.name = "Shopping"
        // categoryArray.append(newCategory)
    }
    
    
    //MARK: - Add new categories
    @IBAction func addCategoryButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let addCategoryAction = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            if let tempCategoryName = textField.text {
                // let newCategory = Category(context: self.context)
                let newCategory = Category()
                newCategory.name = tempCategoryName
                
                // self.categoryArray.append(newCategory)
                self.saveData(category: newCategory)
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category?"
            textField = alertTextField
        }
        
        alert.addAction(addCategoryAction)
        present(alert, animated: true, completion: nil)
    }
}


//MARK: - TableView Datasource Methods
extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!"
        
        return cell
    }
}


//MARK: - TableView Delegate Methods
extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
}


//MARK: - Data Manipulation Methods
extension CategoryTableViewController {
    
    func saveData(category: Category) {
        do {
//            if context.hasChanges {
//                try context.save()
//            }
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving categories: \(error)")
        }
    }
    
    
    func loadData() {
        categories = realm.objects(Category.self)   // pulls out all the objcts in the Realm that are of type Category object
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("error loading categories: \(error)")
//        }
    }
}



