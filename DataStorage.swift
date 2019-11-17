//
//  DataStorage.swift
//  Hookah Tau
//
//  Created by cstore on 01/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

/// Класс для хранения промежуточного состояния регистрации,
/// данных пользователя, ...
class DataStorage {
    
    enum Keys: String {
        case name
        case phone
        case isAdmin
        case loggedIn
    }
    
    private init() {}
    
    static let standard = DataStorage()
    
    /// Номер телефона для процесса регистрации/авторизации
    var phone: String?
    /// Имя введенное при регистрации
    var name: String?
    
    /// Метод для сохранения данных пользователя в приложении,
    /// используется для сохранения объекта, полученного после успешной
    /// авторизации, регистрации
    func saveUserModel(_ user: User) {
        let name = user.name
        let phone = user.phoneNumber
        let isAdmin = user.isAdmin
        
        UserDefaults.standard.setValue(name, forKey: Keys.name.rawValue)
        UserDefaults.standard.setValue(phone, forKey: Keys.phone.rawValue)
        UserDefaults.standard.setValue(isAdmin, forKey: Keys.isAdmin.rawValue)
    }
    
    func getUserModel() -> User? {
        guard
            let name = UserDefaults.standard.string(forKey: Keys.name.rawValue),
            let phone = UserDefaults.standard.string(forKey: Keys.phone.rawValue)
        else { return nil }

        let isAdmin = UserDefaults.standard.bool(forKey: Keys.isAdmin.rawValue)
        
        return User(name: name, phoneNumber: phone, isAdmin: isAdmin)
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.loggedIn.rawValue)
    }
    
    func setLoggedInState(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.loggedIn.rawValue)
    }
}
