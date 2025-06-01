//
//  EmployeeDetailViewModel.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/28.
//

import Foundation
import RealmSwift
import Combine

class EmployeeDetailViewModel: ObservableObject {
    private var employeeRepository = EmployeeRepository()
    private var employeeId: ObjectId
    
    @Published var employee: Employee?

    init(employeeId: ObjectId) {
        self.employeeId = employeeId
        // 初期化時に指定されたIDの社員情報を取得
        self.employee = employeeRepository.getEmployee(id: employeeId)
    }
    
    // 社員情報を再取得するメソッド
    func loadEmployee() {
        self.employee = employeeRepository.getEmployee(id: employeeId)
    }

    // 社員情報を削除するメソッド
    func deleteEmployee() {
        if let employeeToDelete = employee {
            employeeRepository.deleteEmployee(employeeToDelete)
            employee = nil
        }
    }
}
