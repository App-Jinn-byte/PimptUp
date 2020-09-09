//
//  BlogsViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 25/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class BlogsViewController: UIViewController {
    @IBOutlet weak var blogsCollectionView: UICollectionView!
    
    var blogDate1 = ""
    var blogImage = ""
    var blogsList1 = [blogsList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        blogsCollectionView.delegate = self
        blogsCollectionView.dataSource = self
        
        APIRequests.GetBlogs(completion: APIRequestCompleted)
    }
    

   
    public func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let blogs = try decoder.decode(BlogsModelResponse.self, from: data)
                blogsList1 = blogs.getblogList
                //print(blogsList1)
               // print(blogsList1[1].ThumbNail)
                print(blogsList1.count)
                
                blogsCollectionView.reloadData()
            }
            catch {
                
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: "Hello", controller: self)
            }
        }
        else{
            Constants.Alert(title: "Error", message: "Error", controller: self)
        }
    }
    

}

extension BlogsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
  
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let collectionCellSize = collectionView.frame.size.width
//
//        return CGSize(width: collectionCellSize/2 - 20, height: 225)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blogsList1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BlogsCollectionViewCell
        
        
        cell.blogTitleLabel.text = blogsList1[indexPath.row].Title
        //cell.blogDateLabel.text = blogDate1
        cell.blogDescriptionLabel.text = blogsList1[indexPath.row].Description?.html2AttributedString
        cell.blogPostedByLabel.text = blogsList1[indexPath.row].UserName
        
       
        var imagePaths = blogsList1[indexPath.row].ImagePath
         if (imagePaths != nil){
        print (imagePaths)
        imagePaths = String(imagePaths!.dropFirst(3))
        print(imagePaths)
            imagePaths = "\(Constants.ImagePath)"+imagePaths!
        print(imagePaths)
        let urlString = imagePaths!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        print(urlString)
        
        if  let url = URL(string: urlString!)  {
            print(url)
            Constants.blogimage = url
            cell.blogImageView.downloadImage(from: url)
        }
        else{
            print(imagePaths)
            let url1 = URL(string: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/09/12/11/naturo-monkey-selfie.jpg?w968h681")
            cell.blogImageView.downloadImage(from: url1!)
        }
    }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let indexPath = indexPath.row
        print(indexPath)
        let vc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "BlogDetail") as! BlogDetailViewController
        vc.blogObject = self.blogsList1[indexPath]
        navigationController!.pushViewController(vc, animated: true)
    }
}
