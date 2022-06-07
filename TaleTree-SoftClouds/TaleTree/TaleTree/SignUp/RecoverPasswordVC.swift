//
//  RecoverPasswordVC.swift
//  TaleTree
//
//  Created by apple on 18/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit

class RecoverPasswordVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backToLogBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backToLogBtn.layer.cornerRadius = 23
        backToLogBtn.layer.borderWidth = 0.1
        backToLogBtn.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
// MARK: - Button Events...
    @IBAction func backBtnTapped(_ sender: Any) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
               self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func backToLogBtnTapped(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
