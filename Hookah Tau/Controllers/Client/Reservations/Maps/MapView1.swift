//
//  MapView1.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

protocol MapHandler {
    func handleTap(withId id: Int)
}

class MapView1: MapImageScroll, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var handler: MapHandler?
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            super.scrollViewParent = scrollView
        }
    }
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var firstTable: UIButton! {
        didSet {
            firstTable.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 4));
        }
    }
    
    @IBOutlet weak var secondTable: UIButton!
    
    @IBOutlet weak var trirdTable: UIButton!
    
    @IBOutlet weak var forthTable: UIButton!
    
    @IBOutlet weak var fifthTable: UIButton!
    
    @IBOutlet weak var sixthTable: UIButton!
    
    @IBOutlet weak var seventhTable: UIButton!
    
    @IBOutlet weak var eighthTable: UIButton!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.delegate = self
        
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
    
    @IBAction func chooseSecondTable(_ sender: UIButton) {
        handler?.handleTap(withId: 2)
    }
    
    // MARK: - Scroll view
    
    func configureFor(_ imageSize: CGSize) {
        self.scrollView.contentSize = imageSize
        setMaxMinZoomScaleForCurrentBounds()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.image
    }
    
    func setMaxMinZoomScaleForCurrentBounds() {
        let boundsSize = self.scrollView.bounds.size
        let imageSize = image.bounds.size
        
        //1. calculate minimumZoomscale
        let xScale = boundsSize.width  / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        var minScale = min(xScale, yScale)
        
        //2. calculate maximumZoomscale
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        if image.frame.width < frame.width {
            let scaleW = frame.width / image.frame.width
            minScale = scaleW
        }
        
        if image.frame.height < frame.height {
            let scaleH = frame.height / image.frame.height
            maxScale = scaleH
        }
        
        image.transform = CGAffineTransform(scaleX: minScale, y: minScale)
        
        self.scrollView.maximumZoomScale = maxScale
        self.scrollView.minimumZoomScale = minScale
    }
}
