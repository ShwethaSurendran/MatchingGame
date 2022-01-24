//
//  ViewModel.swift
//  MatchCards
//
//  Created by Shwetha Surendran on 23/01/22.
//

import UIKit

struct ViewModel {
    
    var images: [String] {
        //1...10 denotes imagenames that are stored in Assets file
        var array: [String] = []
        for index in 1...10 {
            array.append(String(index))
            array.append(String(index))
        }
        array.shuffle()
        return array
    }
    
    func getScoreTitle(matchedCardIndexes: [Int]) -> NSMutableAttributedString {
        let score = (matchedCardIndexes.count/2) * 10
        let scoreTitle = Constants.youHaveScored + "\(score)" + Constants.marks
        let attributedScoreTitle = getAttributedString(from: scoreTitle, withAttributesInTheRangeOf: "\(score)")
        return attributedScoreTitle
    }
    
    func getTotalMovesTitle(totalMoves: Int)-> NSMutableAttributedString {
        let totalMovesTitle = Constants.totalMoves + " : \(totalMoves)"
        return getAttributedString(from: totalMovesTitle, withAttributesInTheRangeOf: "\(totalMoves)")
    }
    
    func getAttributedString(from string: String, withAttributesInTheRangeOf subString: String)-> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString.init(string:string)
        let nsRange = NSString(string: string).range(of: subString, options: String.CompareOptions.caseInsensitive)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font: Constants.Font.markerFelt as Any], range: nsRange)
        return attributedString
    }
    
}
