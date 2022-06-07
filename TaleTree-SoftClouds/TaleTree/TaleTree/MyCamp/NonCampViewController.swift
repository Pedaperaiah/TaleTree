//
//  NonCampViewController.swift
//  TaleTree
//
//  Created by UFL on 28/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class NonCampViewController: UIViewController {
    
    @IBOutlet var moreCampBtn: UIButton!
    
    var  leftButton :UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Get Camp Information"
        
        leftButton = UIButton(type: .custom)
        //set image for button
        leftButton!.setImage(UIImage(named: "returnBtnImage.png"), for: .normal)
        //add function for button
        leftButton!.addTarget(self, action: #selector(nnbackAction), for: .touchUpInside)
        //set frame
        leftButton!.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        
        let barButton = UIBarButtonItem(customView: leftButton!)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            moreCampBtn.layer.cornerRadius = moreCampBtn.frame.height/2
            moreCampBtn.layer.borderWidth = 0.0
            moreCampBtn.layer.masksToBounds = true
        // print("iPad style UI")
        case .phone:
            moreCampBtn.layer.cornerRadius = moreCampBtn.frame.height/2
            moreCampBtn.layer.borderWidth = 0.0
            moreCampBtn.layer.masksToBounds = true
        //  print("iPhone and iPod touch style UI")
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
    }
    // MARK: - Button Events..
    @IBAction func moreCampBtnActn(_ sender: Any) {
        
        SVProgressHUD.show()
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "NonCampDetailsViewController") as! NonCampDetailsViewController
        // self.navigationController?.pushViewController(vc, animated: true)
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func nnbackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
