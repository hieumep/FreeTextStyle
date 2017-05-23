//
//  Player.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/22/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import GameplayKit

class Player : NSObject, GKGameModelPlayer {
    enum Values : Int {
        case player = 1
        case AI = 2
    }
    
    var playerId: Int
    var value : Values
    var score = 0
    
    init(_ value : Values){
        self.playerId = value.rawValue
        self.value = value
        super.init()
    }
    static var allPlayers = [Player(.player), Player(.AI)]
    
    var opponent : Player {
        if value == .player {
            return Player.allPlayers[1]
        }else {
            return Player.allPlayers[2]
        }
    }
}
