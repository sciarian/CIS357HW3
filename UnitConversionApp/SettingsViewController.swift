//
//  SettingsViewController.swift
//  UnitConversionApp
//
//  Created by user144818 on 9/20/18.
//  Copyright © 2018 user144818. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func unitsSelected(from:String, to:String)
}

class SettingsViewController: UIViewController {

    
    //Labels and picker
    @IBOutlet weak var fromUnits: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toUnits: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    //Picker properties
    var pickerData: [String] = [String]()//Contains a list of strings
    var delegate: SettingsViewControllerDelegate?//Delegate who uses this
    var whichLabel: Bool? //True means from label selected, false means to label selected.
    
    //Regular variables
    var mode: Bool?//Unit mode True = length, False = volume
    var toText: String?
    var fromText: String?
    var save: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ADD GESTURE RECOGNIZERS
        let tapFromLabelGesture = UITapGestureRecognizer(target: self, action: #selector(self.fromLabelTapped))
        let tapToLabelGesture =
        UITapGestureRecognizer(target: self, action: #selector(self.toLabelTapped))
        self.fromLabel.addGestureRecognizer(tapFromLabelGesture)
        self.toLabel.addGestureRecognizer(tapToLabelGesture)
    
        //SET UP LABEL TEXT
        self.fromUnits.text = self.fromText
        self.toUnits.text   = self.toText
        
        
        //SET UP PICKERDATA
        if let mode_val = self.mode{
            if mode_val{
                self.pickerData = ["Yards","Meters","Miles"]
            } else {
                self.pickerData = ["Quarts","Liters","Gallons"]
            }
        }
        
        self.picker.delegate   = self
        self.picker.dataSource = self
        self.picker.isHidden   = true
        self.view.addSubview(picker)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //Dismiss screen with cancel
        print("cancel button pressed")
        self.save = false
        self.viewWillDisappear(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //Dismiss screen with save
        print("Save button pressed")
        self.save = true
        
        //Send new units to delegate
        self.viewWillDisappear(true)
        self.dismiss(animated: true, completion: nil)
    }
    
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Entered view will diappear")
        
       if(self.save!){
            print("Saving changes")
            if let d = self.delegate {
                d.unitsSelected(from: self.fromUnits.text!, to: self.toUnits.text!)
            }
        }else{
            print("Exit without saving")
        }
    }
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.picker.isHidden = true
        self.view.endEditing(true)
    }
    
    @objc func fromLabelTapped(){
        print("from label tapped")
        self.whichLabel = true
        self.picker.isHidden = false
        self.picker.becomeFirstResponder()
    }
    
    @objc func toLabelTapped(){
        print("to label tapped")
        self.whichLabel = false
        self.picker.isHidden = false
        self.picker.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    //Number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    //Number of columns in data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Current selected item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    //When I select something what did I select
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(self.whichLabel!){
            self.fromUnits.text = self.pickerData[row]
        }else{
            self.toUnits.text = self.pickerData[row]
        }
    }
}

