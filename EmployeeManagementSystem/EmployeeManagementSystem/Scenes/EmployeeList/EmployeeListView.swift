//
//  EmployeeListView.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/27.
//

import SwiftUI
import RealmSwift

struct EmployeeListView: View {
    @StateObject private var viewModel = EmployeeListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // 社員情報削除後、再読み込み中に表示するインジケーター
                    if viewModel.isLoading {
                        ProgressView("読み込み中...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        // 社員情報が登録されていない場合のメッセージ
                        if viewModel.employeesToDisplay.isEmpty {
                            Text("社員が登録されていません。")
                        } else {
                            List {
                                // 指定したページ分の社員情報を表示
                                ForEach(viewModel.employeesToDisplay) { employee in
                                    // 社員情報をタップするとその社員の詳細画面に遷移
                                    NavigationLink(
                                        destination: EmployeeDetailView(
                                            employeeId: employee.id,
                                            // 社員情報を削除した後に呼び出されるクロージャ
                                            onDeleteEmployee: {
                                                // 削除が反映された社員リストが取得できるまで、読み込み中のフラグを立てる
                                                viewModel.isLoading = true
                                                // 社員情報削除後は社員リストのページを先頭に戻す
                                                viewModel.currentPage = 1
                                            }
                                        ).onDisappear {
                                            // 社員詳細画面から戻った時に、社員リストを再読み込み
                                            viewModel.loadEmployees(page: viewModel.currentPage)
                                        }
                                    ) {
                                        // 社員情報の行を表示
                                        EmployeeRowView(employee: employee)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                // ナビゲーションバーのタイトルとツールバー
                .navigationTitle("社員リスト")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button("追加") {
                            // 追加ボタンを押すと社員追加画面表示フラグを立てる
                            viewModel.showingAddEmployeeSheet = true
                        }
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        // ページバーを表示
                        PageBarView(viewModel: viewModel)
                    }
                }
                // 社員追加画面を表示するためフラグが立ったら、社員追加画面を表示
                .sheet(isPresented: $viewModel.showingAddEmployeeSheet) {
                    EmployeeAddAndEditView()
                        .onDisappear {
                            // 社員追加画面から戻った時に、社員リストを再読み込み
                            viewModel.loadEmployees(page: viewModel.currentPage)
                        }
                }
                VStack {
                    Spacer()
                    HStack {
                        // テスト用のボタンを表示
                        NavigationLink(
                            destination: TestView(viewModel: viewModel).onDisappear {
                                viewModel.loadEmployees(page: viewModel.currentPage)
                            }
                        ) {
                            Text("テスト用")
                                .padding(5)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                        }
                        Spacer()
                        // 現在のページと総ページ数を表示
                        Text("\(viewModel.currentPage)/\(viewModel.totalPage)")
                            .font(.caption)
                            .padding(5)
                            .foregroundColor(.secondary)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                    }
                    .padding(10)
                }
            }
        }
    }
}

// 社員情報の行を表示するビュー
struct EmployeeRowView: View {
    let employee: Employee
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(employee.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(employee.department)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}
