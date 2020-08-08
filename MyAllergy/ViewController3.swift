//
//  ViewController3.swift
//  MyAllergy
//
//  Created by grace guo on 8/7/20.
//

import UIKit
import MessageUI
import Foundation

class ViewController3: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {

//    func showSendMailErrorAlert() {
//        let alert = UIAlertController(title: "Error:", message: "Unfortunately your request could not be completed. Please try again at another time and we're very sorry for any inconvenience.", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//    }

    @IBOutlet weak var feedbackView: UITextView!
    
    @IBOutlet weak var subjectView: UITextView!
    
    @IBAction func submitTapped(_ sender: UIButton) {
        
        if subjectView.text == nil {
            let subjectAlert = UIAlertController(title: "Subject Error:", message: "Unfortunately your message cannot be sent with an empty subject. Please fill in the subject box.", preferredStyle: .alert)

            subjectAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
            
        if let subjectText = subjectView.text {
            picker.setSubject(subjectText)
        }
        picker.setMessageBody(feedbackView.text, isHTML: true)
    }
    
    func mailComposeViewController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
         dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            
        return true
    }
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        feedbackView.text = textView.text
            
        if text == "\n" {
            textView.resignFirstResponder()
                
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackView.delegate = self
        
        configureTapGesture()
        
        // adding border to feedback text view
        self.feedbackView.layer.borderWidth = 2
        self.feedbackView.layer.borderColor = UIColor.gray.cgColor
        self.feedbackView.layer.cornerRadius = 6
        
        // adding border to subject text view
        self.subjectView.layer.borderWidth = 2
        self.subjectView.layer.borderColor = UIColor.gray.cgColor
        self.subjectView.layer.cornerRadius = 6
        
        overrideUserInterfaceStyle = .light
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
extension ViewController3: UITextFieldDelegate {
    private func textFieldShouldReturnVC3(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
