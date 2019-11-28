//
//  TotalStorage.swift
//  Hookah Tau
//
//  Created by cstore on 28/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

/// Класс для хранения `establishments`,
class TotalStorage {
    
    // MARK: - properties
    
    static let standard = TotalStorage()

    // MARK: - Init
    
    private init() {
        service = EstablishmentSevice(apiClient: APIClient.shared)
        setEstablishments()
    }
    
    // MARK: - getters
    
    func getEstablishment(_ id: Int) -> EstablishmentData? {
        return establishments[id]
    }
    
    func getTable(establishment eId: Int, table tId: Int) -> Table {
        return imagesForTables[eId]![tId]!
    }
    
    // MARK: - Setters
    
    private func setEstablishments() {
        service.loadAdmins { (result) in
            switch result {
            case .success(let phones):
                self.phones = phones
            default:
                break
            }
        }
    }
    
    // MARK: - Private
    
    private let service: EstablishmentSevice
    
    private var establishments: [Int: EstablishmentData] = [
        1: EstablishmentData(id: 1,
                             image: #imageLiteral(resourceName: "1"),
                             admin: "",
                             address: "Гороховский пер. 12с5, 205",
                             maxTableNumber: 8),
        
        2: EstablishmentData(id: 2,
                             image: #imageLiteral(resourceName: "2"),
                             admin: "",
                             address: "ул. Рыбинская 7, кв. 2",
                             maxTableNumber: 7)
    ]
    
    private var imagesForTables: [Int: [Int: Table]] = [
        1 :[
            1: Table(image: #imageLiteral(resourceName: "1_1"), maxGuestNumber: 6),
            2: Table(image: #imageLiteral(resourceName: "1_2"), maxGuestNumber: 8),
            3: Table(image: #imageLiteral(resourceName: "1_3"), maxGuestNumber: 8),
            4: Table(image: #imageLiteral(resourceName: "1_4"), maxGuestNumber: 6),
            5: Table(image: #imageLiteral(resourceName: "1_5"), maxGuestNumber: 6),
            6: Table(image: #imageLiteral(resourceName: "1_6"), maxGuestNumber: 6),
            7: Table(image: #imageLiteral(resourceName: "1_7"), maxGuestNumber: 6),
            8: Table(image: #imageLiteral(resourceName: "1_8"), maxGuestNumber: 2)
        ],
        2 :[
            2: Table(image: #imageLiteral(resourceName: "2_2"), maxGuestNumber: 9),
            3: Table(image: #imageLiteral(resourceName: "2_3"), maxGuestNumber: 6),
            4: Table(image: #imageLiteral(resourceName: "2_4"), maxGuestNumber: 2),
            5: Table(image: #imageLiteral(resourceName: "2_5"), maxGuestNumber: 5),
            6: Table(image: #imageLiteral(resourceName: "2_6"), maxGuestNumber: 5),
            7: Table(image: #imageLiteral(resourceName: "2_7"), maxGuestNumber: 5),
            8: Table(image: #imageLiteral(resourceName: "2_8"), maxGuestNumber: 2)
        ]
    ]
    
    private var phones: [Int: String] = [:] {
        didSet {
            let newEstablishments = phones.compactMap { el -> (Int, EstablishmentData)? in
                if let es = establishments[el.key] {
                    
                    return (el.key, EstablishmentData(id: es.id,
                                             image: es.image,
                                             admin: el.value,
                                             address: es.address,
                                             maxTableNumber: es.maxTableNumber))
                } else {
                    return nil
                }
            }
            
            establishments = Dictionary(uniqueKeysWithValues: newEstablishments)
        }
    }
}

// MARK: - Nested types

extension TotalStorage {
    
    struct EstablishmentData {
        var id: Int
        var image: UIImage
        var admin: String
        var address: String
        var maxTableNumber: Int
    }
    
    struct Table {
        var image: UIImage
        var maxGuestNumber: Int
    }
}
