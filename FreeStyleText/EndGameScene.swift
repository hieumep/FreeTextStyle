//
//  EndGameScene.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/19/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import SpriteKit

class EndGameScene : SKScene {
    
    let winText = "Good Move! You Win!!!"
    let loseText =  "You lose  but never give up!!!"
    var winLabel = SKLabelNode()
    var loseLabel = SKLabelNode()
    var isWin : Bool
    var newButton : SKSpriteNode!
    
    init(size: CGSize, isWin : Bool) {
        self.isWin = isWin
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        winLabel.text = winText
        loseLabel.text = loseText
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
       // winLabel.physicsBody = SKPhysicsBody(rectangleOf: winLabel.frame.size)
       // winLabel.physicsBody?.isDynamic = false
       // winLabel.
        if isWin {
            animateWin()
        } else {
            animateLose()
        }
        setupNewButton()
    }
    
    //func animate win Label
    func animateWin(){
        winLabel.fontName = "Arial" // tim font moi
        winLabel.fontSize = 30
        winLabel.position = CGPoint(x: 0, y: 100)
        addChild(winLabel)
    }
    
    func animateLose(){
        loseLabel.fontName = "Arial" // tim font moi
        loseLabel.fontSize = 30
        loseLabel.position = CGPoint(x: 0, y: 100)
        addChild(loseLabel)
    }
    
    func setupNewButton() {
        newButton = SKSpriteNode(imageNamed: "NewGameButton")
        newButton.zPosition = 1
        newButton.position = CGPoint(x: 0 , y: 50 + newButton.size.height / 2)
        addChild(newButton)
    }
}
