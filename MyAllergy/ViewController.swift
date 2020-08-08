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
    var snacks: String
    var symptom : String
}

func mergeFood(log: Log) -> String{
    
    return [log.breakfast, log.lunch, log.dinner, log.snacks].joined(separator: ", ")
}

// labeling dir and fileURL
let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
let fileURL = dir?.appendingPathComponent(file)

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

class ViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    var dateChosen = ""
    var symptomList: [String] = [String]()
    
    private func configureTextFields() {
         breakfastFoods.delegate = self
         lunchFoods.delegate = self
         dinnerFoods.delegate = self
         snacksFoods.delegate = self
     }
    
    @IBOutlet weak var breakfastFoods: UITextView!
    
    @IBOutlet weak var lunchFoods: UITextView!
    
    @IBOutlet weak var dinnerFoods: UITextView!
    
    @IBOutlet weak var snacksFoods: UITextView!
    
    @IBOutlet weak var symptomPicker: UIPickerView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
        let fileExists = (try? fileURL!.checkResourceIsReachable()) ?? false
        if fileExists {
            let loadedLogs = loadFile(pathName: fileURL!)
            
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateChosen = dateFormatter.string(from: datePicker.date)
            
            // Get the dictionary key (all existing dates) and see if it contains the chosen date
            let existingDates = loadedLogs.keys
            if existingDates.contains(dateChosen){
                let oldLog = loadedLogs[dateChosen]
                breakfastFoods.text = oldLog?.breakfast
                lunchFoods.text = oldLog?.lunch
                dinnerFoods.text = oldLog?.dinner
                snacksFoods.text = oldLog?.snacks
                
                let row = symptomList.firstIndex(of: oldLog!.symptom)
                symptomPicker.selectRow(row!, inComponent: 0, animated: false)

            }
        }
    }
//
//    // placeholder for breakfast text view
//    func breakfastTextViewDidBeginEditing(_ textView: UITextView) {
//        if breakfastFoods.textColor == UIColor.lightGray {
//            breakfastFoods.text = ""
//            breakfastFoods.textColor = UIColor.black
//        }
//    }
//    func breakfastTextViewDidEndEditing(_ textView: UITextView) {
//        if breakfastFoods.text == "" {
//            breakfastFoods.text = "i.e. egg, milk, cereal, bread"
//            breakfastFoods.textColor = UIColor.lightGray
//        }
//    }
//
//    // placeholder for lunch text view
//    func lunchTextViewDidBeginEditing(_ textView: UITextView) {
//        if lunchFoods.textColor == UIColor.lightGray {
//            lunchFoods.text = ""
//            lunchFoods.textColor = UIColor.black
//        }
//    }
//    func lunchTextViewDidEndEditing(_ textView: UITextView) {
//        if lunchFoods.text == "" {
//            lunchFoods.text = "i.e. spaghetti, tomato, meatball"
//            lunchFoods.textColor = UIColor.lightGray
//        }
//    }
//
//    // placeholder for dinner text view
//    func dinnerTextViewDidBeginEditing(_ textView: UITextView) {
//        if dinnerFoods.textColor == UIColor.lightGray {
//            dinnerFoods.text = ""
//            dinnerFoods.textColor = UIColor.black
//        }
//    }
//    func dinnerTextViewDidEndEditing(_ textView: UITextView) {
//        if dinnerFoods.text == "" {
//            dinnerFoods.text = "i.e. potato, steak, gravy, beans, carrot"
//            dinnerFoods.textColor = UIColor.lightGray
//        }
//    }
//
//    // placeholder for snacks text view
//    func snacksTextViewDidBeginEditing(_ textView: UITextView) {
//        if snacksFoods.textColor == UIColor.lightGray {
//            snacksFoods.text = ""
//            snacksFoods.textColor = UIColor.black
//        }
//    }
//    func snacksTextViewDidEndEditing(_ textView: UITextView) {
//        if snacksFoods.text == "" {
//            snacksFoods.text = "i.e. strawberry, blueberry, potato chips"
//            snacksFoods.textColor = UIColor.lightGray
//        }
//    }

    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapGesture()
        configureTextFields()
        
        // adding borders to text views
        self.breakfastFoods.layer.borderWidth = 2
        self.breakfastFoods.layer.borderColor = UIColor.gray.cgColor
        self.breakfastFoods.layer.cornerRadius = 6
        
        self.lunchFoods.layer.borderWidth = 2
        self.lunchFoods.layer.borderColor = UIColor.gray.cgColor
        self.lunchFoods.layer.cornerRadius = 6
        
        self.dinnerFoods.layer.borderWidth = 2
        self.dinnerFoods.layer.borderColor = UIColor.gray.cgColor
        self.dinnerFoods.layer.cornerRadius = 6
        
        self.snacksFoods.layer.borderWidth = 2
        self.snacksFoods.layer.borderColor = UIColor.gray.cgColor
        self.snacksFoods.layer.cornerRadius = 6
        
