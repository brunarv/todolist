//
//  ViewController.swift
//  W05_ToDoList
//
//  Created by Bruna Ramos Vieira on 2020-05-21.
//  Copyright © 2020 Bruna Ramos Vieira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var todos = [
        Todo(title: "Watch iOS class - BCIT."),
        Todo(title: "Submit iOS assignment."),
        Todo(title: "Make a chocolate cake.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBSegueAction func todoViewController(_ coder: NSCoder) -> TodoViewController? {
        let vc = TodoViewController(coder: coder)
        
        if let indexpath = tableView.indexPathForSelectedRow{
            let todo = todos[indexpath.row]
            vc?.todo = todo
        }
        
        vc?.delegate = self
        
        vc?.presentationController?.delegate = self
        
        return vc
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Complete") { action, view,
            complete in
           
            let todo = self.todos[indexPath.row].completeToggled()
            self.todos[indexPath.row] = todo
            
            let cell = tableView.cellForRow(at: indexPath) as! CheckTableViewCell
            cell.set(checked: todo.isComplete)
            
            complete(true)
            
        }
        return  UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}


// conforming to UIViewDataSource
extension ViewController: UITableViewDataSource {

    //numberOfRowsInSection: how many row you want to show in the list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    //what cell show be presented for each index, if you 100 cells, it is going to be indexed from 0 to 99. It will return a UITableViewCell. So this func will create each cell and present it.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CheckTableViewCell
        
        cell.delegate = self
        
        let todo = todos[indexPath.row]
        
        cell.set(title: todo.title, checked: todo.isComplete)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
    }
}

extension ViewController: CheckTableViewCellDelegate {
    func checkTableViewCell(_ cell: CheckTableViewCell, didChangeCheckedState checked: Bool) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let todo = todos[indexPath.row]
        let newTodo = Todo(title: todo.title, isComplete: checked )
        
        todos[indexPath.row] = newTodo
    }
}

extension ViewController: TodoViewControllerDelegate {
    
    func todoViewController(_ vc: TodoViewController, didSaveTodo todo: Todo) {
       
        dismiss(animated: true) {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                       //update
                self.todos[indexPath.row] = todo
                self.tableView.reloadRows(at: [indexPath], with: .none)
                   } else {
                       //create
                self.todos.append(todo)
                self.tableView.insertRows(at: [IndexPath.init(row: self.todos.count-1, section: 0)], with: .automatic)
                   }
        }
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if  let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

