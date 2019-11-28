//
//  MapView2.swift
//  Hookah Tau
//
//  Created by cstore on 28/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class MapView2: MapImageScroll {
    
    // MARK: - Tables
    
    @IBOutlet weak var table2: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: table2)
        }
    }
    
    @IBOutlet weak var table3: TableButton!{
        didSet {
            let style = TableButtonStyle()
            style.apply(to: table3)
        }
    }
    
    @IBOutlet weak var table4: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: table4)
        }
    }
    
    @IBOutlet weak var table5: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: table5)
        }
    }
    
    @IBOutlet weak var table6: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: table6)
        }
    }
    
    @IBOutlet weak var table7: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: table7)
        }
    }
    
    @IBOutlet weak var table8: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: table8)
        }
    }
    
    override var handler: MapHandler? {
        didSet {
            handleTap(button: table8, id: 8)
        }
    }
    
    // MARK: - Super props
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            super.scrollViewParent = scrollView
        }
    }
    
    @IBOutlet weak var image: UIImageView! {
        didSet {
            super.img = image
        }
    }
    
    @IBOutlet weak var shadow: UIView! {
        didSet {
            super.shadowView = shadow
            shadow.alpha = 0
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.delegate = self
        self.scrollView.delaysContentTouches = false
        
        tables[2] = table2
        tables[3] = table3
        tables[4] = table4
        tables[5] = table5
        tables[6] = table6
        tables[7] = table7
        tables[8] = table8
        
        tables.values.forEach { image.addSubview($0) }
        image.addSubview(shadowView)
        
        configureFor(image.frame.size)
    }
    
    // MARK: - Taps
    
    @IBAction func tap2(_ sender: TableButton) {
        handleTap(button: sender, id: 2)
    }
    
    @IBAction func tap3(_ sender: TableButton) {
        handleTap(button: sender, id: 3)
    }
    
    @IBAction func tap4(_ sender: TableButton) {
        handleTap(button: sender, id: 4)
    }
    
    @IBAction func tap5(_ sender: TableButton) {
        handleTap(button: sender, id: 5)
    }
    
    @IBAction func tap6(_ sender: TableButton) {
        handleTap(button: sender, id: 6)
    }
    
    @IBAction func tap7(_ sender: TableButton) {
        handleTap(button: sender, id: 7)
    }
    
    @IBAction func tap8(_ sender: TableButton) {
        handleTap(button: sender, id: 8)
    }
    
}

// MARK: - Scroll view

extension MapView2: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.image
    }
}
