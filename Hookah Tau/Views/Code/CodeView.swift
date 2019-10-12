//
//  CodeView.swift
//  Hookah Tau
//
//  Created by cstore on 07/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class CodeView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var fst: UITextField?
    
    @IBOutlet weak var snd: UITextField?
    
    @IBOutlet weak var trd: UITextField?
    
    @IBOutlet weak var frt: UITextField?
    
    @IBOutlet weak var fif: UITextField?

    @IBOutlet weak var six: UITextField?
    
    private var allNumbers: [UITextField] = []
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        allNumbers = [fst,
                     snd,
                     trd,
                     frt,
                     fif,
                     six].compactMap{ $0 }
        
        _ = allNumbers.map { $0.keyboardType = .numberPad }
    }
    
}
