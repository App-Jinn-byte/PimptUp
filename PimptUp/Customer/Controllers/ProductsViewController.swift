//
//  ProductsViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 06/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var pagerViewCV: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productsVC: UICollectionView!
    @IBOutlet weak var categoriesCV: UICollectionView!
    
    var timer = Timer()
    var counter = 0
    var imgArray:[String] = []
    
    var catArray: [String] = []
    var catIdArray:[Int] = []
    var categoriesArray: [CatList]?
    var dealerCategories: [DCategories]?
    var id:Int?
    var selectedIndex = 0
    var productsArray: [GetProductsModelResponse] = []
    var productsArrayWithCatId: [ProductsList] = []
    var productsArrayWithDealerCatId: [ProductsListDealer] = []
    var isDealer = false
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerViewCV.delegate = self
        categoriesCV.delegate = self
        productsVC.delegate = self
        categoriesCV.isScrollEnabled = false
        getBanners()
        if (defaults.integer(forKey: "UserTypeId") == 2){
            isDealer = true
        }
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        
        if Reachability.isConnectedToInternet(){
            // activityIndicator.startAnimating()
            if (isDealer == false){
                APIRequests.getCategories( completion: APIRequestCompletedForCategories)
                
                //   APIRequests.getAllProducts( completion: APIRequestCompletedForProducts, catId: 0 , dealerId: 0)
            }
            else if (isDealer == true){
                APIRequests.getCategoriesForDealer( completion: APIRequestCompletedForCategoriesForDealer)
            }
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        pagerViewCV.delegate = self
              categoriesCV.delegate = self
              productsVC.delegate = self
              categoriesCV.isScrollEnabled = false
              getBanners()
              if (defaults.integer(forKey: "UserTypeId") == 2){
                  isDealer = true
              }
              
              DispatchQueue.main.async {
                  self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
              }
              
              
              if Reachability.isConnectedToInternet(){
                  // activityIndicator.startAnimating()
                  if (isDealer == false){
                      APIRequests.getCategories( completion: APIRequestCompletedForCategories)
                      
                      //   APIRequests.getAllProducts( completion: APIRequestCompletedForProducts, catId: 0 , dealerId: 0)
                  }
                  else if (isDealer == true){
                      APIRequests.getCategoriesForDealer( completion: APIRequestCompletedForCategoriesForDealer)
                  }
              }
              else {
                  print("Internet connection not available")
                  
                  Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
              }
    }
    @IBAction func logoutBtn(_ sender: Any) {
        if Reachability.isConnectedToInternet(){
            Constants.Alert1(title: "Logout", message: "Are You sure to Logout", controller: self, action: handlersuccess())
            
            
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
    func getBanners(){
        
        if Reachability.isConnectedToInternet(){
            
            APIRequests.getBanners( completion: APIRequestCompletedForBanners)
            
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
    
    func getProductsById(catId: Int){
        
        if Reachability.isConnectedToInternet(){
            if (isDealer == false){
                APIRequests.getAllProductsByCategoryId( completion: APIRequestCompletedForProductsWithCatId, catId: catId)
            }
            else if (isDealer == true){
                APIRequests.getAllProductsByDealerIdCategoryId( completion: APIRequestCompletedForProductsWithCatId, catId: catId)
            }
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
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
                categoriesCV.reloadData()
                //    activityIndicator.stopAnimating()
            } catch {
                //    activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    fileprivate func APIRequestCompletedForCategoriesForDealer(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let categories = try decoder.decode(GetCategoriesOfDealer.self, from: data)
                dealerCategories = categories.categoriesList
                if (dealerCategories!.count == 0){
                    productsVC.isHidden = true
                }
                else{
                    productsVC.isHidden = false
                    
                }
                    
                    for cat in dealerCategories!{
                        let name = cat.Name
                        catArray.append(name!)
                        
                    }
                    catArray.reverse()
                    
                    for id in dealerCategories!{
                        let catId = id.CategoryId
                        catIdArray.append(catId!)
                        
                    }
                    catIdArray.reverse()
                    categoriesCV.reloadData()
                    //    activityIndicator.stopAnimating()
                } catch {
                    //    activityIndicator.stopAnimating()
                    print("error trying to convert data to JSON")
                    Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
                }
                
            }
            else{
                activityIndicator.stopAnimating()
                Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
            }
        }
        
        fileprivate func APIRequestCompletedForProducts(response:Any?,error:Error?){
            
            if APIResponse.isValidResponse(viewController: self, response: response, error: error){
                
                
                
                //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decoder = JSONDecoder()
                do {
                    
                    let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                    
                    print(data,"PRinting the data here.")
                    
                    let products = try decoder.decode([GetProductsModelResponse].self, from: data)
                    productsArray = products
                    if (productsArray.count == 0){
                        productsVC.isHidden = true
                    }
                    else{
                        productsVC.isHidden = false
                    }
                    activityIndicator.stopAnimating()
                    productsVC.reloadData()
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
        
        fileprivate func APIRequestCompletedForProductsWithCatId(response:Any?,error:Error?){
            
            if APIResponse.isValidResponse(viewController: self, response: response, error: error){
                
                
                
                //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decoder = JSONDecoder()
                do {
                    
                    let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                    //let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    print(data,"PRinting the data here.")
                    if (isDealer == false){
                        let products = try decoder.decode(GetAllProductsWithCatId.self, from: data)
                        productsArrayWithCatId = products.productsList
                        if (productsArrayWithCatId.count == 0){
                            productsVC.isHidden = true
                        }
                        else{
                            productsVC.isHidden = false
                        }
                    }
                    else{
                        let products = try decoder.decode(GetAllProductsDealerCategory.self, from: data)
                        productsArrayWithDealerCatId = products.productListByCategoryDealerModel
                        if (productsArrayWithDealerCatId.count == 0){
                            productsVC.isHidden = true
                        }
                        else{
                            productsVC.isHidden = false
                        }
                    }
                    
                    activityIndicator.stopAnimating()
                    productsVC.reloadData()
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
    }
    
    extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if (collectionView.tag == 3){
                return imgArray.count
            }
            else if(collectionView.tag == 1){
                return catArray.count
            }
            else if(collectionView == self.productsVC && isDealer == false) {
                
                return productsArrayWithCatId.count
                
            }
            else{
                return productsArrayWithDealerCatId.count
            }
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if (collectionView == productsVC){
                let width = ((collectionView.frame.width - 20) / 3) // 15 because of paddings
                // print("cell width : \(width)")
                return CGSize(width: width, height: 140)
            }
            else if (collectionView == categoriesCV){
                let width = ((collectionView.frame.width - 20) / 3) // 15 because of paddings
                // print("cell width : \(width)")
                return CGSize(width: width, height: 140)
            }
            else {
                let width = ((collectionView.frame.width)) // 15 because of paddings
                // print("cell width : \(width)")
                let height = (collectionView.frame.height)
                return CGSize(width: width, height: height)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if (collectionView == pagerViewCV){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pager1", for: indexPath)
                
                if let vc = cell.viewWithTag(222) as? UIImageView {
                    
                    let  imagePath = imgArray[indexPath.row]
                    let urlString = imagePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                    let image = URL(string: urlString!)
                    vc.kf.setImage(with: image)
                }
                return cell
            }
                
            else if (collectionView == categoriesCV){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath) as! CategoriesCollectionViewCell
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
                
            else if (collectionView == productsVC && isDealer == false){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Products", for: indexPath) as! ProductsCollectionViewCell
                cell.productObj1 = self.productsArrayWithCatId[indexPath.row]
                cell.setData1()
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Products", for: indexPath) as! ProductsCollectionViewCell
                cell.productObj2 = self.productsArrayWithDealerCatId[indexPath.row]
                cell.setData2()
                return cell
            }
            
            //        else {
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Products", for: indexPath) as! ProductsCollectionViewCell
            //           // cell.productObj = self.productsArray[indexPath.row]
            //          //  cell.setData()
            //            return cell
            //        }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductDetail") as? ProductDetailViewController
            if (isDealer == false){
                vc?.productDetailObjWithCatId = self.productsArrayWithCatId[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else {
                vc?.productDetailObjWithDealerCatId = self.productsArrayWithDealerCatId[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            //        else{
            //            vc?.productDetailObj = self.productsArray[indexPath.row]
            //            self.navigationController?.pushViewController(vc!, animated: true)
            //        }
        }
    }
    
    extension ProductsViewController: SetBgViewController{
        func onClickBtn(indexPath: Int, item: String) {
            print(indexPath)
            print(item)
            
            
            let previousIndex = selectedIndex
            selectedIndex = indexPath
            if (previousIndex ==  selectedIndex){
                return
            }
            categoriesCV.reloadItems(at: [IndexPath(row: selectedIndex, section: 0),IndexPath(row: previousIndex, section: 0)])
            
            
            categoriesCV.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
            
        }
    }
    extension ProductsViewController{
        func handlersuccess() -> (UIAlertAction) -> () {
            return { action in
                let param:[String:Any] = [:]
                APIRequests.Logout( parameters:param ,completion: self.APIRequestCompletedForLogout)
            }
        }
}


//     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.row)
//         let currentCell = collectionView.cellForItem(at: indexPath) as! CategoriesCollectionViewCell
//        if(indexPath.row == 0){
//             currentCell.categoriesText.textColor = UIColor.init(named: "app_blue")
//            self.view.backgroundColor = .purple
//            print()
//        }
//         else if(indexPath.row == 1){
//            self.view.backgroundColor = .blue
//        }
//        else if(indexPath.row == 2){
//            self.view.backgroundColor = .black
//        }
//        else if(indexPath.row == 3){
//            self.view.backgroundColor = .green
//        }
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//
//        print(currentCell)
//        currentCell.categoriesText.textColor = UIColor.init(named: "app_blue")
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       // collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//       // let currentCell = collectionView.cellForItem(at: indexPath) as! CategoriesCollectionViewCell
//       // currentCell.isSelect = true
////        if(indexPath.row == 0){
////            currentCell.categoriesBtn.setTitleColor(UIColor.init(named: "app_blue"), for: .normal)
////
////    }
//
////        else{
////            currentCell.categoriesBtn.setTitleColor(UIColor.init(named: "app_blue"), for: .normal)
////        }
//     //   collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//
//    }

//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let currentCell = collectionView.cellForItem(at: indexPath) as! CategoriesCollectionViewCell
//         currentCell.categoriesBtn.setTitleColor(.red, for: .normal)
//    }

