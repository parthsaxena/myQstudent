//
//  Class.swift
//  myQstudent
//
//  Created by Parth Saxena on 10/10/19.
//  Copyright © 2019 Parth Saxena. All rights reserved.
//

import Foundation

class Class {
    var name: String?
    var grade: String?
    var assignments: [Assignment]?
    
    init(name: String, grade: String, assignments: [Assignment]) {
        self.name = name
        self.grade = grade
        self.assignments = assignments
    }
}
