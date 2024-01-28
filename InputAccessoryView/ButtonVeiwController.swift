//
//  ButtonVeiwController.swift
//  InputAccessoryView
//
//  Created by Zülfü Akgüneş on 28.01.2024.
//

import UIKit

class ButtonVeiwController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UIStackView oluştur
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // UITextField oluştur ve stackView'e ekle
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        stackView.addArrangedSubview(textField)

        // UIButton oluştur, genişliğini ayarla ve stackView'e ekle
        let button = UIButton(type: .system)
        button.setTitle("Press Me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(button)

        // UIStackView constraints ayarla
//        NSLayoutConstraint.activate([
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.heightAnchor.constraint(equalToConstant: 100),
//            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//        ])
    }
}

#Preview {
    ButtonVeiwController()
}
