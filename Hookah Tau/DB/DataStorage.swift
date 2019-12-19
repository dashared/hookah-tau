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
        case cookies
        case chosenEstablishment // only for admin
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
    
    /// Сохраняем выбранный администратором establishmentId
    func setupEstablishmentChoice(id: Int) {
        UserDefaults.standard.setValue(id, forKey: Keys.chosenEstablishment.rawValue)
    }
    
    func getEstablishmentChoice() -> Int? {
        let val = UserDefaults.standard.integer(forKey: Keys.chosenEstablishment.rawValue)
        return val == 0 ? nil : val
    }
    
    /// Метод для установки куков в хранилище
    /// - Parameter cookies: куки
    /// - Parameter url: url для куков
    func setCookies(_ cookies: [HTTPCookie], forURL url: URL) {
        let cookiesStorage = HTTPCookieStorage.shared
        let userDefaults = UserDefaults.standard

        var cookieDict = [String: AnyObject]()

        for cookie in cookiesStorage.cookies(for: url)! {
            cookieDict[cookie.name] = cookie.properties as AnyObject?
        }

        userDefaults.set(cookieDict, forKey: Keys.cookies.rawValue)
    }
    
    
    /// Достаем из хранилища и устанавливаем куки
    /// Если не выходит, то вовзращаем false
    func getCookies() -> Bool {
        let cookiesStorage = HTTPCookieStorage.shared
        let userDefaults = UserDefaults.standard

        if let cookieDictionary = userDefaults.dictionary(forKey: Keys.cookies.rawValue) {
            
            for (_, cookieProperties) in cookieDictionary {
                if let cookie = HTTPCookie(properties: cookieProperties as! [HTTPCookiePropertyKey : Any] ) {
                    cookiesStorage.setCookie(cookie)
                }
            }
            return true
        }
        
        return false
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
        return UserDefaults.standard.bool(forKey: Keys.loggedIn.rawValue) && getCookies()
    }
    
    func setLoggedInState(_ value: Bool) {
        if !value {
            UserDefaults.standard.removeObject(forKey: Keys.name.rawValue)
            UserDefaults.standard.removeObject(forKey: Keys.phone.rawValue)
            UserDefaults.standard.removeObject(forKey: Keys.cookies.rawValue)
        }
        UserDefaults.standard.set(value, forKey: Keys.loggedIn.rawValue)
    }
}
