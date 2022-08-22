//
//  CategoryTableViewController.swift
//  TodoList_app
//
//  Created by Zhora Babakhanyan on 8/22/22.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var groups = [Grupa]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
    }
    
    func saveGroups(){
        do {
            try self.context.save()
        }catch {
            print("Error Saving Category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Grupa> = Grupa.fetchRequest()
        do{
            self.groups = try context.fetch(request)
        }catch{
            print("Error Loading Groups \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newGroup = Grupa(context: self.context)
            newGroup.name = textField.text!
            
            self.groups.append(newGroup)
            self.saveGroups()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table View Delegate and Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text =  self.groups[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.context.delete(self.groups[indexPath.row])
            self.groups.remove(at: indexPath.row)
            self.saveGroups()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedGroup = self.groups[indexPath.row]
        }
    }
}
