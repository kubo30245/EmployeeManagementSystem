//
//  EmployeeDetailView.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/28.
//

import SwiftUI
import RealmSwift

// 社員情報の詳細画面
struct EmployeeDetailView: View {
    // 前の画面に戻るための変数
    @Environment(\.dismiss) var dismiss
    // EmployeeDetailViewModelでPublishedで定義した変数が更新されたらViewをリロードする
    @StateObject private var viewModel: EmployeeDetailViewModel
    // 編集ボタンを押した時に編集画面を表示するためのフラグ
    @State private var showingEditEmployeeSheet = false
    // 社員情報を削除した後に呼び出されるクロージャ
    private var onDeleteEmployee: () -> Void
    
    init(employeeId: ObjectId, onDeleteEmployee: @escaping () -> Void) {
        // 初期化時にEmployeeDetailViewModelを生成し、社員IDを渡す
        _viewModel = StateObject(wrappedValue: EmployeeDetailViewModel(employeeId: employeeId))
        // 社員情報を削除した後に呼び出されるクロージャを設定
        self.onDeleteEmployee = onDeleteEmployee
    }
    
    // Viewの本体
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let employee = viewModel.employee {
                // 社員詳細画面の上側のビュー
                EmployeeDetailTopView(employee: employee)
                // 個人情報のビュー
                EmployeeDetailPersonalInfoView(employee: employee)
                // 所属情報のビュー
                EmployeeDetailAffiliationInfoView(employee: employee)
                Spacer()
                // 社員情報を削除するボタン
                HStack {
                    Spacer()
                    Button("社員情報を削除") {
                        // 社員情報を削除した後、社員リスト画面の処理との競合を避けるためにクロージャを呼び出す
                        onDeleteEmployee()
                        // 社員情報を削除
                        viewModel.deleteEmployee()
                        // 前の画面に戻る
                        dismiss()
                    }
                    .tint(.red)
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            } else {
                // 社員情報が見つからない場合の画面
                Text("社員情報が見つかりません。")
            }
        }
        // ナビゲーションバーのタイトルと編集ボタンを設定
        .navigationTitle("社員詳細")
        // 編集ボタンを押した時に編集画面表示のフラグを立てる
        .navigationBarItems(trailing: Button("編集") { showingEditEmployeeSheet = true })
        // 編集画面表示のフラグが立った時に編集画面を表示
        .sheet(isPresented: $showingEditEmployeeSheet) {
            if let employee = viewModel.employee {
                EmployeeAddAndEditView(employee: employee)
                    // 編集画面が閉じられた時に社員情報を再読み込み
                    .onDisappear { viewModel.loadEmployee() }
            }
        }
    }
}

// 社員詳細画面の上側のビュー
struct EmployeeDetailTopView: View {
    let employee: Employee
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .clipShape(Circle())
                .padding(.leading, 50)
            Spacer()
            VStack {
                Spacer()
                Text("\(employee.name)")
                    .font(.system(size: 25))
                    .padding(.bottom, 2)
                Text("\(employee.department)")
                    .font(.system(size: 20))
                Spacer()
            }
            .frame(height: 100)
            Spacer()
        }
        .background(Color(.white))
        .padding(.top, 20)
    }
}

// 社員詳細画面の個人情報ビュー
struct EmployeeDetailPersonalInfoView: View {
    let employee: Employee
    
    var body: some View {
        VStack {
            HStack {
                Text("個人情報")
                    .font(.title3)
                    .padding(.leading, 50)
                Spacer()
            }
            .padding(.bottom, 5)
            EmployeeDetailInfoRow(employee: employee, text: "氏名: \(employee.name)")
            EmployeeDetailInfoRow(employee: employee, text: "性別: \(employee.gender)")
            EmployeeDetailInfoRow(employee: employee, text: "誕生日: \(employee.birthday.formatted(date: .numeric, time: .omitted))")
            EmployeeDetailInfoRow(employee: employee, text: "メール: \(employee.email)")
        }
        .padding(.top, 20)
    }
}

// 社員詳細画面の所属情報ビュー
struct EmployeeDetailAffiliationInfoView: View {
    let employee: Employee
    
    var body: some View {
        VStack {
            HStack {
                Text("所属情報")
                    .font(.title3)
                    .padding(.leading, 50)
                Spacer()
            }
            .padding(.bottom, 5)
            EmployeeDetailInfoRow(employee: employee, text: "社員番号: \(employee.employeeNumber)")
            EmployeeDetailInfoRow(employee: employee, text: "所属部署: \(employee.department)")
            EmployeeDetailInfoRow(employee: employee, text: "入社日: \(employee.joinDate.formatted(date: .numeric, time: .omitted))")
            EmployeeDetailInfoRow(employee: employee, text: "備考: \(employee.notes)")
        }
        .padding(.top, 20)
    }
}

// 社員詳細画面の情報行を表示する共通View
struct EmployeeDetailInfoRow: View {
    let employee: Employee
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .padding(.leading, 50)
                .padding(.trailing, 50)
            Spacer()
        }
    }
}
