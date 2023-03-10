//
//  AlertBuilder.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-09.
//

import UIKit

struct AlertBuilder {
    let viewController: UIViewController
    
    let title: String?
    let message: String?
    let messageTwo: String?
    let messageThree: String? 

    
    func showAlertWithOKAction(action: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let action = action {
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                action()
            }))
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        }
       
        viewController.present(alert, animated: true)
    }
    
    func showYesNoActionSheet(action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            action()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        viewController.present(alert, animated: true)
    }
    
    func showThreeTextFieldAlerts(action: @escaping ([String]) -> Void) {
        let alert = UIAlertController(title: title, message: "Insert \(message?.lowercased() ?? "")", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = message
        }
        
        let nextAction = UIAlertAction(title: "Next", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            
           showSecondTextField(input: text, action: action)
        }
        alert.addAction(nextAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true)
    }
    
    private func showSecondTextField(input: String, action: @escaping ([String]) -> Void) {
        let alert = UIAlertController(title: title, message: "Insert \(messageTwo?.lowercased() ?? "")", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = messageTwo
        }
        
        let nextAction = UIAlertAction(title: "Next", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            
            showThirdTextField(input: input, secondInput: text, action: action)
        }
        alert.addAction(nextAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true)
    }
    
    private func showThirdTextField(input: String, secondInput: String, action: @escaping ([String]) -> Void) {
        let alert = UIAlertController(title: title, message: "Insert \(messageThree?.lowercased() ?? "")", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = messageThree
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            
            var array: [String] = []
            array.append(input)
            array.append(secondInput)
            array.append(text)
            
            action(array)
            showSuccessTaskCompletedAlert()
        }
        alert.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true)
    }
    
    private func showSuccessTaskCompletedAlert() {
        let alert = UIAlertController(title: "Success!", message: "Task completed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        viewController.present(alert, animated: true)
    }
}
