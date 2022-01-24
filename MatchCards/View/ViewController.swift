//
//  ViewController.swift
//  MatchCards
//
//  Created by Shwetha Surendran on 20/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gameCompletedAlertView: UIView!
    
    private var viewModel: ViewModel  = ViewModel()
    private var flippedCell: CardCell?
    private var totalMoves: Int = 0 {
        didSet {
            movesLabel.attributedText = viewModel.getTotalMovesTitle(totalMoves: totalMoves)
        }
    }
    private var matchedCardIndexes: [Int] = [] {
        didSet {
            scoreLabel.attributedText = viewModel.getScoreTitle(matchedCardIndexes: matchedCardIndexes)
        }
    }
    private var cardImages: [String] = [] {
        didSet{
            matchedCardIndexes = []
            totalMoves = 0
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        addTapGestureToGameCompletionAlert()
    }
    
    private func initialSetup() {
        cardImages = viewModel.images
    }
    
    private func showGameCompletionAlert() {
        if matchedCardIndexes.count == cardImages.count {
            UIView.transition(with: gameCompletedAlertView, duration: 1.0,
                              options: .transitionFlipFromBottom,
                              animations: { [weak self] in
                                self?.gameCompletedAlertView.isHidden = false
                              }, completion: {_ in
                                
                              })
        }
    }
    
    private func addTapGestureToGameCompletionAlert() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        gameCompletedAlertView.addGestureRecognizer(gesture)
    }
    
    @objc func onTap() {
        self.gameCompletedAlertView.isHidden = true
        initialSetup()
    }
    
    private func onClick(cell: CardCell, withIndex index: Int) {
        totalMoves += 1
        cell.flip { isFlipped in
            
            let flipped = isFlipped
            
            if self.flippedCell != nil, (self.flippedCell?.tag != index) {
                //there is already flipped card exists and it is not same as the currently clicked card
                if self.flippedCell?.flippedCardImageView.image == cell.flippedCardImageView.image {
                    self.onExistingFlippedCardMatchesWith(currentlyFlipped: cell, withIndex: index)
                }else {
                    self.onExistingFlippedCardNotMatchesWith(currentlyFlipped: cell)
                }
                self.flippedCell = nil
            }else {
                //there is no already flipped card exists.
                self.flippedCell = flipped == true ? cell : nil
            }
        }
    }
    
    ///  Previously flipped card matches with current one. Save cell indexes and set score.
    /// - Parameters:
    ///   - cell: Currently flipped cell
    ///   - cellIndex: Currently flipped cell index
    private func onExistingFlippedCardMatchesWith(currentlyFlipped cell: CardCell, withIndex cellIndex: Int) {
        sleep(UInt32(0.2))
        cell.isHidden = true
        self.flippedCell?.isHidden = true
        matchedCardIndexes.append(contentsOf: [cellIndex, (self.flippedCell?.tag ?? -1)])
        self.showGameCompletionAlert()
    }
    
    /// Previously flipped card not matches with current one.
    /// - Parameter cell: Currently flipped cell
    private func onExistingFlippedCardNotMatchesWith(currentlyFlipped cell: CardCell) {
        cell.flip{_ in}
        self.flippedCell?.flip{_ in}
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width - (Constants.GameScreenConfigurations.cellsPerRow - 1) * (Constants.GameScreenConfigurations.spaceBetweenCells)) / (Constants.GameScreenConfigurations.cellsPerRow)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath) as! CardCell
        cell.tag = indexPath.row
        cell.setupData(withImage: cardImages[indexPath.row], currentIndex: indexPath.row, flippedCell: flippedCell, matchedCellIndexes: matchedCardIndexes)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: CardCell = collectionView.cellForItem(at: indexPath) as! CardCell
        onClick(cell: cell, withIndex: indexPath.row)
    }
    
}


