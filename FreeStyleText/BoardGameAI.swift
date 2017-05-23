//
//  BoardGameAI.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/22/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

//import Foundation
//import GameplayKit
//
//class BoardGameAI : BoardGame {
//    
//    override init(){
//        super.init()
//    }
//    
//    // make AI Thinking
//    func AIMove() -> moveDirection {
//        var direction = moveDirection.left
//        var copyBoard = self.copy() as! BoardGameAI
//        var maxScore = 0
//        let (_ , scoreLeft) = copyBoard.swipeBoard(moveDirection: .left)
//        if scoreLeft >= maxScore {
//            direction = .left
//            maxScore = scoreLeft
//        }
//        copyBoard = self.copy() as! BoardGameAI
//        let (_, scoreRight) = copyBoard.swipeBoard(moveDirection: .right)
//        if scoreRight >= maxScore {
//            direction = .right
//            maxScore = scoreRight
//        }
//        copyBoard = self.copy() as! BoardGameAI
//        let (_, scoreUp) = copyBoard.swipeBoard(moveDirection: .up)
//        if scoreUp >= maxScore {
//            direction = .up
//            maxScore = scoreUp
//        }
//        copyBoard = self.copy() as! BoardGameAI
//        let (_, scoreDown) = copyBoard.swipeBoard(moveDirection: .down)
//        if scoreDown >= maxScore {
//            direction = .down
//            maxScore = scoreDown
//        }
//        return direction
//    }
//
//       
//}
