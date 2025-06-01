//
//  EmployeeRepository.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/28.
//

import Foundation
import RealmSwift
import Combine

// 社員情報をRealmに追加,取得,削除などの操作をするクラス
class EmployeeRepository {
    private let realmService: RealmService = RealmService.shared
    
    // 開始のインデックスと終了のインデックスを渡して社員情報のリストを取得するメソッド
    func getEmployees(from fromIndex: Int, to toIndex: Int) throws -> ([Employee], Int) {
        do {
            // 不正なインデックスが指定されている場合はエラーを返す
            guard fromIndex >= 0, toIndex >= 0, fromIndex <= toIndex else {
                throw NSError(domain: "index is invalid", code: 1)
            }
            
            // 全ての社員情報を取得
            let allEmployees = try realmService.getAll(ofType: Employee.self).sorted(byKeyPath: "name")
            
            // 社員情報が保存されていないの処理
            let allEmployeesCount = allEmployees.count
            if allEmployeesCount == 0 {
                return ([], 0)
            }
            
            // 範囲指定が有効であることを確認
            guard fromIndex <= allEmployeesCount else {
                throw NSError(domain: "invalid range", code: 2)
            }
            
            // 引数で指定された終了のインデックスが、社員リストの数より小さければ社員リストの最大のインデックスを終了のインデックスとする
            let actualEndIndex = min(toIndex, allEmployeesCount - 1)
            
            // 社員情報の配列と総数を返す
            return (Array(allEmployees[fromIndex...actualEndIndex]), allEmployeesCount)
        } catch {
            throw error
        }
    }
    
    // Realmから全ての社員情報を取得するメソッド
    func getAllEmployees() -> [Employee] {
        do {
            return try Array(realmService.getAll(ofType: Employee.self))
        } catch {
            print("Error getting all employees: \(error)")
            return []
        }
    }
    
    // Realmに社員情報を追加するメソッド
    func addEmployee(_ employee: Employee) {
        do {
            try realmService.add(employee)
        }
        catch {
            print("Error adding employee: \(error)")
        }
    }
    
    // Realmから社員情報を取得するメソッド
    func getEmployee(id: ObjectId) -> Employee? {
        do {
            return try realmService.get(byPrimaryKey: id)
        }
        catch {
            print("Error getting employee: \(error)")
            return nil // エラー時はnilを返す
        }
    }
    
    // Realmに既に保存済みの社員情報を更新するメソッド
    func updateEmployee(
        id: ObjectId,
        name: String,
        email: String,
        birthday: Date,
        gender: String,
        department: String,
        joinDate: Date,
        employeeNumber: String,
        notes: String
    ) {
        do {
            // 主キーでオブジェクトを取得し、更新する
            if let employeeToUpdate = getEmployee(id: id) {
                // 2. writeトランザクション内でプロパティを更新
                try realmService.getRealm().write {
                    employeeToUpdate.name = name
                    employeeToUpdate.email = email
                    employeeToUpdate.birthday = birthday
                    employeeToUpdate.gender = gender
                    employeeToUpdate.department = department
                    employeeToUpdate.joinDate = joinDate
                    employeeToUpdate.employeeNumber = employeeNumber
                    employeeToUpdate.notes = notes
                }
            } else {
                print("Error: Employee with ID \(id) not found for update.")
            }
        } catch {
            print("Error updating employee: \(error)")
        }
    }
    
    // Realmに保存済みの社員情報を削除するメソッド
    func deleteEmployee(_ employee: Employee) {
        do {
            try realmService.delete(employee)
        } catch {
            print("Error deleting employee: \(error)")
        }
    }
}
