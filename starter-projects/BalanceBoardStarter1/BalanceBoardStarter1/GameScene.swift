//
//  GameScene.swift
//  BalanceBoardStarter1
//
//  Created by Denise Nepraunig on 20.02.18.
//  Copyright © 2018 Denise Nepraunig. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "bear")
    let playerSpeed: CGFloat = 2500
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0  // delta time since last rendering
    
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    let bonus = SKSpriteNode(imageNamed: "fish")
    
    // anchor point of the scene is 0.5 and 0.5
    let playerMaxY: CGFloat = 400 // roughly half of the Apple TV height - player height
    let playerMaxX: CGFloat = 800 // roughly half of the Apple TV width - player width
    
    // these values are used for randomly placing the bonus
    let randomXBonus = GKRandomDistribution(lowestValue: 100, highestValue: 500)
    let randomYBonus = GKRandomDistribution(lowestValue: 50, highestValue: 300)
    let randomTrueFalse = GKRandomDistribution(lowestValue: 0, highestValue: 1)
    
    override func didMove(to view: SKView) {
        
        player.name = "player"
        
        // anchor point of the scene is 0.5 and 0.5
        player.position.x = 0
        player.position.y = 0
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.categoryBitMask = 1 // player
        
        addChild(player)
        
        createBackground()
        createSnow()
        
        createScoreLabel()
        score = 0
        
        createBonus()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // I stored the reference to the gamePad in the AppDelegate
        // which acts like a global variable
        
        // I did this because I could re-use the game pad in other scenes
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let gamePad = appDelegate.gamePad,
            let motion = gamePad.motion {
            
            if lastUpdateTime > 0 {
                dt = currentTime - lastUpdateTime
            } else {
                dt = 0
            }
            lastUpdateTime = currentTime
            
            // you could also do just '* 50' if you do not care about the variable frame rate
            player.position.x += CGFloat(motion.gravity.x) * playerSpeed * CGFloat(dt)
            player.position.y += CGFloat(motion.gravity.y) * playerSpeed * CGFloat(dt)
            
            checkPlayerBoundaries()
        }
    }
    
    func checkPlayerBoundaries() {
        
        if player.position.y < -playerMaxY {
            player.position.y = -playerMaxY
        } else if player.position.y > playerMaxY {
            player.position.y = playerMaxY
        }
        
        if player.position.x < -playerMaxX {
            player.position.x = -playerMaxX
        } else if player.position.x > playerMaxX {
            player.position.x = playerMaxX
        }
    }
    
    func createBackground() {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        addChild(background)
    }
    
    func createSnow() {
    
        if let particles = SKEmitterNode(fileNamed: "Snow") {
    
            particles.position = CGPoint(x: 0, y: 0)
            particles.advanceSimulationTime(60)
            particles.zPosition = 10
            addChild(particles)
        }
    }
    
    // MARK: HUD
    func createScoreLabel() {
        
        scoreLabel.zPosition = 1000
        scoreLabel.position.y = 450
        scoreLabel.position.x = 750
        scoreLabel.fontColor = .gray
        addChild(scoreLabel)
    }
    
    // MARK: Bonus
    func createBonus(x: Int = 400, y: Int = 200) {
        
        bonus.position = CGPoint(x: x, y: y)
        bonus.name = "bonus"
        bonus.zPosition = 0
        
        bonus.physicsBody = SKPhysicsBody(texture: bonus.texture!, size: bonus.size)
        bonus.physicsBody?.contactTestBitMask = 1 // player
        
        addChild(bonus)
    }
    
    // MARK: Hit Testing
    func playerHit(_ node: SKNode) {
        
        if node.name == "bonus" {
            hitBonus(node)
        }
    }
    
    func hitBonus(_ node: SKNode) {
        
        score += 1
        
        // position the bonus in one of the four quadrants on the screen
        // always change the x quadrant, probably change y quadrant
        
        //   | 1 | 2 |
        //   | 3 | 4 |
        
        let x = node.position.x > 0 ? -randomXBonus.nextInt() : randomXBonus.nextInt()
        let y = randomTrueFalse.nextInt() > 0 ? -randomYBonus.nextInt() : randomYBonus.nextInt()
        
        node.removeFromParent()
        
        createBonus(x: x, y: y)
    }
    
}

// MARK: SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // both nodes must exist
        guard let nodeA = contact.bodyA.node,
            let nodeB = contact.bodyB.node else {
                return
        }
        
        if nodeA == player {
            playerHit(nodeB)
        } else {
            playerHit(nodeA)
        }
    }
}
