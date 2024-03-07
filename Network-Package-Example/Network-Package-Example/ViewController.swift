//
//  ViewController.swift
//  Network-Package-Example
//
//  Created by sparkout on 07/03/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel: ViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
    }
    
    @IBAction func generateButtonTapped(_ sender: UIButton) {
        self.startLoading(true)
        guard let numberText = textField.text, let number = Int(numberText) else {
            self.presentAlert(with: "❌ Please enter valid number ❌")
            self.startLoading(false)
            return
        }
        self.viewModel.getRandomNumber(id: number) { title in
            self.startLoading(false)
            if let title {
                self.presentAlert(with: title)
            } else {
                self.presentAlert(with: "❌ Please enter valid number ❌")
            }
        }
    }
    
    func startLoading(_ load: Bool) {
        self.generateButton.isHidden = load
        self.activityIndicator.isHidden = !load
        load ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    }
}

extension UIViewController {
    private func present(_ dismissableAlert: UIAlertController) {
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        dismissableAlert.addAction(dismissAction)
        present(dismissableAlert, animated: true)
    }
    
    func presentAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert)
    }
    
    func present(_ error: Error) {
        presentAlert(with: error.localizedDescription)
    }
    
}

