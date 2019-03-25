//
//  KeypadScreen.swift
//  Keypad
//
//  Created by Onur Işık on 23.03.2019.
//  Copyright © 2019 Onur Işık. All rights reserved.
//

import UIKit

class KeypadScreen: UICollectionReusableView {
    
    var label = UILabel()
    var removeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        let labelFrame = CGRect(x: 0, y: 0, width: frame.width - 20, height: 100)
        label = UILabel(frame: labelFrame)
        label.font = UIFont.boldSystemFont(ofSize: frame.width * 0.1)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        
        label.center = self.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
