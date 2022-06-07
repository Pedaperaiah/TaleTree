//
//  SendFeedBackViewController.swift
//  SampleApplication
//
//  Created by apple on 25/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class SendFeedBackViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var displayTextView: UITextView!
    @IBOutlet weak var charactersCountLbl: UILabel!
    @IBOutlet weak var requiredLbl: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    var  button :UIButton?
    let maxLenghth = 500
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requiredLbl.isHidden = true
        
        displayTextView.delegate = self
        displayTextView.setPlaceholder()
        // Do any additional setup after loading the view.
        
        hideKeyboardWhenTappedAround()
        
        // Getting device information wheather ipad or iphone.
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            
            titleLbl.font = titleLbl.font.withSize(22)
            submitButton.titleLabel?.font = .systemFont(ofSize: 22)
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: navigationView.frame.size.height-1, width: navigationView.frame.width + 400, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            navigationView.layer.addSublayer(bottomBorder)
        case .phone:
            titleLbl.font = titleLbl.font.withSize(20)
            submitButton.titleLabel?.font = .systemFont(ofSize: 20)
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
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        charactersCountLbl.text = "\(textView.text.count)" + "/500"
        
       // print(textView.text.count)
        if textView.text.count == 0
        {
            textView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            textView.layer.borderWidth = 1
            textView.layer.cornerRadius = 10
            textView.clipsToBounds = true
            requiredLbl.isHidden = false
        }
        else
        {
            textView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            textView.layer.borderWidth = 1
            requiredLbl.isHidden = true
            textView.layer.cornerRadius = 10
            textView.clipsToBounds = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        charactersCountLbl.text = "0/500"
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Text view method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= maxLenghth
    }
    // MARK: - Custom button events..
    @IBAction func submittButtonTapped(_ sender: Any) {
        
        if displayTextView.text.count == 0
        {
            requiredLbl.isHidden = false
            
            displayTextView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            displayTextView.layer.borderWidth = 1
            displayTextView.layer.cornerRadius = 10
            displayTextView.clipsToBounds = true
        }else
        {
            
            displayTextView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            displayTextView.layer.borderWidth = 1
            
            displayTextView.layer.cornerRadius = 10
            displayTextView.clipsToBounds = true
            sendFeedBackAPICall()
        }
        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func saveButtonTapped() {
        
        sendFeedBackAPICall()
    }
    
    // MARK: Toste Method...
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        toastLabel.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4901960784, blue: 1, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        //    toastLabel.font = UIFont(name: "SF Pro Text Semibold", size: 15.0)
        ///   toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4;
        toastLabel.clipsToBounds  =  true
        toastLabel.contentMode = .bottom
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 30))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        //   label.font = UIFont(name: "SF Pro Text Semibold", size: 20.0)
        
        label.text = message
        label.alpha = 1.0
        label.layer.cornerRadius = 4;
        label.clipsToBounds  =  true
        toastLabel.addSubview(label)
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // MARK: -  API Call Method...
    func sendFeedBackAPICall()
    {
        SVProgressHUD.show()
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
      //  print(API.sendFeedback)
        
        let url = URL(string: API.sendFeedback)!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        
        let eTextStr = displayTextView.text!
        let postString = "{\"text\":\"\(eTextStr)\"}"
      //  print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    if Reachability.isConnectedToNetwork(){
                        
                    }else{
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.showAlertView(title: "", msg: "No Network Connection")
                            
                        }
                    }
                    
                    return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    // print(json)
                    
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        
                        self.showToast(message: "Thank you for submitting your feedback!")
                        let duration: Double = 1
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                        
                    }
                    
                }
                else
                {
                    //  print("json error")
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Uh oh...", message: "Something went wrong. Please try again.", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "Got it", style: .default, handler: { action in
                            
                            alert.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(ok)
                        
                        self.present(alert, animated: true)
                        
                    }
                    
                    
                    
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
            
        }
        
        task.resume()
    }
}
// MARK: - Extension methods
extension UITextView{
    
    func setPlaceholder() {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your feedback here"
        placeholderLabel.font = UIFont.systemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    
    
}
