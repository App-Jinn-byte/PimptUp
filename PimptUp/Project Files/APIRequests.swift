//
//  APIRequest.swift
//  PimptUp
//
//  Created by JanAhmad on 21/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
import Alamofire


typealias RequestCompletion = (_ response: Any?, _ error: Error?) -> Void
typealias completeIt = (_ name: String?) -> Void

class APIRequests {
    
// live server
//    public static let BASE_URL = "https://pimptup.com/api/Mobile/"
    
    // test server
    public static let BASE_URL = "http://pimptup.jinnbytedev.com/api/Mobile/"
        
    
    public static func Login(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"Login", parameters: parameters, completion: completion)
    }
    
    public static func ForgotPassword(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"validateByEmail", parameters: parameters, completion: completion)
    }
    
    public static func ResetPassword(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"ResetPassword", parameters: parameters, completion: completion)
    }
    
    public static func Registeration(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"Register", parameters: parameters, completion: completion)
    }
    
    public static func GetAllCategories(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllCategoriesWithAds",  completion: completion)
    }
    public static func GetBlogs(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllBlogs",  completion: completion)
    }
    
    public static func GetComapnies(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetCompanies",  completion: completion)
    }
    public static func GetSpecialists(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetSpecialistCategorires",  completion: completion)
    }
    public static func Specialists(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllSpecialists",  completion: completion)
    }
    public static func imageUploading(imageData:Data,parameters: Parameters, completion: @escaping RequestCompletion) {
        imgUploading(image:imageData, url: BASE_URL+"UploadUserImage?UserId=", parameters: parameters,  completion: completion)
    }
    public static func getCarMakeModel(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetModelAndMake",  completion: completion)
    }
    public static func getVehicles(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetVehiclesByUserId?userId=\(Constants.userId)",  completion: completion)
    }
    public static func deleteMyCar(deleteId: Int, parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"DeleteVehicle?userVehicleId=\(deleteId)", parameters: [:], completion: completion)
    }
    public static func getUser(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetUserByUserId/\(Constants.userId)",  completion: completion)
    }
    public static func addPart(parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"SaveRequest", parameters: parameters, completion: completion)
    }
    public static func getPartRequests(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetPartRequestListByUserId?userId=\(Constants.userId)",  completion: completion)
    }
    public static func getQuotes(completion: @escaping RequestCompletion , id: Int) {
        GETRequest(url: BASE_URL+"QoutesListByRequestId?requestId=\(id)",  completion: completion)
    }
    public static func getTyresManufacturers(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllManufacturers",  completion: completion)
    }
    public static func getTyresWithAttributes( parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"GetTyresListWithAttributes", parameters: parameters, completion: completion)
    }
    public static func getCategories(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetAllCategories",  completion: completion)
    }
    public static func getAllProducts(completion: @escaping RequestCompletion , catId: Int , dealerId: Int) {
        GETRequest(url: BASE_URL+"GetProductsByDealerIdAndCategoryId?categoryId=\(catId)&dealerId=\(dealerId)",  completion: completion)
    }
    public static func getAllProductsByCategoryId(completion: @escaping RequestCompletion , catId: Int) {
        GETRequest(url: BASE_URL+"GetProductsByCategoryId?categoryId=\(catId)",  completion: completion)
    }
    
    public static func getBanners(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetBannersList",  completion: completion)
    }
    public static func getFtProducts(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetFeaturedProducts",  completion: completion)
    }
    public static func FindSpecialists( parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"FindSpecialist", parameters: parameters, completion: completion)
    }
    public static func getTyreAttributes(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"gettyreData",  completion: completion)
    }
    public static func UpdateProfile( parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"UpdateUser", parameters: parameters, completion: completion)
    }
    public static func getQuotedRequests( parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"GetCustomerQuotRequestList?UserId=", parameters: parameters, completion: completion)
    }
    public static func getQuotedRequests(completion: @escaping RequestCompletion , id: Int , from : String , to: String) {
        GETRequest(url: BASE_URL+"GetCustomerQuotRequestList?UserId=\(id)&fromdate=\(from)&todate=\(to)",  completion: completion)
    }
    public static func getUnQuotedRequests(completion: @escaping RequestCompletion , id: Int , from : String , to: String) {
        GETRequest(url: BASE_URL+"GetCustomerNonQuotRequestList?UserId=\(id)&fromdate=\(from)&todate=\(to)",  completion: completion)
    }
    public static func getCategoriesForDealer(completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetCategoriesByDealerId/\(Constants.userId)",  completion: completion)
    }
    public static func postApart( parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"PostASparePart", parameters: parameters, completion: completion)
    }
    public static func addNewTyre( parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"AddNewTyer", parameters: parameters, completion: completion)
    }
    public static func getAllProductsByDealerIdCategoryId(completion: @escaping RequestCompletion , catId: Int) {
        GETRequest(url: BASE_URL+"GetProductListByDealerAndCategory?categoryId=\(catId)&dealerId=\(Constants.userId)",  completion: completion)
    }
    
    public static func getUnQuotedRequestsDealer(completion: @escaping RequestCompletion , partTypeId:Int, id: Int , from : String , to: String) {
        GETRequest(url: BASE_URL+"GetDealerNonQuotRequestList?PartTypeId=\(partTypeId)&fromdate=\(from)&todate=\(to)&dealerId=\(id)",  completion: completion)
    }
    public static func getQuotedRequestsDealer(completion: @escaping RequestCompletion , partTypeId: Int , id: Int , from : String , to: String) {
        GETRequest(url: BASE_URL+"GetDealerQuotRequestList?PartTypeId=\(partTypeId)&fromdate=\(from)&todate=\(to)&dealerId=\(id)",  completion: completion)
    }
    public static func getTyresOfDealer(id: Int ,completion: @escaping RequestCompletion) {
        GETRequest(url: BASE_URL+"GetTyresListByDealerId?userId=\(id)",  completion: completion)
    }
    public static func AddQoutes( parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"AddQoutes", parameters: parameters, completion: completion)
    }
    public static func Logout( parameters: Parameters, completion: @escaping RequestCompletion) {
        POSTRequest(url: BASE_URL+"Logout?userId=\(Constants.userId)", parameters: parameters, completion: completion)
    }
}
extension APIRequests {
    
