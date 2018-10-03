//
//  ConversionCalcButton.swift
//  UnitConversionApp
//
//  Created by user144818 on 9/29/18.
//  Copyright © 2018 user144818. All rights reserved.
//

import UIKit

class ConversionCalcButton: UIButton {

    override func awakeFromNib() {
        self.backgroundColor       = FOREGROUND_COLOR
        self.tintColor             = BACKGROUND_COLOR
        self.layer.cornerRadius    = 5.0
    }
}
