//
//  KeyPadViewController.swift
//  Keypad
//
//  Created by Onur Işık on 25.03.2019.
//  Copyright © 2019 Onur Işık. All rights reserved.
//


import UIKit

class KeyPadViewController: UIViewController {
    
    
    private var collectionView: UICollectionView!
    
    var isCalling: Bool = false
    var dialedScreenNumbers = String()
    private var cellSize: CGFloat = 0
    private var interSpacing: CGFloat = 0
    private var rightLeftPadding: CGFloat = 0
    
    private let cellIdentifier: String = "keyCell"
    private let reusableViewIdentifier: String = "keyScreen"
    
    private var screen: KeypadScreen?
    let numberList = [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]
    let wordList = [ "", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ", "", "+", ""]
    
    let bottomButtonsList = [ "", "", ""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(KeypadScreen.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: reusableViewIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    fileprivate func makeCall(withCell selectedCell: KeyCell) {
        
        UIView.animate(withDuration: 1.0, animations: {
            
            selectedCell.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/1.5))
            UIView.transition(with: selectedCell, duration: 0.7, options: .transitionCrossDissolve, animations: {
                selectedCell.backgroundImage.image = UIImage(named: "decline")
            }, completion: nil)
            
        }) { (_) in
            
            if let url = URL(string: "tel://\(self.dialedScreenNumbers)") {
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (_) in
                        self.isCalling = true
                    })
                    
                } else {
                    
                    let alert = UIAlertController.init(title: "Error",
                                                       message: "Cannot make call on Simulator, please try on real device.",
                                                       preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "Close", style: .default, handler: { (_) in
                        
                        self.disconnectCall(withCell: selectedCell)
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    fileprivate func disconnectCall(withCell selectedCell: KeyCell) {
        
        UIView.animate(withDuration: 1.0, animations: {
            
            selectedCell.transform = .identity
            UIView.transition(with: selectedCell, duration: 0.7, options: .transitionCrossDissolve, animations: {
                selectedCell.backgroundImage.image = UIImage(named: "call")
            }, completion: nil)
            
        }) { (_) in
            self.isCalling = false
        }
    }
}

extension KeyPadViewController:
            UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section > 0 { return bottomButtonsList.count }
        return numberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let keyCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! KeyCell
        
        if indexPath.section == 0 {
            keyCell.numberLabel.text = numberList[indexPath.item]
            keyCell.wordLabel.text = wordList[indexPath.item]
            
        } else {
            
            switch indexPath.item {
            case 0: keyCell.isEmptyButton = true
            case 1: keyCell.isCallButton = true
            case 2: keyCell.isRemoveButton = true
            default: break;
            }
        }
        
        return keyCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        rightLeftPadding = view.frame.width * 0.15
        interSpacing = view.frame.width * 0.1
        cellSize = (view.frame.width - 2 * rightLeftPadding - 2 * interSpacing) / 3
        return CGSize.init(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 16, left: rightLeftPadding, bottom: 16, right: rightLeftPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        self.screen = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reusableViewIdentifier, for: indexPath) as? KeypadScreen
        if indexPath.section == 0 {
            screen!.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        } else {
            screen!.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        return screen!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! KeyCell
        
        if indexPath.section < 1 {
            // One of number buttons pressed
            dialedScreenNumbers += selectedCell.numberLabel.text!
            screen!.label.text = dialedScreenNumbers
            
        } else {
            
            if indexPath.item == 1 {
                // Call button pressed
                if !isCalling && dialedScreenNumbers.count > 0 {
                    self.makeCall(withCell: selectedCell)
                } else {
                    self.disconnectCall(withCell: selectedCell)
                }
                
            } else if indexPath.item == 2 {
                // Remove button pressed
                dialedScreenNumbers = String(dialedScreenNumbers.dropLast())
                screen!.label.text = dialedScreenNumbers
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: self.view.frame.width, height: 150)
        } else {
            return CGSize.init(width: 0, height: 0)
        }
    }

}
