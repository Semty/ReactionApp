//
//  SparrowExtensions.swift
//  ReactionApp
//
//  Created by Руслан on 02.03.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import Sparrow

public extension SPBezierPathFigure {
    
    struct icons {}
}

extension UIBezierPath {
    
    func resizeTo(width: CGFloat) {
        let currentWidth = self.bounds.width
        let relativeFactor = width / currentWidth
        self.apply(CGAffineTransform(scaleX: relativeFactor, y: relativeFactor))
    }
    
    func convertToImage(fill: Bool, stroke: Bool, color: UIColor = .black) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.bounds.width, height: self.bounds.height), false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context!.setStrokeColor(color.cgColor)
        context!.setFillColor(color.cgColor)
        if stroke {
            self.stroke()
        }
        if fill {
            self.fill()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

