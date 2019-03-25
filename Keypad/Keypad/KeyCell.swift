//
//  KeyCell.swift
//  Keypad
//
//  Created by Onur Işık on 22.03.2019.
//  Copyright © 2019 Onur Işık. All rights reserved.
//

import UIKit

class KeyCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : customBGColor
            numberLabel.textColor = isHighlighted ? .white : .darkGray
            wordLabel.textColor = isHighlighted ? .white : .darkGray
        }
    }
    var isEmptyButton: Bool = false {
        didSet {
            if isEmptyButton {
                isHidden = true
            }
        }
    }
    var isCallButton: Bool = false {
        didSet {
            if isCallButton {
                backgroundImage.image = UIImage(named: "call")
            }
        }
    }
    var isRemoveButton: Bool = false {
        didSet {
            if isRemoveButton {
                backgroundImage.image = UIImage(named: "backspace")
            }
        }
    }
    
    var numberLabel = UILabel()
    var wordLabel = UILabel()
    var backgroundImage = UIImageView()
    let customBGColor = UIColor.init(white: 0.9, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = customBGColor
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.size.width/2
        
        numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height / 2))
        numberLabel.font = .systemFont(ofSize: self.frame.width * 0.4)
        numberLabel.textColor = .darkGray
        numberLabel.textAlignment = .center
        
        wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height / 2))
        wordLabel.font = .boldSystemFont(ofSize: self.frame.width * 0.2)
        wordLabel.textColor = .darkGray
        wordLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [numberLabel, wordLabel])
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 0
        self.contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: self.contentView.frame.width - 20),
            stackView.heightAnchor.constraint(equalToConstant: self.contentView.frame.height - 20),
            stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
            ])
        
        backgroundImage = UIImageView(frame: self.frame)
        backgroundImage.contentMode = .scaleAspectFit
        addSubview(backgroundImage)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            backgroundImage.widthAnchor.constraint(equalToConstant: self.contentView.frame.width),
            backgroundImage.heightAnchor.constraint(equalToConstant: self.contentView.frame.height),
            backgroundImage.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
