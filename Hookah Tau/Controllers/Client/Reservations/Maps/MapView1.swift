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
            firstTable.select()
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
        tables.values.forEach { $0.unselect() }
        secondTable.select()
        handler?.handleTap(withId: 2)
    }
    
    @IBAction func chooseFifthTable(_ sender: TableButton) {
        tables.values.forEach { $0.unselect() }
        fifthTable.select()
        handler?.handleTap(withId: 5)
    }
    
    @IBAction func choseSeventhTable(_ sender: TableButton) {
    }
    
    @IBAction func chooseFirstTable(_ sender: TableButton) {
        tables.values.forEach { $0.unselect() }
        firstTable.select()
        handler?.handleTap(withId: 1)
    }
    
    @IBAction func chooseThirdTable(_ sender: TableButton) {
    }
    
    @IBAction func choose4thTable(_ sender: TableButton) {
    }
    
    @IBAction func choose6thTable(_ sender: TableButton) {
    }
    
    @IBAction func choose8thTable(_ sender: TableButton) {
    }
    
    
    // MARK: - Scroll view
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.image
    }
    
    
    override func scrollToTable(table: Int) {
        guard let tableButton = tables[table] else { return }
        
        scrollView.setZoomScale(1.2, animated: true)
        scrollView.setContentOffset(tableButton.frame.origin, animated: true)
        
        scrollView.scrollRectToVisible(tableButton.frame, animated: true)
    }
}
