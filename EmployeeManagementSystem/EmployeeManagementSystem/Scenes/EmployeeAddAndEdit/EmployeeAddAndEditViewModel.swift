//
//  EmployeeAddViewModel.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/28.
//

import Foundation
import RealmSwift
import SwiftUI

// 社員情報追加、編集画面で使用するデータを管理するクラス
class EmployeeAddAndEditViewModel: ObservableObject {
    private var employeeRepository = EmployeeRepository()
    var employee: Employee?
    
    @Published var icon: Data = Data()
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var birthday: Date = Date()
    @Published var gender: String = Gender.male.rawValue
    @Published var department: String = Department.engineering.rawValue
    @Published var joinDate: Date = Date()
    @Published var employeeNumber: String = ""
    @Published var notes: String = ""

    init(employee: Employee? = nil) {
        // 社員情報編集時は既に保存済みの社員情報を表示する
        if let employee = employee {
            self.employee = employee
            self.icon = employee.icon
            self.name = employee.name
            self.email = employee.email
            self.birthday = employee.birthday
            self.gender = employee.gender
            self.department = employee.department
            self.joinDate = employee.joinDate
            self.employeeNumber = employee.employeeNumber
            self.notes = employee.notes
        }
    }

    // 社員を追加するメソッド
    func addNewEmployee() {
        let newEmployee: Employee = .init(
            icon: icon,
            name: name,
            email: email,
            birthday: birthday,
            gender: gender,
            department: department,
            joinDate: joinDate,
            employeeNumber: employeeNumber,
            notes: notes
        )
        employeeRepository.addEmployee(newEmployee)
    }
    
    // 社員を更新するメソッド
    func updateEmployee() {
        guard let employee = employee else { return }
        
        employeeRepository.updateEmployee(
            id: employee.id,
            name: name,
            email: email,
            birthday: birthday,
            gender: gender,
            department: department,
            joinDate: joinDate,
            employeeNumber: employeeNumber,
            notes: notes
        )
    }
    
    // 未入力の項目があるか検証するメソッド(※選択する系の項目は初期値が入っているため、検証の対象外)
    func isExistEmptyInfo() -> Bool {
        return name.isEmpty || email.isEmpty || employeeNumber.isEmpty
    }
    
    // 正規表現によってメールアドレスの形式が正しいかを検証するメソッド
    func isValidEmail(inputEmail: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: inputEmail)
    }
}