    fileprivate static func imgUploading(image: Data, url:String,parameters: Parameters, completion: @escaping RequestCompletion){
        
        guard let urlRequest = URL(string: url)else{return }
        var request = URLRequest(url: urlRequest )
        request.httpMethod = "POST"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = nil
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            
        MultipartFormData.append(image, withName: "fileset", fileName: "name", mimeType: "image/jpg")
        
        },with: request,encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if let info = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let links = info["links"] as? Dictionary<String, AnyObject> {
                            
                            if let imgLink = links["image_link"] as? String {
                                print("LINK: \(imgLink)")
                            }
                        }
                    }
                    
                } case .failure(let error):
                    print(error)
            }
        })
    }
    
    fileprivate static func GETRequest(url: String,  completion: @escaping RequestCompletion) {
        
        
        guard let urlRequest = URL(string: url)else{return }
        var request = URLRequest(url: urlRequest )
        request.httpMethod = "GET"
        
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        
        Alamofire.request(request).responseJSON { response in
            
            switch (response.result) {
            case .success:
                
                completion(response.result.value, nil)
                
                break
                
                //success code here
                
            case .failure(let error):
                
                completion(nil, response.result.error)
                
                break
                
                //failure code here
            }
        }
    }
    
    fileprivate static func POSTRequest(url: String, parameters: Parameters,
                                        completion: @escaping RequestCompletion) {
        
        //        Alamofire.request(urlRequest, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: hearder).responseJSON { response in
        //            switch response.result
        
        guard let urlRequest = URL(string: url)else{return }
        var request = URLRequest(url: urlRequest )
        request.httpMethod = "POST"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = nil
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 50
        
        Alamofire.request(request).responseJSON { response in
            print(response.response?.statusCode)
            guard let statusCode =  response.response?.statusCode else{return}
            Constants.statusCode = statusCode
            print(statusCode)
            print(response.result)
            print(response.result.value)
            
            //Mark:- pending work on the basis of status code dynamically alert message from response
            if (Constants.statusCode == 500 ){
              //  Constants.statusMessage = response.result.value.
                Constants.statusMessage = "Invalid Credentials"
            }
            else if (Constants.statusCode == 403){
                Constants.statusMessage = "Please enter Unique email and Phone ..."
            }
            
            switch (response.result) {
            case .success:
                
                completion(response.result.value, nil)
                
                break
                
                //success code here
                
            case .failure(let error):
                
                completion(nil, response.result.error)
                
                break
                
                //failure code here
            }
        }
    }
}
extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
