//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Bryan Rollins on 4/20/18.
//  Copyright © 2018 BryanSoftware. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController { 

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // let newCategory = Category(context: context)
        // newCategory.name = "Shopping"
        // categoryArray.append(newCategory)
    }
    
    
    //MARK: - Add new categories
    @IBAction func addCategoryButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Cateogry", message: "", preferredStyle: .alert)
        
        let addCategoryAction = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            if let tempCategoryName = textField.text {
                let newCategory = Category(context: self.context)
                newCategory.name = tempCategoryName
                
                self.categoryArray.append(newCategory)
                self.saveData()
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
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
}


//MARK: - Data Manipulation Methods
extension CategoryTableViewController {
    
    func saveData() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("error saving categories: \(error)")
        }
    }
    
    
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error loading categories: \(error)")
        }
    }
}



