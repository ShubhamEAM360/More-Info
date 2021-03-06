//
//  PopoverVC.swift
//
//  Created by Shubham Jana on 04/07/22.
//

import UIKit

class PopoverVC: UIViewController {
  
  deinit {
    debugPrint("PopoverVC is deinit")
  }
  
  // MARK: - PROPERTIES
  
  public var zoom: ((CGFloat) -> Void)?
  
  /// Value that set as current value for Zoom level
  /// Default value is 16
  public var currentValue: CGFloat = 16
  
  /// Value that used as minimum for the Zoom level
  /// Default value is 9
  public var minimumValue: CGFloat = 9
  
  /// Value that used as maximum for the Zoom level
  /// Default value is 23
  public var maximumValue: CGFloat = 23
  
  /// Stepper that used to increase or decrease the Zoom level with the specified value
  /// Default value is 1
  private var stepValue: CGFloat = 1
  
  
  public lazy var zoomOutButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("A", for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.setTitleColor(UIColor.systemGray, for: .disabled)
    button.titleLabel?.font = .systemFont(ofSize: 18)
    button.addTarget(self, action: #selector(didTapZoomOut(_:)),
                     for: .touchUpInside)
    return button
  }()
  
  public lazy var zoomInButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("A", for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.setTitleColor(UIColor.systemGray, for: .disabled)
    button.titleLabel?.font = .systemFont(ofSize: 23)
    button.addTarget(self, action: #selector(didTapZoomIn(_:)),
                     for: .touchUpInside)
    return button
  }()
  
  private lazy var centreLine: UIView = {
    $0.widthAnchor.constraint(equalToConstant: 1).isActive = true
    $0.backgroundColor = .tertiaryLabel
    return $0
  }(UIView())
  
  private lazy var container: UIStackView = {
    $0.addArrangedSubview(zoomOutButton)
    $0.addArrangedSubview(centreLine)
    $0.addArrangedSubview(zoomInButton)
    $0.distribution = .equalCentering
    $0.axis = .horizontal
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UIStackView())
  
  // MARK: - LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    preferredContentSize = CGSize(width: 120, height: 40)
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if currentValue >= maximumValue || Fonts.currentZoomLevel >= maximumValue {
      zoomInButton.isEnabled = false
      return
    }
    if currentValue <= minimumValue || Fonts.currentZoomLevel <= minimumValue {
      zoomOutButton.isEnabled = false
      return
    }
  }

  // MARK: - SELECTOR
  
  // MARK: SETUP UI
  
  private func setupUI() {
    view.addSubview(container)
    setupConstraints()
  }
  
  // MARK: CONSTRAINTS
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      container.heightAnchor.constraint(equalToConstant: 28),
      container.widthAnchor.constraint(equalToConstant: 80),
      container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      container.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                         constant: -5)
    ])
  }
  
  // MARK: HANDLERS
  
  @objc
  private func didTapZoomIn(_ sender: UIButton) {
    currentValue += stepValue
    zoom?(currentValue)
    if currentValue >= maximumValue {
      zoomInButton.isEnabled = false
      return
    }
    zoomInButton.isEnabled = true
    zoomOutButton.isEnabled = true
  }
  
  @objc
  private func didTapZoomOut(_ sender: UIButton) {
    currentValue -= stepValue
    zoom?(currentValue)
    if currentValue <= minimumValue {
      zoomOutButton.isEnabled = false
      return
    }
    zoomInButton.isEnabled = true
    zoomOutButton.isEnabled = true
  }
    
  // MARK: ACCESSIBILITY LABEL
  
  private func addAccessibilityLabels() {
    zoomInButton.accessibilityIdentifier = "zoom in button"
    zoomOutButton.accessibilityIdentifier = "zoom out button"
  }
  
}

