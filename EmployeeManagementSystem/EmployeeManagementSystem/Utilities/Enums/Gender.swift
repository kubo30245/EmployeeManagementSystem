//
//  Gender.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/31.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case male = "男性"
    case female = "女性"
    
    
    var id: String { self.rawValue }
}
