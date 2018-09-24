//
//  ViewController.swift
//  UnitConversionApp
//
//  Created by user144818 on 9/17/18.
//  Copyright © 2018 user144818. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, SettingsViewControllerDelegate {
    //Outlets
    @IBOutlet weak var toLabel:         UILabel!
    @IBOutlet weak var fromLabel:       UILabel!
    @IBOutlet weak var conversionLabel: UILabel!
    @IBOutlet weak var fromField:       UITextField!
    @IBOutlet weak var toField:         UITextField!
    
    //Instance Variables (Default Val)
    var lengthFromUnit = "Yards"
    var lengthToUnit   = "Meters"
    var volumeFromUnit = "Quarts"
    var volumeToUnit   = "Liters"
    
    //Distance Conversion Constants
    let yardsToMeters   = 0.9144000
    let yardsToMiles    = 0.0005680
    
    let metersToYards   = 1.0936100
    let metersToMiles   = 0.0006210
    
    let milesToYards    = 1760.0000
    let milesToMeters   = 1609.3400
    
    //Volume Conversion Constants
    let litersToGallons = 0.2641720
    let litersToQuarts  = 1.0566900
    
    let quartsToGallons = 0.2500000
    let quartsToLiters  = 0.9463530
    
    let gallonsToLiters = 3.7845310
    let gallonsToQuarts = 4.0000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
        //Set delegate attribute for both fields
        fromField.delegate = self
        toField.delegate = self
    }

    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Get conversion constants
    func getConversionConstant(_ units: String) -> Double {
        let conversionConstant: Double
        switch units {
            case "Yards-Meters":
                conversionConstant = self.yardsToMeters
            case "Yards-Miles":
                conversionConstant = self.yardsToMiles
            case "Meters-Yards":
                conversionConstant = self.metersToYards
            case "Meters-Miles":
                conversionConstant = self.metersToMiles
            case "Miles-Yards":
                conversionConstant = self.milesToYards
            case "Miles-Meters":
                conversionConstant = self.milesToMeters
            case "Quarts-Liters":
                conversionConstant = self.quartsToLiters
            case "Quarts-Gallons":
                conversionConstant = self.quartsToGallons
            case "Liters-Quarts":
                conversionConstant = self.litersToQuarts
            case "Liters-Gallons":
                conversionConstant = self.litersToGallons
            case "Gallons-Quarts":
                conversionConstant = self.gallonsToQuarts
            case "Gallons-Liters":
                conversionConstant = self.gallonsToLiters
            default:
                conversionConstant = 1.0
        }
        return conversionConstant
    }
    
    @IBAction func calculatePressed(_ sender: UIButton){
     
        let conversionConstant: Double
        
        //From - To conversion
        if self.fromField.text != "" {
            
            conversionConstant = getConversionConstant("\(self.fromLabel.text!)-\(self.toLabel.text!)")
            
            self.toField.text = String((Double(self.fromField.text!)! * conversionConstant))
        }
        
        //To - from conversion
        else if self.toField.text != "" {
           
            conversionConstant = getConversionConstant("\(self.toLabel.text!)-\(self.fromLabel.text!)")
            
            self.fromField.text = String((Double(self.toField.text!)! * conversionConstant))
        }
        self.dismissKeyboard()
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        self.dismissKeyboard()
        self.fromField.text = ""
        self.toField.text = ""
    }
    
    @IBAction func modePressed(_ sender: UIButton) {
        //If we are in length switch to volume
        if self.fromLabel.text! == lengthFromUnit {
            self.fromLabel.text = self.volumeFromUnit
            self.toLabel.text   = self.volumeToUnit
        }//Otherwise switch to length
        else{
            self.fromLabel.text = self.lengthFromUnit
            self.toLabel.text   = self.lengthToUnit
        }
    }
    
    
    //Function from settinsViewControllerDelegate protocl
    func unitsSelected(from: String, to: String) {
        
        //If we are in length mode
        if self.fromLabel.text! == lengthFromUnit {
            print("from: \(from) to: \(to)")
            self.fromLabel.text = from
            self.toLabel.text   = to
            self.lengthToUnit   = to
            self.lengthFromUnit = from
        }else{
        //If we are in volume
            print("from: \(from) to: \(to)")
            self.fromLabel.text = from
            self.toLabel.text   = to
            self.volumeToUnit   = to
            self.volumeFromUnit = from
            
        }
    }
    
    //Function to tell setings that I am the delegate and to send current unit lables and mode
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToSettings"{
            if let dest = segue.destination.childViewControllers[0] as? SettingsViewController {
            
                //Set up labels and delegate
                print(self.toLabel.text!)
                print(self.fromLabel.text!)
                dest.toText         = self.toLabel.text!
                dest.fromText       = self.fromLabel.text!
                dest.delegate       = self
                
                //Set up mode
                if self.fromLabel.text! == "Miles" || self.fromLabel.text! == "Yards" || self.fromLabel.text! == "Meters"{
                    dest.mode = true
                }else{
                    dest.mode = false
                }
            }
        }
    }
    
@IBAction func exitSettings(segue: UIStoryboardSegue){
       print("Returned from settings")
}

}

extension CalculatorViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //If we are writing to the yard field
        if textField == self.fromField {
            self.toField.text = ""
        }
        
        //If we are writing to the meters field
        if textField == self.toField{
            self.fromField.text = ""
        }
    }
}

