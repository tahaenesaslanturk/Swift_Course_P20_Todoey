//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Taha Enes Aslantürk on 3.05.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<MyCategory>?
    
    //    var categoryArray = [MyCategory]()cri
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            // what will happen when user clicks the Add Item button on alert
            
            //            let newCategory = MyCategory(context: self.context)
            let newCategory = MyCategory()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            //            self.categoryArray.append(newCategory)
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let cat = categoryArray?[indexPath.row] {
            cell.textLabel?.text = cat.name ?? "No categories added yet"
            
            cell.backgroundColor = UIColor(hexString: cat.color ?? "1D9BF6")
            
            guard let categoryColor = UIColor(hexString: cat.color) else {fatalError("Category color does not exist")}
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        
        
        
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Data Manupulation Methods
    
    func save(category: MyCategory) {
        
        do {
            //try context.save()
            try realm.write({
                realm.add(category)
            })
            print("Category is saved succesfully")
        }catch {
            print("Error when saving the data \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from table
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(category)
                })
            }catch {
                print(error)
            }
        }
    }
    
    //MARK: - CoreData
    //    func loadCategories(with request: NSFetchRequest<MyCategory> = MyCategory.fetchRequest()) {
    //        do {
    //            categoryArray = try context.fetch(request)
    //        } catch {
    //            print("Error fetching data from context, \(error)")
    //        }
    //        tableView.reloadData()
    //    }
    
    //MARK: - Realm
    
    func loadCategories() {
        categoryArray = realm.objects(MyCategory.self)
        tableView.reloadData()
        
    }
    
}

