//
//  HomeViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 09/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Kingfisher
import SwipeableTabBarController

class HomeViewController:  UIViewController{
    
    @IBOutlet weak var pagerViewCV: UICollectionView!
    @IBOutlet weak var ftProductsCV: UICollectionView!
    @IBOutlet weak var ouProductsCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    
    var timer = Timer()
    var counter = 0
    
    var productsArray: [GetProductsModelResponse] = []
    var productsArrayWithCatId: [ProductsList] = []
    
    var imgArray:[String] = []
    var ftProducts: [FtProducts] = []
    
    
    var catArray: [String] = []
    var catIdArray:[Int] = []
    var categoriesArray: [CatList]?
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ftProductsCV.delegate = self
        ouProductsCV.delegate = self
        pagerViewCV.delegate = self
        categoriesCollectionView.delegate = self
        Constants.getUserVehicles()
        
        getBanners()
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        if Reachability.isConnectedToInternet(){
            Constants.Alert1(title: "Logout", message: "Are You sure to Logout", controller: self, action: handlersuccess())
            
            
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    
    func getBanners(){
        
        if Reachability.isConnectedToInternet(){
            
            APIRequests.getBanners( completion: APIRequestCompletedForBanners)
            APIRequests.getFtProducts( completion: APIRequestCompletedForFtProducts)
            APIRequests.getCategories( completion: APIRequestCompletedForCategories)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    func getProductsById(catId: Int){
        
        if Reachability.isConnectedToInternet(){
            
            APIRequests.getAllProductsByCategoryId( completion: APIRequestCompletedForProductsWithCatId, catId: catId)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    fileprivate func APIRequestCompletedForLogout(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let categories = try decoder.decode(AddPartModelResponse.self, from: data)
                print(categories.Message)
                if (categories.Code == 1){
                                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "nav")
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.window?.rootViewController = rootViewController
                     UserDefaults.standard.set(false, forKey: "LoggedIn")
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "nav")
//                    self.present(vc, animated: true)
                }
            } catch {
                
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            //activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    fileprivate func APIRequestCompletedForCategories(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let categories = try decoder.decode(GetAllCategoriesResponse.self, from: data)
                categoriesArray = categories.categories
                for cat in categoriesArray!{
                    let name = cat.Name
                    catArray.append(name!)
                    
                }
                catArray.reverse()
                
                for id in categoriesArray!{
                    let catId = id.CategoryId
                    catIdArray.append(catId!)
                    
                }
                catIdArray.reverse()
                categoriesCollectionView.reloadData()
                //    activityIndicator.stopAnimating()
            } catch {
                //    activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            //activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    fileprivate func APIRequestCompletedForProductsWithCatId(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let products = try decoder.decode(GetAllProductsWithCatId.self, from: data)
                productsArrayWithCatId = products.productsList
                if (productsArrayWithCatId.count == 0){
                    ouProductsCV.isHidden = true
                }
                else {
                    ouProductsCV.isHidden = false
                }
                activityIndicator.stopAnimating()
                ouProductsCV.reloadData()
            } catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
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
                    image1 = "\(Constants.ImagePath)"+image1
                    let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                    
                    
                    imgArray.append(urlString)
                    
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
    
    fileprivate func APIRequestCompletedForFtProducts(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let products = try decoder.decode(GetFtProductsModelResponse.self, from: data)
                ftProducts = products.products
                if (ftProducts.count == 0){
                    ftProductsCV.isHidden =  true
                }
                self.ftProductsCV.reloadData()
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
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == ftProductsCV){
            let width = ((collectionView.frame.width - 20) / 2) // 15 because of paddings
            // print("cell width : \(width)")
            let height = (collectionView.frame.height)
            return CGSize(width: width, height: height)
        }
        else if (collectionView == self.ouProductsCV) {
            let width = ((collectionView.frame.width - 20) / 3) // 15 because of paddings
            // let height = (collectionView.frame.height)
            // print("cell width : \(width)")
            return CGSize(width: width, height: 200)
        }
        else if collectionView == self.pagerViewCV {
            let width = ((collectionView.frame.width))
            // print("cell width : \(width)")
            let height = (collectionView.frame.height)
            return CGSize(width: width, height: height)
        }
        else {
            // let width = ((collectionView.frame.width))
            // print("cell width : \(width)")
            let height = (collectionView.frame.height)
            return CGSize(width: 60, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == pagerViewCV ){
            return imgArray.count
        }
        else if (collectionView == ftProductsCV){
            return ftProducts.count
        }
        else if (collectionView == categoriesCollectionView){
            return catArray.count
        }
        else{
            return productsArrayWithCatId.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == ftProductsCV){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FtProduct", for: indexPath) as! FtProductCollectionViewCell
            cell.productObj = ftProducts[indexPath.row]
            cell.setCellData()
            return cell
        }
            
            //        else if (collectionView == ftProductsCV) {
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OurProduct", for: indexPath)
            //            return cell
            //        }
            
        else if (collectionView == pagerViewCV){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pager", for: indexPath)
            
            if let vc = cell.viewWithTag(222) as? UIImageView {
                
                let  imagePath = imgArray[indexPath.row]
                let urlString = imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let image = URL(string: urlString!)
                vc.kf.setImage(with: image)
            }
            return cell
        }
            
        else if (collectionView == categoriesCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OurCategories", for: indexPath) as! CategoriesCollectionViewCell
            // cell.categoriesBtn.setTitle( array[indexPath.row], for: .normal)
            cell.item = catArray[indexPath.row]
            
            cell.id = indexPath.row
            cell.categoriesBtn.setTitle(catArray[indexPath.row], for: .normal)
            if (indexPath.row == selectedIndex ){
                cell.categoriesBtn.setTitleColor(UIColor.init(named: "app_blue"), for: .normal)
                self.getProductsById(catId: catIdArray[selectedIndex])
            }
            else{
                cell.categoriesBtn.setTitleColor(.gray, for: .normal)
            }
            cell.delegate = self
            return cell
        }
        else if (collectionView == ouProductsCV && productsArrayWithCatId.count != 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Products", for: indexPath) as! ProductsCollectionViewCell
            cell.productObj1 = self.productsArrayWithCatId[indexPath.row]
            cell.setData1()
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Products", for: indexPath) as! ProductsCollectionViewCell
            //  cell.productObj = self.productsArray[indexPath.row]
            //  cell.setData()
            return cell
        }
        
    }
}
extension HomeViewController: SetBgViewController{
    func onClickBtn(indexPath: Int, item: String) {
        print(indexPath)
        print(item)
        
        
        let previousIndex = selectedIndex
        selectedIndex = indexPath
        if (previousIndex ==  selectedIndex){
            return
        }
        categoriesCollectionView.reloadItems(at: [IndexPath(row: selectedIndex, section: 0),IndexPath(row: previousIndex, section: 0)])
        
        
        categoriesCollectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
        
    }
}
extension HomeViewController{
    func handlersuccess() -> (UIAlertAction) -> () {
        return { action in
            let param:[String:Any] = [:]
            APIRequests.Logout( parameters:param ,completion: self.APIRequestCompletedForLogout)
        }
    }
}



