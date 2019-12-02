//
//  MapView.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class MapImageScroll: UIView {
    
    weak var handler: MapHandler? 
    
    var scrollViewParent: UIScrollView!
    
    var shadowView: UIView!
    
    var img: UIImageView!
    
    var tables: [Int: TableButton] = [:]
    
    var zoomScale: CGFloat = 1.2
    
    func scrollToTable(table: Int) {
        guard let tableButton = tables[table] else { return }
        
        tableButton.select()
        img.bringSubviewToFront(shadowView)
        img.bringSubviewToFront(tableButton)
        
        shadowView.alpha = 1
        
        scrollViewParent.zoom(to: tableButton.frame, animated: true)
        scrollViewParent.setZoomScale(zoomScale, animated: true)
    }
    
    func scrollBack() {
        img.sendSubviewToBack(shadowView)
        shadowView.alpha = 0
    }
    
    func configureFor(_ imageSize: CGSize) {
        self.scrollViewParent.contentSize = imageSize
        setMaxMinZoomScaleForCurrentBounds()
    }
    
    func setMaxMinZoomScaleForCurrentBounds() {
           let boundsSize = self.scrollViewParent.bounds.size
           let imageSize = img.bounds.size
           
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
           
           if img.frame.width < frame.width {
               let scaleW = frame.width / img.frame.width
               minScale = scaleW
           }
           
           if img.frame.height < frame.height {
               let scaleH = frame.height / img.frame.height
               maxScale = scaleH
           }
           
           img.transform = CGAffineTransform(scaleX: minScale, y: minScale)
           
           self.scrollViewParent.maximumZoomScale = maxScale
           self.scrollViewParent.minimumZoomScale = minScale
       }
    
    // Method for handling button taps.
    func handleTap(button: TableButton, id: Int) {
        tables.values.forEach { $0.unselect() }
        button.select()
        handler?.handleTap(withId: id)
    }
}

extension MapImageScroll {
    
    func performUpdate(inactive: [Int]) {
        
        let active = Set(tables.keys).subtracting(inactive)
        active.forEach {  ind in tables[ind]?.active() }
        inactive.forEach {  ind in tables[ind]?.inactive() }
    }
}
