//
//  MoreInfoVC.swift
//
//  Created by Shubham Jana on 09/07/22.
//

import UIKit

typealias TableViewDelegateAndDataSource = UITableViewDataSource & UITableViewDelegate

final class MoreInfoVC: UIViewController {
  var data: [String] = [
    "DESCRIPTION :",
    "LONG DESCRIPTION :",
    "COMMODITY CODE :",
    "ISSUE UNIT :",
    "ORDER UNIT :"
  ]
  deinit {
    debugPrint("MoreInfoVC is deinit")
  }
  
  
  // MARK: - PROPERTIES
  
  private var section = Int()
  
  private lazy var navBar: UINavigationBar = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.barTintColor = .systemGroupedBackground
    
    let navItem = UINavigationItem()
    navItem.title = "Item #1000"
    if #available(iOS 14.0, *) {
      navItem.leftBarButtonItem = UIBarButtonItem(systemItem: UIBarButtonItem.SystemItem.close,
                                                  primaryAction: UIAction(handler: { [weak self] _ in
        guard let self = self else { return }
        self.dismiss(animated: true)
      }),
                                                  menu: nil)
    } else {
      // Fallback on earlier versions
      navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close,
                                                  target: self,
                                                  action: nil)
    }
    navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save,
                                                 target: self,
                                                 action: nil)
    
    $0.items = [navItem]
    return $0
  }(UINavigationBar())
  
  private lazy var tableView: UITableView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.register(MoreInfoCell.self,
                       forCellReuseIdentifier: MoreInfoCell.identifier)
    $0.delegate = self
    $0.dataSource = self
    return $0
  }(UITableView(frame: .zero, style: .insetGrouped))
  
  // MARK: - LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGroupedBackground
    setupUI()
    notificationCentre()
  }
  
  // MARK: - SELECTOR
  
  private func notificationCentre() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didTapZoomOut(_:)),
                                           name: Notification.Name("zoomOut"),
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didTapZoomIn(_:)),
                                           name: Notification.Name("zoomIn"),
                                           object: nil)
  }
  
  // MARK: SETUP UI
  
  private func setupUI() {
    view.addSubview(navBar)
    view.addSubview(tableView)
    setupConstraints()
  }
  
  // MARK: CONSTRAINTS
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      navBar.topAnchor.constraint(equalTo: view.topAnchor),
      navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  // MARK: HANDLERS
//  private let userDefaults = UserDefaults()
  @objc
  private func didTapZoomOut(_ sender: NSNotification) {
    guard let cell = tableView.cellForRow(at: IndexPath(row: 0,
                                                        section: section)) as? MoreInfoCell else { return }
    if let fontSize = sender.object as? CGFloat {
      cell.contentTextView.font = .systemFont(ofSize: fontSize)
//      userDefaults.setValue(fontSize, forKey: "zoom")
    }
    cell.updateTextViewConstraints()
  }
  
  @objc
  private func didTapZoomIn(_ sender: NSNotification) {
    guard let cell = tableView.cellForRow(at: IndexPath(row: 0,
                                                        section: section)) as? MoreInfoCell else { return }
    if let fontSize = sender.object as? CGFloat {
      cell.contentTextView.font = .systemFont(ofSize: fontSize)
    }
    cell.updateTextViewConstraints()
  }
  
}


extension MoreInfoVC: TableViewDelegateAndDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MoreInfoCell.identifier,
                                             for: indexPath) as! MoreInfoCell
    cell.selectionStyle = .none
    cell.cellDelegate = self
    cell.indexPath = indexPath
    cell.textChanged { [weak self] _ in
      guard let self = self else { return }
      UIView.performWithoutAnimation {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
      }
    }
    if indexPath.section > 1 {
      cell.dividerView.isHidden = true
      cell.horizontalStack.isHidden = true
      cell.contentTextView.textColor = .secondaryLabel
      cell.fillContextView()
    } else {
      cell.depriveContextView()
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.tableView(tableView, heightForRowAt: indexPath)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return data[section]
  }
  
}

extension MoreInfoVC: MoreInfoCellDelegate {
  func buttonAction(WithIndexPath indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      section = indexPath.section
    case 1:
      section = indexPath.section
    default:
      print("Nothing to do")
    }
  }
  func didTapButton(_ sender: UIButton) {
    let popoverVC = PopoverVC()
    popoverVC.modalPresentationStyle = .popover
    popoverVC.popoverPresentationController?.sourceView = sender
    popoverVC.popoverPresentationController?.permittedArrowDirections = .down
    popoverVC.popoverPresentationController?.delegate = self
    let _ = present(popoverVC, animated: true, completion: nil)
  }
}

// MARK: - POPOVER DELEGATE

extension MoreInfoVC: UIPopoverPresentationControllerDelegate {
  public func adaptivePresentationStyle(for controller: UIPresentationController,
                                        traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return .none
  }
}

