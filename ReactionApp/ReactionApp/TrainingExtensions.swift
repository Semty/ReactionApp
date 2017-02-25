//
//  TrainingExtensions.swift
//  ReactionApp
//
//  Created by Руслан on 25.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import LTMorphingLabel

extension LTMorphingLabel {
    // MARK: - Properties
    
    /// Original font for the label before any adjustment took place
    var originalFont: UIFont? = nil
    
    /// Trigger font-resize on text change
    override var text: String? {
        get {
            return super.text
        }
        set {
            
            // You do not want to change the order of next two strings
            if newValue != nil {
                adjustFontSizeToFitText(newValue!)
            }
            
            super.text = newValue
        }
    }
    
    // MARK: - Init
    // Save original font size.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        originalFont = font
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        originalFont = font
    }
    
    // MARK: - View Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if text != nil {
            adjustFontSizeToFitText(text!)
        }
    }
    
    // MARK: - Methods
    
    /**
     Does the actual adjustment work.
     */
    private func adjustFontSizeToFitText(newText: String){
        
        guard adjustsFontSizeToFitWidth, let originalFont = originalFont else { return }
        
        let desiredWidth = getDesiredWidthForText(newText)
        
        if frame.width < desiredWidth {
            // The text does not fit!
            let scaleFactor = max(frame.width / desiredWidth, minimumScaleFactor)
            
            font = UIFont(name: originalFont.fontName, size: originalFont.pointSize * scaleFactor)
        }
        else{
            // Revert to normal
            font = originalFont
        }
    }
    
    /**
     Calculates what the width of the label should be to fit the text.
     
     - parameter text:   Text to fit.
     */
    private func getDesiredWidthForText(text: String) -> CGFloat {
        let size = text.boundingRectWithSize(
            CGSize(width: CGFloat.max, height: frame.height),
            options: [NSStringDrawingOptions.UsesLineFragmentOrigin],
            attributes: [NSFontAttributeName: originalFont!],
            context: nil).size
        
        return ceil(size.width)
    }
}
