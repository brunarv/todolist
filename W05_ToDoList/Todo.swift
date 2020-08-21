//
//  Todo.swift
//  W05_ToDoList
//
//  Created by Bruna Ramos Vieira on 2020-05-21.
//  Copyright © 2020 Bruna Ramos Vieira. All rights reserved.
//

import Foundation

struct Todo {
    let title: String
    var isComplete: Bool = false
    
    init(title: String, isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
    }
    
    func completeToggled() -> Todo {
        return Todo(title: title, isComplete: !isComplete)
    }
}
