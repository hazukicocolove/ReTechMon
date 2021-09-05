//
//  BattleViewController.swift
//  ReTechmon
//
//  Created by Hazuki Tamura on 2021/09/06.
//

import UIKit

class BattleViewController: UIViewController {

    @IBOutlet var playerNameLabel:UILabel!
    @IBOutlet var playerImageView:UIImageView!
    @IBOutlet var playerHPLabel:UILabel!
    @IBOutlet var playerMPLabel:UILabel!
    @IBOutlet var playerTPLabel:UILabel!
    
    let techMonManager = TechMonManager.shared
    
    @IBOutlet var enemyNameLabel:UILabel!
    @IBOutlet var enemyImageView:UIImageView!
    @IBOutlet var enemyHPLabel:UILabel!
    @IBOutlet var enemyMPLabel:UILabel!
    
    var playerHP = 100
    var playerMP = 0
    var enemyHP = 200
    var enemyMP = 0
    
    var gameTimer: Timer!
    var isPayerAttackAvailable : Bool = true
    
    var player: Character!
    var enemy: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(playerHP)/100"
        playerMPLabel.text = "\(playerMP)/20"
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemyHP)/200"
       enemyMPLabel.text = "\(enemyMP)/35"

        //gamestart
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil ,repeats: true)
        gameTimer.fire()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame(){
        playerHP += 1
        if playerMP >= 20{
            isPayerAttackAvailable = true
            playerMP = 20
        }else{
            isPayerAttackAvailable = false
        }
        
        enemyMP += 1
        if enemyMP >= 35{
            enemyAttack()
            enemyMP = 0
        }
        
        playerMPLabel.text = "\(playerMP)/20"
        enemyMPLabel.text = "\(enemyMP)/35"
        
        
    }
    
    func enemyAttack(){
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 20
        playerHPLabel.text = "\(playerHP)/100"
        if playerHP <= 0{
            finishBattle(vanishImageView:playerImageView, isPlayerWin: false)
        }
    }
    
    
    func updateUI(){
        playerHPLabel.text = "\(player.currentHP)/\(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP)/\(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP)/\(player.maxTP)"
        
        enemyHPLabel.text = "\(enemy.currentHP)/\(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP)/\(enemy.maxMP)"
    }
    
    func finishBattle(vanishImageView:UIImageView,isPlayerWin:Bool){
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPayerAttackAvailable = false
        
        var finishMessage:String = ""
        if isPlayerWin{
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝ちや"
        }else {
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北"
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)}))
        present(alert,animated: true,completion: nil)
    present(alert, animated:true, completion:nil)
    }
    
    func uodateUI(){
        playerHPLabel.text = "\(player.currentHP)/\(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP)/\(player.maxMP)"
        enemyHPLabel.text = "\(enemy.currentHP)/\(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP)/\(enemy.maxMP)"
    }
    
    func judgeBattle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func attackAction(){
        if isPayerAttackAvailable{
        //   techMonManager.damageAnimation(imageView:"battlebg.png")
         //   techMonManager.playSE(fileName: "SE_attack")
            
            enemy.currentHP += 10
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
       
        player.currentMP = 0
        judgeBattle()
        } }
    
    @IBAction func tameruAction(){
        if isPayerAttackAvailable{
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP {
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            
        }
    }
    
    @IBAction func fireAction(){
        if isPayerAttackAvailable && player.currentTP >= 40{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
            }
            player.currentMP = 0
            judgeBattle()
        }
    }
}
