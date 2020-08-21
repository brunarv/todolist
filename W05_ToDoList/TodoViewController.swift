//
//  TodoViewController.swift
//  W05_ToDoList
//
//  Created by Bruna Ramos Vieira on 2020-05-22.
//  Copyright © 2020 Bruna Ramos Vieira. All rights reserved.
//

import UIKit

protocol TodoViewControllerDelegate: AnyObject {
    func todoViewController(_ vc: TodoViewController, didSaveTodo: Todo)
}


class TodoViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: TodoViewControllerDelegate?
    
    var todo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.text = todo?.title
    }
    

    @IBAction func save(_ sender: UIButton) {
        
        let todo = Todo(title: textField.text!)
        delegate?.todoViewController(self,didSaveTodo: todo)
    }
    

}
