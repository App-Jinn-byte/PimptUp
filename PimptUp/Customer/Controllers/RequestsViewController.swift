//
//  RequestsViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 22/06/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController {
    
 
    @IBOutlet weak var quotesTV: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pagerViewCV: UICollectionView!
    @IBOutlet weak var startingDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var segmentedQuotes: UISegmentedControl!
    @IBOutlet weak var viewDetailTrailing: NSLayoutConstraint!
    
    let datePicker = UIDatePicker()
    var isUnQuoted = false
    var quotedList1 : [quotedList] = []
    var timer = Timer()
    var counter = 0
    var imgArray:[String] = []
    var startdate = ""
    var endDate = ""
    var userId: Int?
    var userTypeId: Int?
    let defaults = UserDefaults.standard
    var partTypeId: Int?
    var isDealer = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = defaults.integer(forKey: "UserId")
        userTypeId = defaults.integer(forKey: "UserTypeId")
        partTypeId = defaults.integer(forKey: "PartTypeId")
        quotesTV.delegate = self
        print (isDealer)
        
    
        getBanners()
        showDatePicker()
        showDatePicker1()
        filterBtn.layer.cornerRadius = filterBtn.frame.height/5
        filterBtn.clipsToBounds = true
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
    }
    
    @IBAction func segForQuotes(_ sender: Any) {
        if (segmentedQuotes.selectedSegmentIndex == 1){
            startingDateTF.text = ""
            endDateTF.text = ""
            isUnQuoted = true
            if (userTypeId == 3 || userTypeId == 5 || userTypeId == 4){
                APIRequests.getUnQuotedRequests(completion: APIRequestCompletedForGetQuotedList, id: userId! , from: startdate , to : endDate )
                
            }
            else{
                APIRequests.getUnQuotedRequestsDealer(completion: APIRequestCompletedForGetQuotedList, partTypeId: self.partTypeId!, id: userId! , from: startdate , to : endDate )
            }
        }
        else{
            if(userTypeId == 3 || isDealer == true || userTypeId == 4 || userTypeId == 5){
            APIRequests.getQuotedRequests(completion: APIRequestCompletedForGetQuotedList, id: userId! , from: startdate , to : endDate )
            }
            else{
                 APIRequests.getQuotedRequestsDealer(completion: APIRequestCompletedForGetQuotedList,partTypeId: self.partTypeId!, id: userId! , from: startdate , to : endDate )
            }
        }
        
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        
         let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        startingDateTF.inputAccessoryView = toolbar
            // add datepicker to textField
        startingDateTF.inputView = datePicker
        
    }
    func showDatePicker1(){
        //Formate Date
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker1))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        endDateTF.inputAccessoryView = toolbar
        // add datepicker to textField
        endDateTF.inputView = datePicker
        
    }
    
    @objc func donePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        startingDateTF.text = formatter.string(from: datePicker.date)
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    @objc func donePicker1(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        endDateTF.text = formatter.string(from: datePicker.date)
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    @IBAction func filterBtn(_ sender: Any) {
        if (startingDateTF.text != "" && endDateTF.text != "" && isUnQuoted == false){
            startdate = startingDateTF.text!
            endDate = endDateTF.text!
            if (userTypeId == 3){
             APIRequests.getQuotedRequests(completion: APIRequestCompletedForGetQuotedList, id: Constants.userId , from: startdate , to : endDate )
            }
            else{
               APIRequests.getQuotedRequestsDealer(completion: APIRequestCompletedForGetQuotedList,partTypeId: self.partTypeId!, id: userId! , from: startdate , to : endDate )
            }
        }
        else if (startingDateTF.text != "" && endDateTF.text != "" && isUnQuoted == true){
            
            startdate = startingDateTF.text!
            endDate = endDateTF.text!
            if (userTypeId == 3){
            APIRequests.getUnQuotedRequests(completion: APIRequestCompletedForGetQuotedList, id: Constants.userId , from: startdate , to : endDate )
            }
            else{
               APIRequests.getUnQuotedRequestsDealer(completion: APIRequestCompletedForGetQuotedList, partTypeId: self.partTypeId!, id: userId! , from: startdate , to : endDate )
            }
        }
        else{
            Constants.Alert(title: "Error", message: "Please fill dates properly", controller: self)
        }
    }
    
    func getBanners(){
        
        if Reachability.isConnectedToInternet(){
         
            
            APIRequests.getBanners( completion: APIRequestCompletedForBanners)
            
            if (userTypeId == 3 || isDealer == true ){
             APIRequests.getQuotedRequests(completion: APIRequestCompletedForGetQuotedList, id: Constants.userId , from: startdate , to : endDate )
            }
            else{
                APIRequests.getQuotedRequestsDealer(completion: APIRequestCompletedForGetQuotedList,partTypeId: self.partTypeId!, id: userId! , from: startdate , to : endDate )
            }
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    fileprivate func APIRequestCompletedForBanners(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let banners = try decoder.decode(BannersImagesModelResponse.self, from: data)
                let list = banners.bannersList
                for images in list{
                    let imagePath = images.ImagePath
                    var image1 = String(imagePath?.dropFirst(3) ?? "")
                    image1 = "https://pimptup.com/"+image1
                    //    let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                    
                    
                    imgArray.append(image1)
                    
                }
                print(imgArray)
                pageControl.numberOfPages = imgArray.count
                pageControl.currentPage = 0
                pagerViewCV.reloadData()
                //    activityIndicator.stopAnimating()
            } catch {
                //    activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "JSON Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            // activityIndicator.stopAnimating()
            Constants.Alert(title: "JSON Error ", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    @objc func changeImage(){
        if counter < imgArray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.pagerViewCV.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.pagerViewCV.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
    }
    
    
    fileprivate func APIRequestCompletedForGetQuotedList(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let quotes = try decoder.decode(GetQuotesByUserIdDate.self, from: data)
                quotedList1 = quotes.quotedModelsList
                
                if (quotedList1.count == 0){
                    quotesTV.isHidden = true
                }
                else{
                    quotesTV.isHidden = false
                }
                quotesTV.reloadData()
                activityIndicator.stopAnimating()
            } catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: "No results found" , controller: self)
            }
            
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
}
extension RequestsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ((collectionView.frame.width)) // 15 because of paddings
        // print("cell width : \(width)")
        let height = (collectionView.frame.height)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pager1", for: indexPath)
        
        if let vc = cell.viewWithTag(222) as? UIImageView {
            
            let  imagePath = imgArray[indexPath.row]
            let urlString = imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            vc.kf.setImage(with: image)
        }
        return cell
    }
}

extension RequestsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotedList1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuotedList") as! QuotedNonQuotedTableViewCell
        cell.cellObj = quotedList1[indexPath.row]
        cell.setData()
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
}

extension RequestsViewController : QuoteDetail{
    func onClickPostQuote(obj: quotedList) {
        let popUpVc = UIStoryboard(name: "Dealer", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! PopUpViewController
        popUpVc.unquotedObject = obj
        self.addChild(popUpVc)
        popUpVc.view.frame = self.view.frame
        self.view.addSubview(popUpVc.view)
        popUpVc.didMove(toParent: self)
    }
    
    func onclickViewDetail(obj: quotedList) {
        print("delegate request \(obj) is calling ")
        let vc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "QuoteList") as? QuoteDetailViewController
        vc!.quoteDetail = obj
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func onClickViewQuotes(obj: quotedList) {
           print("delegate request \(obj) is calling ")
           let vc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "QUotesList") as? QuotesListViewController
           vc!.quoteDetail = obj
           self.navigationController?.pushViewController(vc!, animated: true)
       }
}
