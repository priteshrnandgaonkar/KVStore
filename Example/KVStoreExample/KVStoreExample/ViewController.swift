//
//  ViewController.swift
//  KVStoreExample
//
//  Created by Pritesh Nandgaonkar on 12/2/17.
//  Copyright © 2017 Pritesh Nandgaonkar. All rights reserved.
//

import UIKit
import KVStore

class ViewController: UIViewController {

    @IBOutlet weak var insertKeyTextField: UITextField!
    @IBOutlet weak var insertValueTextField: UITextField!
    @IBOutlet weak var fetchTextField: UITextField!
    @IBOutlet weak var deleteTextField: UITextField!
    
    var storeManager: KVStoreManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            storeManager = try KVStoreManager(with: "TestKVPersistence")
            showAlert(withTitle: "Success", buttonTitle: "OK", message: "Successfully openend Database connection", okAction: nil)
        }
        catch (let error) {
            showAlert(withOKTitle: "OK", message: error.localizedDescription, okAction: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func insertTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func fetchTapped(_ sender: UIButton) {
        
    }
    @IBAction func tappedDelete(_ sender: UIButton) {
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, buttonTitle: String, message: String, okAction: (()->())?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { action in okAction?() }
        
        controller.addAction(action)
        
        present(controller, animated: true, completion: nil)

    }
}
