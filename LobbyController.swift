//
//  LobbyController.swift
//  TechMon
//
//  Created by Hazuki Tamura on 2021/09/06.
//

import UIKit

class LobbyController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel : UILabel!
    
    let techMonManeger = techMonManeger.shared
    
    var stamina: Int = 100
    var staminaTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "勇者"
        staminaLabel.text = "\(stamina)/100"
        
        staminaTimer = Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(updateStaminaValue),
            userInfa: nil,
            repeats:true)
        staminaTimer.fire()
        // Do any additional setup after loading the view.
    }
    
  //ロビー見える時
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        techMonManeger.playBGM(fileName:"lobby")
    }
    
    //ロビー見えなくなる時
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        techMonManeger.stopBGM(fileName:"lobby")
    }
    
    @IBAction func toBattle(){
        if stamina >= 50 {
            stamina -= 50
            staminaLabel.text = "\(stamina)/100"
            performSegue(withIdentifier:"toBattle",sender:nil)
        }else{
            let alert = UIAlertController(
                title:"バトルに行けないよ",
                message:"スタミナ貯めろ",
                preferredStyle: .alert)
    }
    
    @objc func updateStaminaValue(){
        if stamina < 100{
            stamina +=  1
            staminaLabel.text = "\(stamina)/100"
        }
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

}
