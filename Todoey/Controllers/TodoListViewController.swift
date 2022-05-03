//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    var selectedCategory: MyCategory? {
        didSet {
           loadItems()
        }
    }
    
    // var itemArray = [Item]()
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigaton controller does not exist")}
            navBar.scrollEdgeAppearance?.backgroundColor = UIColor(hexString: colorHex)
            navBar.standardAppearance.backgroundColor = UIColor(hexString: colorHex)
            title = selectedCategory!.name
            
            navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: colorHex) ?? .systemBlue, returnFlat: true)]
            navBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: colorHex) ?? .systemBlue, returnFlat: true)]
            
            navBar.tintColor = ContrastColorOf(UIColor(hexString: colorHex) ?? .black, returnFlat: true)
            searchBar.barTintColor = UIColor(hexString: colorHex)
        }
    }
    
    //MARK: - Default TableView Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                                                    CGFloat(indexPath.row) / CGFloat(todoItems!.count) ){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
//            print("version1: \(CGFloat(indexPath.row / todoItems!.count))")
//            print("version2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
        }else {
            cell.textLabel?.text = "No Items added"
        }
        
        
        return cell
    }
    
    //MARK: - Table View Delegate Functions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Update realm
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            }catch {
                print(error)
            }
        }
        
        // DELETE REALM
//        if let item = todoItems?[indexPath.row] {
//            do {
//                try realm.write({
//                    realm.delete(item)
//                })
//            }catch {
//                print(error)
//            }
//        }
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        // Update
        // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
//        todoItems[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Delete
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        
//        self.saveItems()
        
        
    }
    //MARK: - ADD New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // what will happen when user clicks the Add Item button on alert
            
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    })
                }catch {
                    print(error)
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    //MARK: - Model manupulation methods
    
//    func saveItems() {
//
//        do {
//            try context.save()
//            print("Item is saved succesfully")
//        }catch {
//            print("Error when saving the data \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(item)
                })
            }catch {
                print(error)
            }
        }
    }
    
    //MARK: - CoreData
    
   /* func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //        if let data = try? Data(contentsOf: dataFilePath!) {
        //            let decoder = PropertyListDecoder()
        //            do {
        //                itemArray = try decoder.decode([Item].self, from: data)
        //            }catch {
        //                print("Error decoding items")
        //            }
        //
        //        }
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
      
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate ,predicate])
//
//        request.predicate = predicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    } */
    //MARK: - Realm
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
    }
    
}



//MARK: - SearchBar Methods

/* extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
} */

//MARK: - SearchBAr with Realm
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
 
 
}
