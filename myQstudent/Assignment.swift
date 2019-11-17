//
//  Assignment.swift
//  myQstudent
//
//  Created by Parth Saxena on 10/10/19.
//  Copyright © 2019 Parth Saxena. All rights reserved.
//

import Foundation

class Assignment {
    var title: String?
    var grade: String?
    var date: String?
    
    init(title: String, grade: String, date: String) {
        self.title = title
        self.grade = grade
        self.date = date
    }
}
