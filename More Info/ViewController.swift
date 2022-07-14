//
//  ViewController.swift
//  More Info
//
//  Created by Pizza Slice on 13/07/22.
//

import UIKit

class ViewController: UIViewController {
  
  lazy private var button: UIButton = {
    let button = UIButton(type: .system)
    if #available(iOS 15.0, *) {
      button.configuration = UIButton.Configuration.borderedTinted()
    } else {
      // Fallback on earlier versions
    }
    button.setTitle("More Info", for: .normal)
    button.addTarget(self,
                     action: #selector(didTapped(_:)),
                     for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = .systemBackground
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                     constant: -30),
      button.heightAnchor.constraint(equalToConstant: 50),
      button.widthAnchor.constraint(equalToConstant: 220),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  @objc
  private func didTapped(_ sender: UIButton) {
    present(MoreInfoVC(), animated: true)
  }
  
}





