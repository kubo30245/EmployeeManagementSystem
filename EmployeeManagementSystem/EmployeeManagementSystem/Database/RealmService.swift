//
//  RealmService.swift
//  EmployeeManagementSystem
//
//  Created by Kubo on 2025/05/27.
//

import Foundation
import RealmSwift

// Realmにアクセスするためのクラス
class RealmService {
    static let shared = RealmService() // シングルトンインスタンス
    
    private init() {
        RealmService.configureRealm()
    }
    
    // Realmの設定を行うメソッド
    private static func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1,
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    // Realmインスタンスを取得するメソッド
    func getRealm() throws -> Realm {
        do {
            return try Realm()
        }
        catch {
            throw error
        }
    }
    
    // オブジェクトを追加するメソッド
    func add<T: Object>(_ object: T) throws {
        do {
            let realm = try getRealm()
            try realm.write {
                realm.add(object)
            }
        }
        catch {
            throw error
        }
    }
    
    // 全てのオブジェクトを取得するメソッド
    func getAll<T: Object>(ofType type: T.Type) throws -> Results<T> {
        do {
            let realm = try getRealm()
            return realm.objects(type)
        }
        catch {
            throw error
        }
    }
    
    // 主キーでオブジェクトを取得するメソッド
    func get<T: Object>(byPrimaryKey key: Any) throws -> T? {
        do {
            let realm = try getRealm()
            return realm.object(ofType: T.self, forPrimaryKey: key)
        }
        catch {
            throw error
        }
    }
    
    // オブジェクトを削除するメソッド
    func delete<T: Object>(_ object: T) throws {
        do {
            let realm = try getRealm()
            try realm.write {
                realm.delete(object)
            }
        }
        catch {
            throw error
        }
        
    }
}
