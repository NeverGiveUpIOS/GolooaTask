//
//  GTPaddingLabel.swift
//  KTGoa
//
//  Created by chenkaisong on 2024/8/2.
//

import UIKit

public class GTPaddingLabel : UILabel {
    
    private var padding = UIEdgeInsets.zero
    
    public var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }
    
    public var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }
    
    public var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }
    
    public var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.padding
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}
