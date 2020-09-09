//
//  SpecialistsListViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 15/06/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class SpecialistsListViewController: UIViewController {
    @IBOutlet weak var specialistListTV: UITableView!
    
    var obj: [list]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specialistListTV.delegate = self
        print(obj)
        if obj!.count == 0{
            specialistListTV.isHidden = true
        }
    }
}

extension SpecialistsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return obj!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialistCell") as! SpecialistListTableViewCell
        cell.cellObj = obj![indexPath.row]
        cell.setData()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
  
}
