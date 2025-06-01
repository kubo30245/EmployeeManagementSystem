//
//  Employee.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/27.
//

import Foundation
import RealmSwift
import SwiftUI

// 社員情報の型を定義
class Employee: Object, ObjectKeyIdentifiable {
    // 社員情報を一意に識別するためのキー
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var icon: Data
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var birthday: Date
    @Persisted var gender: String
    @Persisted var department: String
    @Persisted var joinDate: Date = Date()
    @Persisted var employeeNumber: String
    @Persisted var notes: String

    convenience init(
        icon: Data? = nil,
        name: String,
        email: String,
        birthday: Date,
        gender: String,
        department: String,
        joinDate: Date,
        employeeNumber: String,
        notes: String = ""
    ) {
        self.init()
        self.id = ObjectId.generate()
        self.name = name
        self.email = email
        self.birthday = birthday
        self.gender = gender
        self.department = department
        self.joinDate = joinDate
        self.employeeNumber = employeeNumber
        self.notes = notes
    }
}
