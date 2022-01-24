//
//  CardCell.swift
//  MatchCards
//
//  Created by Shwetha Surendran on 20/01/22.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet weak var initialCardImageView: UIImageView!
    @IBOutlet weak var flippedCardImageView: UIImageView!
    
    override func awakeFromNib() {
        hideControls(false)
    }
    
    func hideControls(_ hide: Bool) {
        self.initialCardImageView.isHidden = hide
        self.flippedCardImageView.isHidden = !hide
    }
    
    func setupData(withImage imageName: String, currentIndex: Int, flippedCell: CardCell?, matchedCellIndexes: [Int]) {
        flippedCardImageView.image = UIImage(named: imageName)
        hideControls(flippedCell?.tag == currentIndex ? true : false)
        self.isHidden = (matchedCellIndexes.contains(currentIndex)) ? true : false
    }
    
    func flip(completion: @escaping(Bool)->Void) {
        animate(byFlippingInitialCard: flippedCardImageView.isHidden) {
            completion(!self.flippedCardImageView.isHidden)
        }
    }
    
    func animate(byFlippingInitialCard isFlip: Bool, completion: @escaping()->Void) {
        UIView.transition(with: initialCardImageView, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: {_ in
            self.hideControls(isFlip)
            completion()
        })
    }
    
}
