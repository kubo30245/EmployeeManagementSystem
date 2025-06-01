//
//  EmployeeListToolbarView.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/06/01.
//

import SwiftUI

// 社員リスト画面下部のベージバー
struct PageBarView: View {
    // EmployeeListViewModelのPublished変数が更新されると、Viewも更新される
    @ObservedObject var viewModel: EmployeeListViewModel
    // ページボタンの数
    private var pageButtonCount: Int = 5
    
    init(viewModel: EmployeeListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if viewModel.currentPage > 1 {
                Button("最初へ") {
                    viewModel.isLoading = true
                    viewModel.currentPage = 1
                    viewModel.loadEmployees(page: viewModel.currentPage)
                }
            } else {
                Text("")
            }
        }
        .frame(width: 60, height: 30)
        Spacer()
        // 総ページ数が5以下の場合は全てのページボタンを表示
        if viewModel.totalPage <= pageButtonCount {
            ForEach(1...viewModel.totalPage, id: \.self) { page in
                PageButton(viewModel: viewModel, page: page)
            }
        } else {
            // 総ページ数が5より大きい場合にページボタン表示を切り替える処理
            // 現在のページがベージボタン数-2以下の場合は最初の5ページ+...を表示(1 2 3 4 5 ...)
            if viewModel.currentPage <= (pageButtonCount - 2) {
                ForEach(1...5, id: \.self) { page in
                    PageButton(viewModel: viewModel, page: page)
                }
                Text("...")
            }
            // 現在のページが総ページ数-2以上の場合は最後の5ページ+...を表示(... 6 7 8 9 10) ※最後のページが10の場合の例
            else if viewModel.currentPage >= (viewModel.totalPage - 2) {
                Text("...")
                ForEach((viewModel.totalPage - (pageButtonCount - 1))...viewModel.totalPage, id: \.self) { page in
                    PageButton(viewModel: viewModel, page: page)
                }
            } else {
                // 上記の条件以外の場合は、現在のページを中心に前後2ページずつ表示する(... 4 5 6 7 8 ...)
                Text("...")
                ForEach(viewModel.currentPage-2...viewModel.currentPage+2, id: \.self) { page in
                    PageButton(viewModel: viewModel, page: page)
                }
                Text("...")
            }
        }
        Spacer()
        Group {
            if viewModel.currentPage < viewModel.totalPage {
                Button("最後へ") {
                    viewModel.isLoading = true
                    viewModel.currentPage = viewModel.totalPage
                    viewModel.loadEmployees(page: viewModel.currentPage)
                }
            } else {
                Text("")
            }
        }
        .frame(width: 60, height: 30)
    }
}

// ページボタンの共通ビュー
struct PageButton: View {
    @ObservedObject var viewModel: EmployeeListViewModel
    var page: Int
    
    
    var body: some View {
        if page <= viewModel.totalPage {
            if viewModel.currentPage == page {
                // 現在のページを示すボタンは背景色を変える
                Button(String(page)) {
                    viewModel.isLoading = true
                    viewModel.currentPage = page
                    viewModel.loadEmployees(page: viewModel.currentPage)
                }
                .background(Color(.systemGray5))
                .cornerRadius(8)
            } else {
                Button(String(page)) {
                    viewModel.isLoading = true
                    viewModel.currentPage = page
                    viewModel.loadEmployees(page: viewModel.currentPage)
                }
            }
        }
    }
}
