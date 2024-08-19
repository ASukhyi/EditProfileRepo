//
//  Control.swift
//  EditProfile
//
//  Created by Andrii on 8/17/24.
//

import UIKit

@IBDesignable
class Control: UIControl {
    
    @IBInspectable var minAlpha: CGFloat = 0.5
    
    private func animate(alpha: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = alpha
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animate(alpha: minAlpha)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
        animate(alpha: 1)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animate(alpha: 1)
    }
    
}
