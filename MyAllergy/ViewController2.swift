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
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
        let fileURL = dir.appendingPathComponent(file)
            
        // reading existing file
        do {
            fullLogStr = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {/* error handling here */}
        }
        
        // removes slashes and numbers and colons (removes dates and colons)
        var fullLogCleanStr = fullLogStr.components(separatedBy: CharacterSet.decimalDigits).joined()
        fullLogCleanStr = String(fullLogStr).replacingOccurrences(of: ":", with: "")
        fullLogCleanStr = String(fullLogCleanStr).replacingOccurrences(of: "/", with: "")
        
        // creating a string of just good foods
        let logForGoodDaysStr = String(fullLogCleanStr).contains("good")
        var foodOnGoodDaysStr = String(logForGoodDaysStr).replacingOccurrences(of: "good", with: "")
        
        // forming an array of all foods eaten on good days
        var goodFoodsArr = foodOnGoodDaysStr.components(separatedBy: ",")
        
        // creating a string of potential bad foods
        var logForBadDaysStr = String(fullLogCleanStr).contains("bad")
        var foodOnBadDaysStr = String(logForBadDaysStr).replacingOccurrences(of: "bad", with: "")
        
        // creating a string of potential terribel foods
        var logForTerribleDaysStr = String(fullLogCleanStr).contains("terrible")
        var foodOnTerribleDays = String(logForTerribleDaysStr).replacingOccurrences(of: "terrible", with: "")
        
        // merging bad and terrible string into one string
        var badAndTerribleFoodsStr = foodOnBadDaysStr + foodOnTerribleDays
        
        // forming an array of all foods eaten on bad and terrible days
        var badAndTerribleFoodsListArr = badAndTerribleFoodsStr.components(separatedBy: ",")
        
        // making a dictionary with the frequencies of all bad and terrible foods list items
        let foodFreqDictOnBadAndTerribleDays = badAndTerribleFoodsListArr.map { ($0, 1) }
        var badAndTerribleDict = Dictionary(foodFreqDictOnBadAndTerribleDays, uniquingKeysWith: +)
        
        // building a potential high risk foods list and adding bad and terrible foods with high frequencies into it
        var potentialHighRiskFoodsArr: [String] = [String]()
        for (food, frequency) in badAndTerribleDict {
            if frequency > 3 {
                print(food)
                potentialHighRiskFoodsArr.append(food)
            }
        }
        print(potentialHighRiskFoodsArr)
        
        // removing all foods in potential high risk foods list that are also in good foods list
        var allergens: [String] = [String]()
        for x in potentialHighRiskFoodsArr {
            if !goodFoodsArr.contains(x) {
                allergens.append(x)
            }
        }
        
        allergensTextView.text = allergens.joined(separator: "\n")
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
