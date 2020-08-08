//
//  ViewController3.swift
//  MyAllergy
//
//  Created by grace guo on 8/7/20.
//

import UIKit
import MessageUI
import Foundation

class ViewController3: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    var feedback = ""
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        mailComposerVC.setToRecipients(["allergydiagnosisforall@gmail.com"])
        mailComposerVC.setSubject("Feedback for MyAllergy App")
        mailComposerVC.setMessageBody(feedback, isHTML: false)

        return mailComposerVC
    }

    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Unfortunately your request could not be completed. Please try again at another time and we're very sorry for any inconvenience.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        }

    @IBOutlet weak var feedbackView: UITextView!
    
    @IBAction func submitTapped(_ sender: UIButton) {
        feedback = feedbackView.text!
        
        let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapGesture()
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
