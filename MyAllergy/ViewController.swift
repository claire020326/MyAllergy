//
//  ViewController.swift
//  MyAllergy
//
//  Created by grace guo on 7/27/20.
//

import UIKit
import UserNotifications

struct Log : Codable {
    var breakfast: String
    var lunch: String
    var dinner: String
    var otherMeals: String
    var symptom : String
}

func mergeFood(log: Log) -> String{
    
    return [log.breakfast, log.lunch, log.dinner, log.otherMeals].joined(separator: ", ")
}

//reads the JSON file out
func loadFile(pathName: URL) -> [String: Log]{

    var logs: [String: Log] = [String: Log]()
    
    let fileExists = (try? pathName.checkResourceIsReachable()) ?? false
    if fileExists {
        do{
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            logs = try decoder.decode([String: Log].self, from: jsonData)
        } catch {}
    }
    return logs
}

//writes into the JSON file
func writeToFile(pathName: URL, logs: [String: Log]) {
    do{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let JsonData = try encoder.encode(logs)
        try JsonData.write(to: pathName)
    }catch{}
}

//appends new data into the JSON file
func addEntry(pathName: URL, newDate: String, newLog: Log) {
    var logs: [String: Log] = loadFile(pathName: pathName)
    logs[newDate] = newLog
    writeToFile(pathName: pathName, logs: logs)
}

extension String {
    mutating func addString(str: String) {
        self = self + str
    }
}

let file = "allergyLogFile.json"

class ViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var dateChosen = ""
//    var symptom = ""
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
        
        overrideUserInterfaceStyle = .light
    }
    
    // tap button effects
    @IBAction func submitTapped(_ sender: UIButton) {
        
        // get date
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateChosen = dateFormatter.string(from: datePicker.date)
        
        // get breakfast, lunch and dinner
        var breakfast = breakfastFoods.text!
        var lunch = lunchFoods.text!
        var dinner = dinnerFoods.text!
        
        // clean up breakfast, lunch, dinner
        if breakfast.contains(":") {
            breakfast = breakfast.replacingOccurrences(of: ":", with: "")
        }
        if lunch.contains(":") {
            lunch = lunch.replacingOccurrences(of: ":", with: "")
        }
        if dinner.contains(":") {
            dinner = dinner.replacingOccurrences(of: ":", with: "")
        }
        
        // get the selected symptoms
        let symptom = symptomList[symptomPicker.selectedRow(inComponent: 0)]
        
        // update the log file with today's info
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            // create newLog and add it into existing log file
            let newLog = Log(breakfast: breakfast, lunch: lunch, dinner: dinner, otherMeals: "", symptom: symptom)
            addEntry(pathName: fileURL, newDate: dateChosen, newLog: newLog)
//
            // read out the new file to verify
            let loadedLogs = loadFile(pathName: fileURL)
            print(loadedLogs)
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

