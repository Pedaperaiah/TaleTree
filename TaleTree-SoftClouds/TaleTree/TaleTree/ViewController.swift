//
//  ViewController.swift
//  TaleTree
//
//  Created by UFL on 16/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginTapBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginTapBtnActn(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
      //  self.present(vc, animated:true, completion:nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

