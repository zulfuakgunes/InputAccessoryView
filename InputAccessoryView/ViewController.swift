//
//  ViewController.swift
//  InputAccessoryView
//
//  Created by Zülfü Akgüneş on 25.01.2024.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // Button on the main screen
    lazy var addWordButton: UIButton = {
        let button = UIButton(type: .system)
        let plusIcon = UIImage(systemName: "plus")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setImage(plusIcon, for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(addWordButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        view.addSubview(button)
        return button
    }()
    
//     Stack View for holding textField and button
    lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(accessoryTextField)
        stackView.addArrangedSubview(accessoryButton)
        return stackView
    }()
    
    lazy var hiddenTextField: UITextField = {
        let textField = UITextField()
        textField.isHidden = true
        textField.inputAccessoryView = accessoryViewToolbar
        view.addSubview(textField)
        
        textField.placeholder = "Type something..."
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // Text Field
    lazy var accessoryTextField: UITextField = {
        let textField = UITextField()
        textField.isEnabled = true
        textField.placeholder = "Type something..."
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.inputAccessoryView = accessoryViewToolbar
//        accessoryViewToolbar.addSubview(textField)
        return textField
    }()

    // Button on Accessory View
    lazy var accessoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Background dimming view
    lazy var dimmingView: UIView = {
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimView.alpha = 0 // Başlangıçta görünmez
        view.addSubview(dimView)
        dimView.translatesAutoresizingMaskIntoConstraints = false

        return dimView
    }()
    
    lazy var accessoryViewToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let containerItem = UIBarButtonItem(customView: inputStackView)
        
        toolbar.setItems([containerItem], animated: false)
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutUI()
        setupKeyboardNotifications()
    }
    
    private func layoutUI() {   
        setupAddWordButton()
        setupInputStackView()
        setupDimmingView()
    }
    
    // Klavye olaylarını dinlemek için NotificationCenter ayarlamaları
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {

        // Klavye açıldığında dimmingView'i göster
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {

        // Klavye kapandığında dimmingView'i gizle
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func accessoryButtonTapped() {
        DispatchQueue.main.async {
            self.accessoryTextField.resignFirstResponder()
            self.hiddenTextField.resignFirstResponder()
        }
        
    }
    
    @objc private func addWordButtonTapped() {
        // Make textField become the first responder
        print("Add button tapped")
        DispatchQueue.main.async {
            self.hiddenTextField.becomeFirstResponder()
            self.accessoryTextField.becomeFirstResponder()
        }
    }
    
}

extension ViewController {
    func setupAddWordButton() {
        NSLayoutConstraint.activate([
            addWordButton.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor, constant: -30),
            addWordButton.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            addWordButton.heightAnchor.constraint(
                    equalToConstant: 60),
            addWordButton.widthAnchor.constraint(
                    equalToConstant: 60)])
        
    }
        
    func setupInputStackView() {
        NSLayoutConstraint.activate([
            inputStackView.heightAnchor.constraint(equalTo: accessoryTextField.heightAnchor)
        ])
    }
    
    func setupDimmingView() {
        NSLayoutConstraint.activate([
                dimmingView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor),
                dimmingView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor),
                dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                dimmingView.topAnchor.constraint(equalTo: view.topAnchor)])
    }
}
