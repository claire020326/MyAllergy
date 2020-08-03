//
//  ViewController.swift
//  MyAllergy
//
//  Created by grace guo on 7/27/20.
//

import UIKit
import UserNotifications

extension String {
    mutating func addString(str: String) {
        self = self + str
    }
}

class ViewController: UIViewController, UIScrollViewDelegate {
    
     private func configureTextFields() {
         breakfastFoods.delegate = self
         lunchFoods.delegate = self
         dinnerFoods.delegate = self
         symptomsValue.delegate = self
     }
    
    
    @IBOutlet weak var breakfastFoods: UITextField!
    
    @IBOutlet weak var lunchFoods: UITextField!
    
    @IBOutlet weak var dinnerFoods: UITextField!

    @IBOutlet weak var symptomsValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapGesture()
        configureTextFields()
    }
    
    // tap button effects
    @IBAction func submitTapped(_ sender: UIButton) {
        var breakfast = breakfastFoods.text!
        var lunch = lunchFoods.text!
        var dinner = dinnerFoods.text!
        var symptoms = symptomsValue.text!
        var meals = breakfast + ", " + lunch + ", " + dinner + ": " + symptoms + "\n"
        
        let file = "allergy_log_file.txt"

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: file) {
                
                var new_meals = ""
                
                //reading existing file
                do {
                    let old_meals = try String(contentsOf: fileURL, encoding: .utf8)
                    new_meals = old_meals + meals
                } catch {/* error handling here */}
                
                //writing into the files
                do {
                    try new_meals.write(to: fileURL, atomically: false, encoding: .utf8)
                } catch {/* error handling here */}

                //reading the revised file
                do {
                    let new_meals1 = try String(contentsOf: fileURL, encoding: .utf8)
                    print(new_meals1)
                } catch {/* error handling here */}
                
                } else {
                    //writing new file
                    do {
                        try meals.write(to: fileURL, atomically: false, encoding: .utf8)
                    } catch {/* error handling here */}

                    var new_meals = ""
                    
                    //reading new file
                    do {
                        let old_meals = try String(contentsOf: fileURL, encoding: .utf8)
                        print(old_meals)
                    } catch {/* error handling here */}
                }
            
            self.breakfastFoods.text = ""
            self.lunchFoods.text = ""
            self.dinnerFoods.text = ""
            self.symptomsValue.text = ""
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // notifications
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
            if granted {
                print("Yay")
            } else {
                print("Uh oh")
            }
        }
    }
    // notifications for breakfast
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to enter in what you just ate for breakfast!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    // notifications for lunch
    @objc func scheduleLocal1() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to enter in what you just ate for lunch!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 1
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    // notifications for dinner
    @objc func scheduleLocal2() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to enter in what you just ate for dinner!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    // made keyboard go away when tapped outside of a text box
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // made keyboard go away when tapped outside of a text box
    @objc func handleTap() {
        print("Handle tap was called")
        view.endEditing(true)
    }
}

// keyboard go away when tapped outside of a text box
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

