//
//  ReservationCellView.swift
//  Hookah Tau
//
//  Created by cstore on 20/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationCellView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var adressLabel: UILabel?
    
    @IBOutlet weak var dateLabel: UILabel?
    
    @IBOutlet weak var timeLabel: UILabel?
    
    @IBOutlet weak var maxPeopleLabel: UILabel?
    
    @IBOutlet weak var tableImageView: UIImageView?
    
    @IBOutlet weak var cancelButton: Button? {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: cancelButton, withTitle: "ОТМЕНИТЬ")
        }
    }
    
    @IBOutlet weak var changeButton: Button? {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: changeButton, withTitle: "ИЗМЕНИТЬ")
        }
    }
    
    @IBOutlet weak var swipableView: UIView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // https://developer.apple.com/videos/play/wwdc2015/229/
    @IBAction func swipeImageView(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.swipableView)
        guard let view = recognizer.view else { return }
    
        let point = CGPoint(x: view.center.x + translation.x, y: view.center.y)
        if self.swipableView?.bounds.contains(point) == true {
            view.center = point
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.swipableView)

        if recognizer.state == .ended {
            // 1
            let velocity = recognizer.velocity(in: self.swipableView)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 300
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")

            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:view.center.x + (velocity.x * slideFactor),
                                       y:view.center.y)
            // 4
            finalPoint.x = min(max(finalPoint.x, 0), self.swipableView?.bounds.size.width ?? 0.0 - view.bounds.width / 2 )

            // 5
            UIView.animate(withDuration: Double(slideFactor * 2),
                             delay: 0,
                             // 6
                options: UIView.AnimationOptions.curveEaseOut,
                             animations: { view.center = finalPoint },
                             completion: nil)
        }
    }
    
    private func checkArea(_ coord: CGPoint) {
        
    }
    
}
