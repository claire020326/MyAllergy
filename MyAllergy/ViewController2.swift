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
            print(fullLogStr)
            print("fullLogStr")
        } catch {/* error handling here */}
        }
        
        // removes slashes and numbers and colons (removes dates and colons)
//        var fullLogCleanStr = fullLogStr.components(separatedBy: CharacterSet.decimalDigits).joined()
        var fullLogCleanStr = fullLogStr.replacingOccurrences(of: "0", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "1", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "2", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "3", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "4", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "5", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "6", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "7", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "8", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "9", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: ":", with: "")
        fullLogCleanStr = fullLogCleanStr.replacingOccurrences(of: "/", with: "")
        
        var fullLogCleanArr = fullLogCleanStr.components(separatedBy: "\n")
          
        print(fullLogCleanArr)
        print("fullLogCleanArr")
        
        // creating an array of just good foods
        var logForGoodDaysArr: [String] = [String]()

        for x in fullLogCleanArr {
            if x.contains("good"){
            logForGoodDaysArr.append(x)
            }
        }
        
        // forming an array of all foods eaten on good days
        var goodFoodsArr: [String] = [String]()
        for x in logForGoodDaysArr {
            goodFoodsArr.append(x.replacingOccurrences(of: "good", with: ""))
               }

        // creating an array of potential bad foods
        var logForBadDaysArr: [String] = [String]()

        for x in fullLogCleanArr {
            if x.contains("bad"){
            logForBadDaysArr.append(x)
            }
        }
              
        var foodOnBadDaysArr: [String] = [String]()
        for x in logForBadDaysArr {
            foodOnBadDaysArr.append(x.replacingOccurrences(of: "bad", with: ""))
              }
        
        // creating an array of potential terrible foods
        var logForTerribleDaysArr: [String] = [String]()

        for x in fullLogCleanArr {
            if x.contains("terrible"){
            logForTerribleDaysArr.append(x)
            }
        }
        
        var foodOnTerribleDaysArr: [String] = [String]()
        for x in logForTerribleDaysArr {
            foodOnTerribleDaysArr.append(x.replacingOccurrences(of: "terrible", with: ""))
        }
        
        // merging bad and terrible string into one array
        let badAndTerribleFoodsArr = foodOnBadDaysArr + foodOnTerribleDaysArr

        // making all the strings in bad and terrible foods array separated by commas
        var revisedBadAndTerribleFoodsArr: [String] = [String]()
               for x in badAndTerribleFoodsArr{
                       let revised = x.components(separatedBy: ",")
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
            if !goodFoodsArr.contains(x) {
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
