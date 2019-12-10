//
//  Extensions+String.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation


extension String {
    
    /// Only works with 9-length strings, for ex 01 733 01 79: (2 3 2 2)
    func formattedNumber() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        let phoneMask = "+7 (9XX) XXX-XX-XX"
        var index = cleanPhoneNumber.startIndex
        for ch in phoneMask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
