//
//  ViewController.swift
//  MyAllergy
//
//  Created by grace guo on 7/27/20.
//

import UIKit

class ViewController: UIViewController {
    
    
     private func configureTextFields() {
         breakfastFoods.delegate = self
         lunchFoods.delegate = self
         dinnerFoods.delegate = self
         symptomsValue.delegate = self
     }
    
    @IBOutlet weak var breakfastFoods: UITextField!
    let breakfast: String = ""
    var breakfast = breakfastFoods.inputView
    
    @IBOutlet weak var lunchFoods: UITextField!
    let lunch: String = ""
    
    @IBOutlet weak var dinnerFoods: UITextField!
    let dinner: String = ""

    @IBOutlet weak var symptomsValue: UITextField!
    let symptoms: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // made keyboard go down when tapped outside of a text box
        configureTapGesture()
        configureTextFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // made text box go away when tapped outside of a text box
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // made text box go away when tapped outside of a text box
    @objc func handleTap() {
        print("Handle tap was called")
        view.endEditing(true)
    }
   
}

// made text box go away when tapped outside of a text box
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

    
