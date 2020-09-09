//
//  InquireAPartViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 24/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class TyreShopViewController: UIViewController {

   
    @IBOutlet weak var aspectRatioTF: UITextField!
    @IBOutlet weak var widthTF: UITextField!
    @IBOutlet weak var rimSizeTF: UITextField!
    @IBOutlet weak var manufacturerTF: UITextField!
    @IBOutlet weak var tyreRangeTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    let manufacturerPV = UIPickerView()
    let aspectRatioPV = UIPickerView()
    let rimSizePV = UIPickerView()
    let tyreRangePV = UIPickerView()
    let widthPV = UIPickerView()
    
    var tyreManufacturers: [Manu] = []
    //var tyreAttributes: [Attributes] = []
    var widths: [Width] = []
    var aspectRatio: [AspectRatio] = []
    var sizes: [Sizes] = []
    var ranges: [Ranges] = []

    
    var manufacturerId: Int?
    var widthsId: Int?
    var aspectRatioId: Int?
    var sizesId: Int?
    var rangesId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        manufacturerPV.delegate = self
        rimSizePV.delegate = self
        aspectRatioPV.delegate = self
        widthPV.delegate = self
        tyreRangePV.delegate = self
        
         APIRequests.getTyresManufacturers(completion: APIRequestCompletedForGetTyresManufacturers)
        APIRequests.getTyreAttributes(completion: APIRequestCompletedForGetTyreAttributes)
    }

    
    @IBAction func submitBtn(_ sender: Any) {
//        print("\(widthsId)")
//        print("\(aspectRatioId)")
//        print("\(manufacturerId)")
//        print("\(sizesId)")
//        print("\(rangesId)")
        if (manufacturerId == nil || rangesId == nil || sizesId == nil || widthsId == nil || aspectRatioId == nil){
            Constants.Alert(title: "Input Error", message: "All fields are required", controller: self)
            return
        }
        let idArray:[Int] = [manufacturerId!,rangesId!,sizesId!,widthsId!,aspectRatioId!]
        print(idArray)
        let vc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "TyresList") as? TyreswithAttributesViewController
        vc?.getIds = idArray
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func setUI(){
        // Setting buttons and borders
        submitBtn.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()
    }
    
    fileprivate func APIRequestCompletedForGetTyresManufacturers(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let manufacturers = try decoder.decode(TyreManufacturersModelResponse.self, from: data)
                self.tyreManufacturers = manufacturers.manufacturers
                print(tyreManufacturers)
//                manufacturer = tyresAttribution!.manufacturers
//                sizes = tyresAttribution!.sizes
//                ranges = tyresAttribution!.ranges
//                aspectRatio = tyresAttribution!.aspectratio
//                widths = tyresAttribution!.widths
                
                setPickerView()
            } catch {
                
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    fileprivate func APIRequestCompletedForGetTyreAttributes(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let attributes = try decoder.decode(GetTyreAttributesResponse.self, from: data)
                ranges = attributes.tyreAttributes
                print(ranges)
                //                manufacturer = tyresAttribution!.manufacturers
                
//                for size in ranges {
//                    sizes = sizes + size.tyreSizes
//                }
//                for width in sizes{
//                    widths = widths +  width.tyreWidths
//                }
//                for aspect in widths{
//                 aspectRatio = aspectRatio + aspect.tyreAspectRatios
//                }
                
                setPickerView()
            } catch {
                
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
}
    


extension TyreShopViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func setPickerView(){
        
        //catPicker.backgroundColor = UIColor.init(n)
        
        //brandPicker.setValue(UIColor.black, forKeyPath: "textColor")
         manufacturerPV.showsSelectionIndicator = true
        manufacturerTF.inputView = manufacturerPV
        rimSizeTF.inputView = rimSizePV
        tyreRangeTF.inputView = tyreRangePV
        aspectRatioTF.inputView = aspectRatioPV
        widthTF.inputView = widthPV
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor.init(named: "bgDark")
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelButton))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //selectCategoryTextField.inputView = catPicker
        manufacturerTF.inputAccessoryView = toolBar
        rimSizeTF.inputAccessoryView = toolBar
        tyreRangeTF.inputAccessoryView = toolBar
        aspectRatioTF.inputAccessoryView = toolBar
        widthTF.inputAccessoryView = toolBar
    }
    @objc func cancelButton(){
          view.endEditing(true)
      }
    @objc func donePicker() {
        if (manufacturerTF.resignFirstResponder()){
            if (manufacturerTF.text?.isEmpty)! {
                manufacturerTF.text = self.tyreManufacturers[0].Description
                manufacturerId = tyreManufacturers[0].ManufacturerId
            }
        }
        else if (tyreRangeTF.resignFirstResponder()){
            if (tyreRangeTF.text?.isEmpty)! {
                tyreRangeTF.text = self.ranges[0].Description
                 rangesId = ranges[0].TyreRange
            }
        }
        if (rimSizeTF.resignFirstResponder()){
            if (rimSizeTF.text?.isEmpty)! {
                rimSizeTF.text = self.sizes[0].Descriptions
                 sizesId = sizes[0].TyreSizeId
            }
        }
        if (aspectRatioTF.resignFirstResponder()){
            if (aspectRatioTF.text?.isEmpty)! {
                aspectRatioTF.text = self.aspectRatio[0].Description
                 aspectRatioId = aspectRatio[0].TyreAspectRatioId
            }
        }
        if (widthTF.resignFirstResponder()){
            if (widthTF.text?.isEmpty)! {
                widthTF.text = self.widths[0].Description
                widthsId = widths[0].TyreWidthId
            }
        }
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == manufacturerPV){
            return tyreManufacturers.count
        }
        else if (pickerView == rimSizePV){
            return sizes.count
        }
        else if (pickerView == aspectRatioPV){
            return aspectRatio.count
        }
        else if (pickerView == tyreRangePV){
            return ranges.count
        }
        else if (pickerView == widthPV){
            return widths.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == manufacturerPV){
            return tyreManufacturers[row].Description
        }
        else if (pickerView == rimSizePV){
            for _ in ranges{
                widths = sizes[row].tyreWidths
            }
            return sizes[row].Descriptions
        }
        else if (pickerView == aspectRatioPV){
            return aspectRatio[row].Description
        }
        else if (pickerView == tyreRangePV){
            for _ in ranges{
                sizes = ranges[row].tyreSizes
            }
            return ranges[row].Description
            
        }
        else if (pickerView == widthPV){
            for _ in ranges{
                aspectRatio = widths[row].tyreAspectRatios
            }
            return widths[row].Description
        }
        return "hello"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == manufacturerPV){
            self.manufacturerTF.text = tyreManufacturers[row].Description
            manufacturerId = tyreManufacturers[row].ManufacturerId
        }
        else if (pickerView == rimSizePV){
           self.rimSizeTF.text = sizes[row].Descriptions
            sizesId = sizes[row].TyreSizeId
        }
        else if (pickerView == aspectRatioPV){
            self.aspectRatioTF.text = aspectRatio[row].Description
            aspectRatioId = aspectRatio[row].TyreAspectRatioId
        }
        else if (pickerView == tyreRangePV){
            self.tyreRangeTF.text = ranges[row].Description
            rangesId = ranges[row].TyreRange
        }
        else if (pickerView == widthPV){
            self.widthTF.text = widths[row].Description
            widthsId = widths[row].TyreWidthId
        }
    }
}
