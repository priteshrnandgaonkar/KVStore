//
//  ViewController.swift
//  KVStoreExample
//
//  Created by Pritesh Nandgaonkar on 12/2/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import UIKit
import KVStore

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var insertKeyTextField: UITextField!
    @IBOutlet weak var insertValueTextField: UITextField!
    @IBOutlet weak var fetchTextField: UITextField!
    @IBOutlet weak var deleteTextField: UITextField!
    
    var storeManager: KVStoreManager<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            storeManager = try KVStoreManager(with: "TestKVPersistence")
        }
        catch (let error) {
            showAlert(withTitle: "Error", buttonTitle: "OK", message: error.localizedDescription, okAction: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func insertTapped(_ sender: UIButton) {
        let key = insertKeyTextField.text
        let value = insertValueTextField.text
        
        guard let keyUnwrapped = key, let valueUnwrapped = value, valueUnwrapped.characters.count > 0, keyUnwrapped.characters.count > 0 else {
            showAlert(withTitle: "Error", buttonTitle: "OK", message: "Either key or Data is empty. Please add something", okAction: nil)
            return
        }
        
        do {
            
         try storeManager.insert(value: valueUnwrapped.data(using: String.Encoding.utf8)!, for: keyUnwrapped)
        showAlert(withTitle: "Success", buttonTitle: "OK", message: "Successfully added key value pair in database", okAction: nil)
            
        } catch (let error) {
            showAlert(withTitle: "Error", buttonTitle: "OK", message: error.localizedDescription, okAction: nil)

        }
    }
    
    @IBAction func fetchTapped(_ sender: UIButton) {
        let key = fetchTextField.text
        
        guard let keyUnwrapped = key, keyUnwrapped.characters.count > 0 else {
            showAlert(withTitle: "Error", buttonTitle: "OK", message: "Key is empty. Key should have atleast one character", okAction: nil)
            return
        }
        
        let data = storeManager[keyUnwrapped] //storeManager.getValue(for: keyUnwrapped)
        guard let unwrappedData = data, let fetchedString = String(data: unwrappedData, encoding: .utf8) else {
            showAlert(withTitle: "Error", buttonTitle: "OK", message: "Failed to get value for \(keyUnwrapped)", okAction: nil)
            return
        }
        
        showAlert(withTitle: "Success", buttonTitle: "OK", message: "Successfully Fetched Value. Your Key: \(keyUnwrapped), Value: \(fetchedString)", okAction: nil)
        
    }
    
    @IBAction func tappedDelete(_ sender: UIButton) {
        let key = deleteTextField.text
        guard let keyUnwrapped = key, keyUnwrapped.characters.count > 0 else {
            showAlert(withTitle: "Error", buttonTitle: "OK", message: "Key is empty. Key should have atleast one character", okAction: nil)
            return
        }
        
        do {
            
            try storeManager.deleteValue(for: keyUnwrapped)
            showAlert(withTitle: "Success", buttonTitle: "OK", message: "Successfully Deleted Key. \(keyUnwrapped)", okAction: nil)
            
        } catch (let error) {
            var errorMessage = error.localizedDescription
            if let sqliteError = error as? SQLiteError {
                errorMessage = sqliteError.description
            }
            showAlert(withTitle: "Error", buttonTitle: "OK", message: errorMessage, okAction: nil)
            
        }
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, buttonTitle: String, message: String, okAction: (()->())?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { action in okAction?() }
        
        controller.addAction(action)
        
        self.present(controller, animated: true, completion: nil)

    }
}
