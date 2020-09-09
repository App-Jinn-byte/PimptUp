//
//  ViewMoreScreenViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 22/07/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class ViewMoreScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RequestsViewController {
            
            destinationViewController.isDealer = true
            
        }
    }

}
