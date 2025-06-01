//
//  EmployeeListViewModel.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/28.
//

import Foundation
import RealmSwift
import Combine

class EmployeeListViewModel: ObservableObject {
    private var employeeRepository = EmployeeRepository()
    // 1ページ分の社員情報を保持するための変数
    @Published var employeesToDisplay: [Employee] = []
    // 現在のページ番号を保持するための変数
    @Published var currentPage = 1
    // 総ページ数を保持するための変数
    @Published var totalPage = 1
    // 社員情報削除後、再読み込み中を示すための変数
    @Published var isLoading = false
    // 社員追加画面を表示するためのフラグ
    @Published var showingAddEmployeeSheet = false
    
    // 社員情報を1ページあたり何件表示するかを定義
    private var displayEmployeeCount: Int = 50

    init() {
        // 初期化時に社員情報を読み込む
        self.loadEmployees(page: currentPage)
    }
    
    func loadEmployees(page: Int) {
        do {
            isLoading = true
            // ぺージ番号に基づいて社員情報を取得(1ページ目: 1～50, 2ページ目: 51～100, ... )
            let (employees, allEmployeeCount) = try employeeRepository.getEmployees(from: (page - 1) * displayEmployeeCount, to: page * displayEmployeeCount - 1)
            // 表示するページの社員情報のリストに更新
            self.employeesToDisplay = employees
            // 総ページ数を計算
            if allEmployeeCount > 0 {
                self.totalPage = (allEmployeeCount + (displayEmployeeCount - 1)) / displayEmployeeCount
            } else {
                self.employeesToDisplay = []
                self.totalPage = 1
            }
            self.isLoading = false
        }
        catch {
            print("Error loading employees: \(error)")
            self.employeesToDisplay = [] // エラー時は空の配列を設定
            self.totalPage = 1 // ページ数を1にリセット
        }
        
    }
}

