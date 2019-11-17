//
//  MapView.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class MapImageScroll: UIView {
    var scrollViewParent: UIScrollView!
    var tables: [Int: UIButton] = [:]
}

extension MapImageScroll {
    
    func performUpdate(inactive: [Int]) {
        
        let active = Set(tables.keys).subtracting(inactive)
        active.forEach {  ind in tables[ind]?.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 1, alpha: 0.3711205051) }
        inactive.forEach {  ind in tables[ind]?.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.7170844332, alpha: 0.3711205051)  }
    }
}
