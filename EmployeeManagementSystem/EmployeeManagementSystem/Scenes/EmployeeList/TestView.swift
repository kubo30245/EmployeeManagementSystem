//
//  TestView.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/31.
//

import SwiftUI

// テスト用に社員を追加・削除するためのビュー
struct TestView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EmployeeListViewModel
    @State private var isShowProgressView: Bool = false
    private var employeeRepository: EmployeeRepository
    
    init(employeeRepository: EmployeeRepository = EmployeeRepository(), viewModel: EmployeeListViewModel) {
        self.employeeRepository = employeeRepository
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button("社員を100人追加") {
                    for index in (1...100) {
                        employeeRepository.addEmployee(
                            Employee(
                                name: "社員 \(index)",
                                email: "employee\(index)@example.com",
                                birthday: Date(),
                                gender: Gender.male.rawValue,
                                department: Department.engineering.rawValue,
                                joinDate: Date(),
                                employeeNumber: "E\(index)",
                                notes: "備考 \(index)"
                            )
                        )
                    }
                }
                Spacer()
                Button("社員を10000人追加") {
                    viewModel.isLoading = true
                    isShowProgressView = true
                    DispatchQueue.global().async {
                        for index in (1...10000) {
                            employeeRepository.addEmployee(
                                Employee(
                                    name: "社員 \(index)",
                                    email: "employee\(index)@example.com",
                                    birthday: Date(),
                                    gender: Gender.male.rawValue,
                                    department: Department.engineering.rawValue,
                                    joinDate: Date(),
                                    employeeNumber: "E\(index)",
                                    notes: "備考 \(index)"
                                )
                            )
                        }
                        DispatchQueue.main.async {
                            isShowProgressView = false
                            dismiss()
                        }
                    }
                }
                Spacer()
                Button("社員を全削除") {
                    viewModel.isLoading = true
                    isShowProgressView = true
                    DispatchQueue.global().async {
                        employeeRepository.getAllEmployees().forEach {
                            employeeRepository.deleteEmployee($0)
                        }
                        DispatchQueue.main.async {
                            isShowProgressView = false
                            viewModel.currentPage = 1
                            dismiss()
                        }
                    }
                }
                Spacer()
            }
            if isShowProgressView {
                Color.white.opacity(0.9)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(true)
                
                ProgressView("実行中...\n30秒程度かかります")
                    .progressViewStyle(CircularProgressViewStyle())
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
