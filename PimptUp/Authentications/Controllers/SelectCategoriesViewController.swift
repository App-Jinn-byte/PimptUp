//
//  SelectCategoriesViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 04/08/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
protocol categoriesProtocol {
    func sendName(catNames: [String])
    func sendId(catId: [Int])
}
class SelectCategoriesViewController: UIViewController {
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoriesTableView: UITableView!
    var delegate: categoriesProtocol?
    var usertype = 4
   
    var categoriesId = [Int]()
    var categoriesName = [String]()
    var specialistTypes:[specialist] = []
    var companiesId:[companies] = []
    //var delegate: categoriesProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(usertype)
        if(usertype == 5){
          navigationItem.title = "Select Companies"
          self.navigationController?.navigationBar.topItem?.title = "Select Companies"
            self.navigationbar.topItem?.title = "Select Companies"
        }
        // self.view.backgroundColor = .clear
        categoriesTableView.delegate = self
        if Reachability.isConnectedToInternet(){
        
            activityIndicator.startAnimating()
            if usertype == 4{
                getSpecialists()
            }
            else{
                getCompanies()
            }
            
        }
        else{
            Constants.Alert(title: "Connection Error", message: "Plz make sure you are connected to internet", controller: self)
            activityIndicator.stopAnimating()
        }
        doneBtn.layer.cornerRadius = doneBtn.frame.size.height/5
        doneBtn.clipsToBounds = true
        
        
    }
    func getCompanies(){
        APIRequests.GetComapnies(completion: APIRequestCompletedForComanies)
    }
    fileprivate func APIRequestCompletedForComanies(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let companies = try decoder.decode(CompaniesModelResponse.self, from: data)
                print(companies)
                companiesId = companies.companyList
                self.categoriesTableView.reloadData()
                activityIndicator.stopAnimating()
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Login Error", message: Constants.statusMessage ?? "", controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    func getSpecialists(){
        APIRequests.GetSpecialists(completion: APIRequestCompletedForSpecialists)
    }
    fileprivate func APIRequestCompletedForSpecialists(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let companies = try decoder.decode(SpecialistsCategoriesModel.self, from: data)
                print(companies)
                specialistTypes = companies.categorires
                print(specialistTypes)
                activityIndicator.stopAnimating()
                self.categoriesTableView.reloadData()
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Login Error", message: Constants.statusMessage ?? "", controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func getId(_ sender: Any) {
        if (usertype == 4){
        for cats in specialistTypes {
            if cats.isCheck == true{
                self.categoriesId.append(cats.SpecialistCategoryId)
            }
        }
        for cats in specialistTypes {
            if cats.isCheck == true{
                self.categoriesName.append(cats.Description ?? "nil")
            }
        }
        }
        else{
            for cats in companiesId {
                if cats.isCheck == true{
                    self.categoriesId.append(cats.CompanyId)
                }
            }
            for cats in companiesId {
                if cats.isCheck == true{
                    self.categoriesName.append(cats.Description ?? "nil")
                }
            }
        }
        helloPrint()
        self.delegate?.sendId(catId: categoriesId)
        self.delegate?.sendName(catNames: categoriesName)
        
        self.dismiss(animated: true, completion: nil)
        //        let vc = RegisterationViewController()
        //        vc.categoriesId = categoriesId
        //        vc.categoriesName = categoriesName
        //       self.performSegue(withIdentifier: "Back", sender: nil)
    }
    func helloPrint(){
        print(categoriesId)
        print(categoriesName)
        //        let vc = RegisterationViewController()
        //        vc.categoriesId = self.categoriesId
        //        vc.categoriesName = self.categoriesName
        
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //    {
    //        let vc = segue.destination as? RegisterationViewController
    //        vc?.categoriesName = self.categoriesName
    //        vc?.categoriesId = self.categoriesId
    //        vc?.controller = "categories"
    //    }
}
extension SelectCategoriesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usertype == 4{
        return specialistTypes.count
        }
        else{
            return companiesId.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell") as! SelectCategoryTableViewCell
        if usertype == 4{
        cell.categoriesdata = specialistTypes[indexPath.row]
        cell.count = indexPath.row
        cell.setData()
        cell.indexPath = indexPath.row
        cell.delegate = self
        return cell
        }
        else{
            cell.categoriesdata1 = companiesId[indexPath.row]
            cell.count = indexPath.row
            cell.setData1()
            cell.indexPath = indexPath.row
            cell.delegate = self
            return cell
        }
    }
}
extension SelectCategoriesViewController: indexPathdelegate{
    func onClick(indexPath: Int) {
        if usertype == 4 {
        specialistTypes[indexPath].isCheck = !specialistTypes[indexPath].isCheck
        self.categoriesTableView.reloadRows(at: [IndexPath.init(row: indexPath, section: 0)], with: .automatic)
        }
        else{
            companiesId[indexPath].isCheck = !companiesId[indexPath].isCheck
            self.categoriesTableView.reloadRows(at: [IndexPath.init(row: indexPath, section: 0)], with: .automatic)
        }
    }
}
