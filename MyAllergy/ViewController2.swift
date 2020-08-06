//
//  ViewController2.swift
//  MyAllergy
//
//  Created by grace guo on 8/4/20.
//

import UIKit

var foodAndSymptoms = ""

class ViewController2: UIViewController, UITextViewDelegate {

    // creating string to hold everything in the log file
    var fullLogStr = ""
    
    private func configureTextView() {
        allergensTextView.delegate = self
    }
    
    @IBOutlet weak var allergensTextView: UITextView!
    
    @IBAction func predictTapped(_ sender: UIButton) {
        
        var fullLog:[String: Log] = [String:Log]()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
                
            // reading existing file
            fullLog = loadFile(pathName: fileURL)
                
            print(fullLog)
            print("fullLog")
        }
        
        // creating an array of just good foods
        var foodOnGoodDaysArr: [String] = [String]()
        for (date, log) in fullLog {
            if (log.symptom == "good"){
                foodOnGoodDaysArr.append(mergeFood(log: log))
            }
        }

        // creating an array of potential bad foods
        var foodOnBadDaysArr: [String] = [String]()
        for (date, log) in fullLog {
            if (log.symptom == "bad"){
                foodOnBadDaysArr.append(mergeFood(log: log))
            }
        }
        
        // creating an array of potential terrible foods
        var foodOnTerribleDaysArr: [String] = [String]()
        for (date, log) in fullLog {
            if (log.symptom == "terrible"){
                foodOnTerribleDaysArr.append(mergeFood(log: log))
            }
        }
        
        // merging bad and terrible string into one array
        let badAndTerribleFoodsArr = foodOnBadDaysArr + foodOnTerribleDaysArr

        print(badAndTerribleFoodsArr)
            
        // making all the strings in bad and terrible foods array separated by commas
        var revisedBadAndTerribleFoodsArr: [String] = [String]()
        for x in badAndTerribleFoodsArr{
            let revised = x.components(separatedBy: ", ")
            revisedBadAndTerribleFoodsArr.append(contentsOf: revised)
        }

        // making a dictionary with the frequencies of all bad and terrible foods list items
        let foodFreqDictOnBadAndTerribleDays = revisedBadAndTerribleFoodsArr.map { ($0, 1) }
        let badAndTerribleDict = Dictionary(foodFreqDictOnBadAndTerribleDays, uniquingKeysWith: +)

        print(badAndTerribleDict)
        print("badAndTerribleDict")

        // building a potential high risk foods list and adding bad and terrible foods with high frequencies into it
        var potentialHighRiskFoodsArr: [String] = [String]()
        for (food, frequency) in badAndTerribleDict {
            if frequency > 3 {
                potentialHighRiskFoodsArr.append(food)
            }
        }

        // removing all foods in potential high risk foods list that are also in good foods list
        var allergens: [String] = [String]()
        for x in potentialHighRiskFoodsArr {
            if !foodOnGoodDaysArr.contains(x) {
                allergens.append(x)
            }
        }

        allergensTextView.text = allergens.joined(separator: "\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
    }

}

