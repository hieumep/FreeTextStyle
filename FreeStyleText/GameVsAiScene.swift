//
//  GameVsAiScene.swift
//  FreeStyleText
//
//  Created by Hieu Vo on 5/21/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import SpriteKit

class GameVsAiScene : SKScene {
    
    
    let padding : CGFloat = 14.4
    let tileWidth : CGFloat = 72
    
    var continueGameWhen2048 = false
    
    var playerScore = 0 {
        didSet{
            playerScoreText.text = "\(playerScore)"
        }
    }
    
    var bg : SKSpriteNode!
    var arrayNodes = Array2D<SKSpriteNode>(columns: 4, rows: 4)
    var newGame = true
    var boardGame = BoardGame()
    var swipeAbleFlag = true
    
    var AIScore = 0 {
        didSet{
            AIScoreText.text = "\(AIScore)"
            //UserDefaults.standard.set(bestScore, forKey: "bestScore")
        }
    }
    
    let playerScoreText = SKLabelNode(text: "0")
    let AIScoreText = SKLabelNode(text: "0")
    let highestNode = SKSpriteNode(imageNamed: "Node_Bg_8")
    var continueButton : SKSpriteNode?
    var newGameButton : SKSpriteNode?
    var continueSceneNode : SKSpriteNode?
    var menuButton : SKSpriteNode?
    var playerTextureBg = SKTexture(image: #imageLiteral(resourceName: "Player_Bg_Select"))
    var AITextureBg = SKTexture(image: #imageLiteral(resourceName: "AI_Bg"))
    var playerFlag = true {
        didSet {
            if playerFlag {
                playerTextureBg = SKTexture(image: #imageLiteral(resourceName: "Player_Bg_Select"))
                AITextureBg = SKTexture(image: #imageLiteral(resourceName: "AI_Bg"))
            }else {
                playerTextureBg = SKTexture(image: #imageLiteral(resourceName: "Player_Bg"))
                AITextureBg = SKTexture(image: #imageLiteral(resourceName: "AI_Bg_Select"))
            }
        }
    }
    var playerBg : SKSpriteNode!
    var AIBg : SKSpriteNode!
    
    init(size: CGSize, newGame : Bool) {
        playerBg = SKSpriteNode(texture: playerTextureBg)
        AIBg = SKSpriteNode(texture: AITextureBg)
        super.init(size: size)
        self.newGame = newGame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //self.backgroundColor = SKColor.white
        setupBackground()
        setupNumberNodes()
        setupSwipeGesture()
        setupHighestNode()
        setupScoreBoard()
        if newGame {
            beginGame()
        }else {
//            if let gameState = loadGameState(){
//                boardGame.loadGame = true
//                boardGame.score = gameState.score
//                boardGame.highestNode = gameState.highestNode
//                score = gameState.score
//                highestNodeNumber = gameState.highestNode
//                loadPauseGame(gameState.gameArray)
//            }
        }
    }
    
    //check Load Game State
    func loadGameState() -> GameState?{
        if let data = UserDefaults.standard.object(forKey: "gameState") as? Data {
            let gameState = NSKeyedUnarchiver.unarchiveObject(with: data) as? GameState
            return gameState
        }
        return nil
    }
    
    //load pause game
    func loadPauseGame(_ gameArray : Array2D<NumberNode>){
        for column in 0 ..< gameArray.columns {
            for row in 0 ..< gameArray.rows {
                if let node = gameArray[column, row] {
                    if node.number > 0 {
                        boardGame.gameArray[node.column, node.row] = node
                        animateNewNode(node: node)
                    }
                }
            }
        }
        //  boardGame.printArray()
    }
    
    //load begin game with 2 node random
    func beginGame() {
        for _ in 0 ..< 2 {
            if let numNode = boardGame.randomNumberNode() {
                boardGame.gameArray[numNode.column, numNode.row] = numNode
                animateNewNode(node: numNode)
            }
        }
    }
    
    //setup swipe Gesture {
    func setupSwipeGesture(){
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(gesture:)))
        swipeGestureLeft.direction = .left
        view?.addGestureRecognizer(swipeGestureLeft)
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(gesture:)))
        swipeGestureRight.direction = .right
        view?.addGestureRecognizer(swipeGestureRight)
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(gesture:)))
        swipeGestureUp.direction = .up
        view?.addGestureRecognizer(swipeGestureUp)
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(gesture:)))
        swipeGestureDown.direction = .down
        view?.addGestureRecognizer(swipeGestureDown)
    }
    
    // func detect Swipe
    func swipeAction(gesture : UISwipeGestureRecognizer){
        var (array, score) : ([[NumberNode]], Int) = ([[]], 0)
        if swipeAbleFlag {
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.left :
                print("left")
                (array,score) = boardGame.swipeBoard(moveDirection: .left)
            case UISwipeGestureRecognizerDirection.right :
                print("right")
                (array,score) = boardGame.swipeBoard(moveDirection: .right)
            case UISwipeGestureRecognizerDirection.up :
                print("up")
                (array,score) = boardGame.swipeBoard(moveDirection: .up)
            //  animateMoveNode(array: array,score: score)
            case UISwipeGestureRecognizerDirection.down :
                print("down")
                (array,score) = boardGame.swipeBoard(moveDirection: .down)
            default :
                print("default")
            }
            if !array.isEmpty {
                animateMoveNode(array: array,score: score)
            }
        }
    }
    
    
    //setup background
    func setupBackground(){
        let bgTexture = SKTexture(image: #imageLiteral(resourceName: "Background"))
        bg = SKSpriteNode(texture: bgTexture, color: .white, size: bgTexture.size())
        bg.position = CGPoint(x: 0, y: -60)
        bg.zPosition = -2
        addChild(bg)
        
    }
    
    //setup cac node nen
    func setupNumberNodes(){
        let boardNode = boardGame.gameArray
        for column in 0 ..< 4 {
            for row in 0 ..< 4 {
                let numberNode = boardNode[column,row]
                let skNode = SKSpriteNode(texture: numberNode?.texture, size: numberNode!.texture.size())
                skNode.position = pointAt(column: column, row: row)
                skNode.zPosition = -1
                addChild(skNode)
                
            }
        }
    }
    
    //setup highest Node
    func setupHighestNode (){
       // highestNode.size = CGSize(width: 108, height: 108)
        //highestNode.zPosition = 0
       // let width = -bg.size.width / 2 + 54
       // highestNode.position = CGPoint(x:0 , y: bg.size.height/2 + 60 )
       // addChild(highestNode)
        
        menuButton = SKSpriteNode(imageNamed: "MenuButton")
        menuButton?.zPosition = 3
        menuButton?.position = CGPoint(x: 0, y: bg.size.height/2 + 60)
        addChild(menuButton!)
    }
    
    //setup scoreBoard
    func setupScoreBoard(){
        let width = -bg.size.width / 2 + 54
        // setup Player Side
        playerBg.zPosition = 3
        playerBg.position = CGPoint(x: width, y: menuButton!.position.y + 29)
        addChild(playerBg)        
        let score_bg = SKSpriteNode(imageNamed: "Score_Bg")
        score_bg.position = CGPoint(x: width, y: bg.size.height/2 + 32)
        addChild(score_bg)
        playerScoreText.zPosition = 3
        playerScoreText.fontName = "Arial"
        playerScoreText.fontSize = 25
        playerScoreText.horizontalAlignmentMode = .center
        playerScoreText.verticalAlignmentMode = .center
        score_bg.addChild(playerScoreText)
        
        
        //setup AI Side
       // AIBg = SKSpriteNode(texture: AITextureBg)
        AIBg.zPosition = 3
        AIBg.position = CGPoint(x: -width, y: menuButton!.position.y + 29)
        addChild(AIBg)
        let bestScore_Bg = SKSpriteNode(imageNamed: "bestScore_Bg")
        bestScore_Bg.position = CGPoint(x: -width, y: bg.size.height/2 + 32)
        addChild(bestScore_Bg)
        AIScoreText.zPosition = 3
        AIScoreText.fontName = "Arial"
        AIScoreText.fontSize = 25
        AIScoreText.verticalAlignmentMode = .center
        AIScoreText.horizontalAlignmentMode = .center
        bestScore_Bg.addChild(AIScoreText)
    }
    
    // Convert Int to CGPoint
    func pointAt(column : Int, row : Int) -> CGPoint{
        let anchorX : CGFloat = -bg.size.width / 2 + tileWidth / 2
        let anchorY : CGFloat = -bg.size.height / 2 - 60 + tileWidth / 2
        let position = CGPoint(x: anchorX + padding + (tileWidth + padding) * CGFloat(row) , y: anchorY + padding + (padding + tileWidth) * CGFloat(column) )
        return position
    }
    
    func animateNewNode(node : NumberNode){
        let position = pointAt(column: node.column, row: node.row)
        let size = node.texture.size()
        let skNode = SKSpriteNode(texture: node.texture, size: node.texture.size())
        skNode.size = CGSize(width: size.width / 4, height: size.height / 4)
        let skAction = SKAction.scale(to: size, duration: 0.25)
        skNode.position = position
        skNode.zPosition = 1
        arrayNodes[node.column,node.row] = skNode
        addChild(skNode)
        skNode.run(SKAction.sequence([skAction, SKAction.wait(forDuration: 0.25)])){
            
            self.swipeAbleFlag = true
            // check node moi hien ra va ko move duoc xung quanh, va node day bang thi se het game
            if !self.boardGame.canMove() && self.boardGame.isFull() {
                print("End game")
//                let scene = EndGameScene(size: self.size, isWin: self.continueGameWhen2048, highestNodeNumber : self.highestNodeNumber)
//                let reveal = SKTransition.doorsCloseVertical(withDuration: 1.0)
//                self.view?.presentScene(scene, transition: reveal)
            } else {
                print("Continue game")
                if !self.playerFlag {
                    if let AIDirection = self.boardGame.processAI(){
                        let (AIarray, AIscore) = self.boardGame.swipeBoard(moveDirection: AIDirection)
                        if !AIarray.isEmpty{
                            self.animateMoveNode(array: AIarray, score: AIscore)
                        }else {
                            print("khong co nuoc di")
                        }
                    } else {
                        print("no move")
                    }
                }
            }
        }
    }
    
    //animate when we swipe screen
    func animateMoveNode(array : [[NumberNode]],score : Int){
        swipeAbleFlag = false
        let delay : CGFloat = 0
        var duration = TimeInterval(0)
        var distance = 0
        for subArray in array {
            for (_, node) in subArray.enumerated() {
                
                let skNode = arrayNodes[node.column, node.row]
                let newPosition = pointAt(column: node.newColumn, row: node.newRow)
                if node.column == node.newColumn {
                    distance = abs(node.newRow - node.row)
                }else {
                    distance = abs(node.newColumn - node.column)
                }
                // print("distance is \(distance)")
                duration = TimeInterval(delay + CGFloat(distance) * 0.15)
                if node.mix {
                    let moveAction = SKAction.move(to: newPosition, duration: duration)
                    moveAction.timingMode = .easeOut
                    let fadeOutAction = SKAction.fadeOut(withDuration: 0.15)
                    fadeOutAction.timingMode = .easeOut
                    
                    skNode?.run(SKAction.sequence([moveAction, fadeOutAction,SKAction.removeFromParent()])){
                        self.boardGame.gameArray[node.column, node.row]?.mix = false
                    }
                    // animate when mix
                    let nextNode = self.arrayNodes[node.newColumn, node.newRow]
                    let newTexture = self.boardGame.gameArray[node.newColumn, node.newRow]?.texture
                    let size = nextNode!.size
                    let animateTexture = SKAction.animate(with: [newTexture!], timePerFrame: 0.1)
                    let ZoomOut = SKAction.scale(to: CGSize(width: size.width * 1.2, height: size.height * 1.2), duration: 0.1)
                    let ZoomIn = SKAction.scale(to: size, duration: 0.1)
                    nextNode?.run(SKAction.sequence([SKAction.wait(forDuration: duration), animateTexture, ZoomOut,ZoomIn])){
                    }
                }else {
                    skNode!.run(SKAction.move(to: newPosition, duration: duration ))
                    self.arrayNodes[node.newColumn,node.newRow] = skNode
                    self.arrayNodes[node.column, node.row] = nil
                }
            }
        }
        run(SKAction.wait(forDuration: duration + 0.5)){
            self.swipeAbleFlag = true
            self.removeAllActions()
            if self.playerFlag {
                self.playerScore += score
            } else {
                self.AIScore += score
            }
            self.playerFlag = !self.playerFlag
            self.playerBg.texture = self.playerTextureBg
            self.AIBg.texture = self.AITextureBg
            if !self.boardGame.isFull() {
                if self.boardGame.is2048 {
                    if self.continueGameWhen2048 {
                        if !array.isEmpty {
                            let newNode = self.boardGame.randomNumberNode()
                            self.animateNewNode(node: newNode!)
                        }
                    }else {
                        self.continueScene()
                    }
                    
                }else {
                    if !array.isEmpty {
                        let newNode = self.boardGame.randomNumberNode()
                        self.animateNewNode(node: newNode!)
                    }
                }
            }
            
            //self.run(SKAction.wait(forDuration: 0.5)){
                
            //}
        }
    }
    
    // setup continue sceen when player get 2048
    func continueScene(){
        continueSceneNode = SKSpriteNode(imageNamed: "Continue_Bg")
        continueSceneNode?.zPosition = 5
        continueSceneNode?.position = CGPoint(x: 0, y: 0)
        addChild(continueSceneNode!)
        
        //setup Continue game
        continueButton = SKSpriteNode(imageNamed: "ContinueButton")
        continueButton?.zPosition = 1
        continueButton?.position = CGPoint(x: 0, y: -((continueSceneNode?.size.height)! / 6))
        continueSceneNode?.addChild(continueButton!)
        
        //setup New game
        newGameButton = SKSpriteNode(imageNamed: "NewGameButton")
        newGameButton?.zPosition = 1
        newGameButton?.position = CGPoint(x: 0 , y: -(continueButton!.size.height * 2 + 20))
        continueSceneNode?.addChild(newGameButton!)
        
        //setup 2048 node
        let node2048 = SKSpriteNode(imageNamed: "Node_Bg_2048")
        node2048.zPosition = 1
        node2048.position = CGPoint(x: 0, y: node2048.size.height)
        continueSceneNode?.addChild(node2048)
        
        let size2048 = node2048.size
        let scaleBigger = SKAction.scale(to: CGSize(width : size2048.width * 2, height : size2048.height * 2), duration: 1)
        let scaleSmaller = SKAction.scale(to: CGSize(width: size2048.width / 2, height: size2048.height / 2), duration: 1)
        node2048.run(SKAction.repeatForever(SKAction.sequence([scaleBigger,scaleSmaller])))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        
        if let continueButton = continueButton {
            if continueButton.contains(touchLocation!) {
                continueSceneNode?.removeFromParent()
                self.continueGameWhen2048 = true
            }
        }
        
        if let newGameButton = newGameButton{
            if newGameButton.contains(touchLocation!) {
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size, newGame: true)
                view?.presentScene(gameScene, transition: reveal)
            }
        }
        
        if let menuButton = menuButton {
            if menuButton.contains(touchLocation!){
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                let menuScene = MenuScene(size: self.size)
                view?.presentScene(menuScene, transition: reveal)
            }
        }
    }
    
    func animateScore(node : SKSpriteNode){
        let size = node.size
        let scaleBigger = SKAction.scale(to: CGSize(width: size.width * 1.5, height: size.height * 1.5), duration: 0.3)
        let scaleSmaller = SKAction.scale(to: size, duration: 0.3)
        node.run(SKAction.sequence([scaleBigger,scaleSmaller]))
    }
    
    func processAI() -> moveDirection {
        var direction = moveDirection.left
        let copyBoard = BoardGame()
        var maxScore = 0
        copyArray(array: boardGame.gameArray, arrayCopy: copyBoard.gameArray)
        let (_ , scoreLeft) = copyBoard.swipeBoard(moveDirection: .left)
        if scoreLeft >= maxScore {
            direction = .left
            maxScore = scoreLeft
        }
        let (_, scoreRight) = copyBoard.swipeBoard(moveDirection: .right)
        if scoreRight >= maxScore {
            direction = .right
            maxScore = scoreRight
        }
        copyArray(array: boardGame.gameArray, arrayCopy: copyBoard.gameArray)
        let (_, scoreUp) = copyBoard.swipeBoard(moveDirection: .up)
        if scoreUp >= maxScore {
            direction = .up
            maxScore = scoreUp
        }
        copyArray(array: boardGame.gameArray, arrayCopy: copyBoard.gameArray)
        let (_, scoreDown) = copyBoard.swipeBoard(moveDirection: .down)
        if scoreDown >= maxScore {
            direction = .down
            maxScore = scoreDown
        }
        return direction

    }
    
    // Ham dung de copy value cua mang
    func copyArray(array : Array2D<NumberNode>, arrayCopy : Array2D<NumberNode>){
        for column in 0 ..< array.columns {
            for row in 0 ..< array.rows {
                arrayCopy[column,row]?.number = (array[column, row]?.number)!
            }
        }
    }
}

