//
//  EmployeeManagementSystemApp.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/27.
//

import SwiftUI

@main
struct EmployeeManagementSystemApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                EmployeeListView()
            }
        }
    }
}
