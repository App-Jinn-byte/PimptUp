//
//  LoginAsViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 19/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class LoginAsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func customerBtn(_ sender: Any) {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        secondViewController.userTypeId = 3
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    @IBAction func dealerBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Login") as? LoginViewController
        vc?.userTypeId = 2
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func specialistBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Login") as? LoginViewController
        vc?.userTypeId = 4
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
