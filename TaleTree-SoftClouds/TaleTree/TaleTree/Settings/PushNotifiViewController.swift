//
//  PushNotifiViewController.swift
//  TaleTree
//
//  Created by apple on 31/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit

class PushNotifiViewController: UIViewController {
    
    @IBOutlet weak var ONlBL: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var commentsLbl: UILabel!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ONlBL.isHidden = false
        switchButton.isOn = true
        // Getting device information wheather ipad or iphone.
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            
            titleLbl.font = titleLbl.font.withSize(22)
            doneButton.titleLabel?.font = .systemFont(ofSize: 22)
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: navigationView.frame.size.height-1, width: navigationView.frame.width + 400, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            navigationView.layer.addSublayer(bottomBorder)
        case .phone:
            doneButton.titleLabel?.font = .systemFont(ofSize: 20)
            titleLbl.font = titleLbl.font.withSize(20)
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: navigationView.frame.size.height-1, width: navigationView.frame.width , height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            navigationView.layer.addSublayer(bottomBorder)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    // MARK: - Custom button events..
    @IBAction func switchBtnTapped(_ sender: UISwitch) {
        
        if (sender.isOn == true){
            ONlBL.isHidden = false
        }
        else{
            ONlBL.isHidden = true
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
