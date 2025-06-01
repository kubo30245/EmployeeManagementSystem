//
//  Department.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/31.
//

import Foundation

enum Department: String, CaseIterable, Identifiable {
    case engineering = "開発部"
    case marketing = "企画部"
    case accounting = "経理部"
    
    var id: String { self.rawValue }
}
