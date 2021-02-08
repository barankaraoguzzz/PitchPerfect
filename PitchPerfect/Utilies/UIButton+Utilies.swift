//
//  UIButton+Utilies.swift
//  PitchPerfect
//
//  Created by BARAN BATUHAN KARAOGUZ on 8.02.2021.
//

import UIKit

extension UIButton {
    
    open override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                self.alpha = 0.5
            }
        }
    }
    
    
}
