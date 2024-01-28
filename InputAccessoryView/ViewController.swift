//
//  ViewController.swift
//  InputAccessoryView
//
//  Created by Zülfü Akgüneş on 25.01.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    var fetchedResultsController: NSFetchedResultsController<Card>!
    
    lazy var homeTableView: UITableView = {
       let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // Button on the main screen
    lazy var addWordButton: UIButton = {
        var configuration = UIButton.Configuration.filled()

        configuration.title = "Add Word"
        configuration.baseBackgroundColor = UIColor.systemPink
        configuration.contentInsets = NSDirectionalEdgeInsets(
          top: 10,
          leading: 20,
          bottom: 10,
          trailing: 20
        )
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(addWordButtonTapped), for: .touchUpInside)
        return button
    }()
    
//     Stack View for holding textField and button
    lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.backgroundColor = .red
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
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.inputAccessoryView = accessoryViewToolbar
//        accessoryViewToolbar.addSubview(textField)
        return textField
    }()

    // Button on Accessory View
    lazy var accessoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        button.translatesAutoresizingMaskIntoConstraints = false
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
        initializeFetchedResultsController()
    }
    
    private func layoutUI() {   
        setupTableView()
        setupAddWordButton()
        setupInputStackView()
        setupDimmingView()
    }
    
    // Klavye olaylarını dinlemek için NotificationCenter ayarlamaları
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override var inputAccessoryView: UIView? {
        return accessoryViewToolbar
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
        guard let wordText = accessoryTextField.text, !wordText.isEmpty else {
            return
        }
        
        saveWord(word: wordText)
        accessoryTextField.text = ""
        
        self.accessoryTextField.resignFirstResponder()
        self.hiddenTextField.resignFirstResponder()
    }
    
    func saveWord(word: String) {
        // AppDelegate'ten CoreData stack'ına erişin.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newCard = Card(context: context)
        newCard.word = word

        do {
            try context.save()
            print("Saved successfully")
        }
        catch {
            print("Failed saving \(error)")
        }
    }
    
    @objc private func addWordButtonTapped() {
        // Make textField become the first responder
        print("Add button tapped")
            self.hiddenTextField.becomeFirstResponder()
            self.accessoryTextField.becomeFirstResponder()
    }
    
}

extension ViewController {
    func setupAddWordButton() {
//        NSLayoutConstraint.activate([
//            addWordButton.trailingAnchor.constraint(
//                equalTo: view.trailingAnchor, constant: -30),
//            addWordButton.bottomAnchor.constraint(
//                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
//            addWordButton.widthAnchor.constraint(equalToConstant: 100), // Buton genişliği
//            addWordButton.heightAnchor.constraint(equalToConstant: 50) // Buton yüksekliği
//        ])
        // Buton constraints
        NSLayoutConstraint.activate([
            addWordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addWordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addWordButton.widthAnchor.constraint(equalToConstant: 200),
            addWordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
        
    func setupInputStackView() {
        NSLayoutConstraint.activate([
            inputStackView.heightAnchor.constraint(equalToConstant: 50)
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
    
    func setupTableView() {
        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let card = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = card.word
        return cell
    }
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        let sort = NSSortDescriptor(key: "word", ascending: true)
        request.sortDescriptors = [sort]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
}

#Preview {
    ViewController()
}
