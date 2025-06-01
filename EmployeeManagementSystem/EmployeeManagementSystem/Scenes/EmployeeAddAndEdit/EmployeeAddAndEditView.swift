//
//  EmployeeAddAndEditView.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/28.
//

import SwiftUI

// 社員情報を追加、編集する画面
struct EmployeeAddAndEditView: View {
    // 前の画面に戻るようの変数
    @Environment(\.dismiss) var dismiss
    // EmployeeAddAndEditViewModelにPublishedで定義してある変数の値が更新されたらViewをリロード
    @StateObject private var viewModel: EmployeeAddAndEditViewModel
    // 必須の項目が未入力の場合にアラートを表示するためのフラグ
    @State private var isExistEmptyInfoAlert = false
    // メールアドレスの形式が不正な場合にアラートを表示するためのフラグ
    @State private var isInvalidEmailAlert = false
    
    // 編集の場合、社員詳細画面から渡されたEmployeeオブジェクトを受け取る
    init(employee: Employee? = nil) {
        _viewModel = StateObject(wrappedValue: EmployeeAddAndEditViewModel(employee: employee))
    }
    
    // Viewの本体
    var body: some View {
        // ナビゲーションバーを表示
        NavigationView {
            VStack {
                // フォームを使用して入力項目を表示
                Form {
                    Section {
                        // 名前の入力欄
                        RequiredInfoView(view: AnyView(
                            InputTextView(infoLabel: "名前", inputText: $viewModel.name)
                        ))
                        // 性別の入力欄
                        RequiredInfoView(view: AnyView(
                            Picker("性別", selection: $viewModel.gender) {
                                ForEach(Gender.allCases) { gender in
                                    Text(gender.rawValue)
                                }
                            }
                        ))
                        // 誕生日の入力欄
                        RequiredInfoView(view: AnyView(
                            DatePicker("誕生日", selection: $viewModel.birthday, displayedComponents: .date)
                        ))
                        // メールアドレスの入力欄
                        RequiredInfoView(view: AnyView(
                            InputTextView(infoLabel: "メールアドレス", inputText: $viewModel.email)
                        ))
                        // 所属部署の入力欄
                        RequiredInfoView(view: AnyView(
                            Picker("所属部署", selection: $viewModel.department) {
                                ForEach(Department.allCases) { department in
                                    Text(department.rawValue)
                                }
                            }
                        ))
                        // 入社日の入力欄
                        RequiredInfoView(view: AnyView(
                            DatePicker("入社日", selection: $viewModel.joinDate, displayedComponents: .date)
                        ))
                        // 社員番号の入力欄
                        RequiredInfoView(view: AnyView(
                            InputTextView(infoLabel: "社員番号", inputText: $viewModel.employeeNumber)
                        ))
                        // 備考の入力欄
                        InputTextView(infoLabel: "備考(任意)", inputText: $viewModel.notes)
                    }
                    // フッターに必須項目の説明を表示
                    footer: {
                        Text("*は必須項目です。")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                // 引数で渡されたEmployeeオブジェクトがnilの場合は新規追加、そうでない場合は編集と表示を切り替える
                .navigationTitle(viewModel.employee == nil ? "新規社員追加" : "社員情報編集")
                // ナビゲーションバーにボタンを追加
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("キャンセル") {
                            // キャンセルボタンが押されたら前の画面に戻る
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(viewModel.employee == nil ? "登録" : "更新") {
                            // 未入力の必須項目があればアラート表示フラグを立てる
                            if viewModel.isExistEmptyInfo() {
                                isExistEmptyInfoAlert = true
                                return
                            }
                            
                            // メールアドレスの形式が不正な場合はアラート表示フラグを立てる
                            if !viewModel.isValidEmail(inputEmail: viewModel.email) {
                                isInvalidEmailAlert = true
                                return
                            }
                            
                            // 社員情報の追加または更新を行う
                            if viewModel.employee == nil {
                                viewModel.addNewEmployee()
                                dismiss()
                            } else {
                                viewModel.updateEmployee()
                                dismiss()
                            }
                        }
                    }
                }
                // 必須項目未入力のアラート
                .alert("入力エラー", isPresented: $isExistEmptyInfoAlert) {
                    Button("OK") {}
                } message: {
                    Text("すべての必須項目を入力してください。")
                }
                // メールアドレスの形式が不正な場合のアラート
                .alert("入力形式エラー", isPresented: $isInvalidEmailAlert) {
                    Button("OK") {}
                } message: {
                    Text("有効なメールアドレスを入力してください。")
                }
            }
        }
    }
}

// 必須項目のラベルを表示するためのView
struct RequiredInfoView: View {
    var view: AnyView
    
    var body: some View {
        HStack(spacing: 0) {
            Text("*")
                .foregroundColor(.secondary)
            view
        }
    }
}

// テキストを入力する項目で使用可能な共通View
struct InputTextView: View {
    let infoLabel: String
    @Binding var inputText: String
    
    var body: some View {
        NavigationLink(destination: InputTextFieldView(infoLabel: infoLabel, inputText: $inputText)) {
            HStack {
                Text(infoLabel)
                Spacer()
                Text(inputText)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// テキスト入力用のフィールドを表示するView
struct InputTextFieldView: View {
    @Environment(\.dismiss) var dismiss
    let infoLabel: String
    @Binding var inputText: String
    
    var body: some View {
        Form {
            HStack {
                TextField("", text: $inputText)
                    .onSubmit {
                        dismiss()
                    }
            }
        }
        .navigationTitle(infoLabel)
        .navigationBarTitleDisplayMode(.inline)
    }
}
