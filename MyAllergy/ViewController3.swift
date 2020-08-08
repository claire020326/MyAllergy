//
//  ViewController3.swift
//  MyAllergy
//
//  Created by grace guo on 8/7/20.
//

import UIKit
import MessageUI

class ViewController3: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    private func configureTextView() {
        feedbackView.delegate = self
    }

    @IBOutlet weak var feedbackView: UITextView!
    
    @IBAction func submitTapped(_ sender: UIButton) {
        let feedback = feedbackView.text!
        
        func sendEmail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["allergydiagnosisforall@gmail.com"])
            composeVC.setSubject("Feedback for MyAllergy App")
            composeVC.setMessageBody(feedback, isHTML: false)
            
            self.present(composeVC, animated: true, completion: nil)
        }

        func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            controller.dismiss(animated: true, completion: nil)
        }
        
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "Error:", message: "Unfortunately your request could not be completed. Please try again at another time and we're very sorry for any inconvenience.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
        }
        else {
            sendEmail()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}
