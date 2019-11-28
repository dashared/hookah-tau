//
//  MapView1.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

protocol MapHandler: class {
    func handleTap(withId id: Int)
}

class MapView1: MapImageScroll, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var shadow: UIView! {
        didSet {
            super.shadowView = shadow
            shadow.alpha = 0
        }
    }
    
    override var handler: MapHandler? {
        didSet {
            handleTap(button: firstTable, id: 1)
        }
    }
    
    
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
    
    @IBOutlet weak var firstTable: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: firstTable)
            firstTable.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 4));
        }
    }
    
    
    @IBOutlet weak var secondTable: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: secondTable)
        }
    }
    
    @IBOutlet weak var trirdTable: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: trirdTable)
        }
    }
    
    @IBOutlet weak var forthTable: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: forthTable)
        }
    }
    
    @IBOutlet weak var fifthTable: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: fifthTable)
        }
    }
    
    @IBOutlet weak var sixthTable: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: sixthTable)
        }
    }
    
    @IBOutlet weak var seventhTable: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: seventhTable)
        }
    }
    
    @IBOutlet weak var eighthTable: TableButton! {
        didSet {
            let style = TableButtonStyle()
            style.apply(to: eighthTable)
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.delegate = self
        self.scrollView.delaysContentTouches = false
        
        image.addSubview(shadow)
        image.addSubview(firstTable)
        image.addSubview(secondTable)
        image.addSubview(trirdTable)
        image.addSubview(forthTable)
        image.addSubview(fifthTable)
        image.addSubview(sixthTable)
        image.addSubview(seventhTable)
        image.addSubview(eighthTable)
        
        tables[1] = firstTable
        tables[2] = secondTable
        tables[3] = trirdTable
        tables[4] = forthTable
        tables[5] = fifthTable
        tables[6] = sixthTable
        tables[7] = seventhTable
        tables[8] = eighthTable
        
        configureFor(image.frame.size)
    }
    
    @IBAction func chooseSecondTable(_ sender: TableButton) {
        handleTap(button: sender, id: 2)
    }
    
    @IBAction func chooseFifthTable(_ sender: TableButton) {
        handleTap(button: sender, id: 5)
    }
    
    @IBAction func choseSeventhTable(_ sender: TableButton) {
        handleTap(button: sender, id: 7)
    }
    
    @IBAction func chooseFirstTable(_ sender: TableButton) {
        handleTap(button: sender, id: 1)
    }
    
    @IBAction func chooseThirdTable(_ sender: TableButton) {
        handleTap(button: sender, id: 3)
    }
    
    @IBAction func choose4thTable(_ sender: TableButton) {
        handleTap(button: sender, id: 4)
    }
    
    @IBAction func choose6thTable(_ sender: TableButton) {
        handleTap(button: sender, id: 6)
    }
    
    @IBAction func choose8thTable(_ sender: TableButton) {
        handleTap(button: sender, id: 8)
    }
    
    // MARK: - Scroll view
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.image
    }
}
