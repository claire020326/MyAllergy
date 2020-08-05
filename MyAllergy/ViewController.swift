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

let file = "allergyLogFile.txt"

class ViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dateChosen = ""
    var symptoms = ""
    var symptomList: [String] = [String]()
    
    private func configureTextFields() {
         breakfastFoods.delegate = self
         lunchFoods.delegate = self
         dinnerFoods.delegate = self
     }
    
    @IBOutlet weak var breakfastFoods: UITextField!
    
    @IBOutlet weak var lunchFoods: UITextField!
    
    @IBOutlet weak var dinnerFoods: UITextField!

    @IBOutlet weak var symptomPicker: UIPickerView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
   
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapGesture()
        configureTextFields()
        
        symptomList = ["good", "ok", "bad", "terrible"]
    }
    
    // tap button effects
    @IBAction func submitTapped(_ sender: UIButton) {
        let breakfast = breakfastFoods.text!
        let lunch = lunchFoods.text!
        let dinner = dinnerFoods.text!
        
        // date
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateChosen = dateFormatter.string(from: datePicker.date)
        
        // get the selected symptoms
        symptoms = symptomList[symptomPicker.selectedRow(inComponent: 0)]
        
        // merge all the info
        let newLog = dateChosen + ": " + breakfast + ", " + lunch + ", " + dinner + ": " + symptoms + "\n"
        
        // update the log file with today's info
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            var oldLog = ""
            // if the file exists, load it into oldInfo
            let fileExists = (try? fileURL.checkResourceIsReachable()) ?? false
            if fileExists {
                // reading existing file
                do {
                    oldLog = try String(contentsOf: fileURL, encoding: .utf8)
                } catch {/* error handling here */}
                print("reading existing log file")
            }else{
                print("creating new log file")
            }
            
            // append newInfo to the end of oldInfo -> info
            let fullLog = oldLog + newLog
            
            // write merged info the file
            do {
                try fullLog.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {/* error handling here */}
            
            // read out the new file to verify
            do {
                let temp = try String(contentsOf: fileURL, encoding: .utf8)
                print(temp)
            } catch {/* error handling here */}
        }
        
        // clean up the text field
        self.breakfastFoods.text = ""
        self.lunchFoods.text = ""
        self.dinnerFoods.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int {
        return symptomList.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return symptomList[row]
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