//        // placeholders for the foods text view
//        breakfastFoods.delegate = self
//        breakfastFoods.text = "i.e. egg, milk, cereal, bread"
//        breakfastFoods.textColor = UIColor.lightGray
//        lunchFoods.delegate = self
//        lunchFoods.text = "i.e. spaghetti, tomato, meatball"
//        lunchFoods.textColor = UIColor.lightGray
//        dinnerFoods.delegate = self
//        dinnerFoods.text = "i.e. potato, steak, gravy, beans, carrot"
//        dinnerFoods.textColor = UIColor.lightGray
//        snacksFoods.delegate = self
//        snacksFoods.text = "i.e. strawberry, blueberry, potato chips"
//        snacksFoods.textColor = UIColor.lightGray
//
//        breakfastTextViewDidBeginEditing(breakfastFoods)
//        breakfastTextViewDidEndEditing(breakfastFoods)
//
//        lunchTextViewDidBeginEditing(lunchFoods)
//        lunchTextViewDidEndEditing(lunchFoods)
//
//        dinnerTextViewDidBeginEditing(dinnerFoods)
//        dinnerTextViewDidEndEditing(dinnerFoods)
//
//        snacksTextViewDidBeginEditing(snacksFoods)
//        snacksTextViewDidEndEditing(snacksFoods)
        
        symptomList = ["good", "ok", "bad", "terrible"]
        
        overrideUserInterfaceStyle = .light
        datePicker.maximumDate = Date()
    }
    
    // tap button effects
    @IBAction func submitTapped(_ sender: UIButton) {
        
        // get date
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateChosen = dateFormatter.string(from: datePicker.date)
        
        // get breakfast, lunch and dinner, snacks
        var breakfast = breakfastFoods.text!
        var lunch = lunchFoods.text!
        var dinner = dinnerFoods.text!
        var snacks = snacksFoods.text!
        
        // clean up breakfast, lunch, dinner, snacks
        if breakfast.contains(":") {
            breakfast = breakfast.replacingOccurrences(of: ":", with: "")
        }
        if lunch.contains(":") {
            lunch = lunch.replacingOccurrences(of: ":", with: "")
        }
        if dinner.contains(":") {
            dinner = dinner.replacingOccurrences(of: ":", with: "")
        }
        if snacks.contains(":") {
            snacks = snacks.replacingOccurrences(of: ":", with: "")
        }
        
        // get the selected symptoms
        let symptom = symptomList[symptomPicker.selectedRow(inComponent: 0)]
        
        // update the log file with today's info
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            // create newLog and add it into existing log file
            let newLog = Log(breakfast: breakfast, lunch: lunch, dinner: dinner, snacks: snacks, symptom: symptom)
            addEntry(pathName: fileURL!, newDate: dateChosen, newLog: newLog)
//
            // read out the new file to verify
            let loadedLogs = loadFile(pathName: fileURL!)
            print(loadedLogs)
        }
        
        // clean up the text fields
        self.breakfastFoods.text = ""
        self.lunchFoods.text = ""
        self.dinnerFoods.text = ""
        self.snacksFoods.text = ""
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
        content.body = "It's time to enter in what you just ate for dinner and all your snacks/ other meals today!"
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
