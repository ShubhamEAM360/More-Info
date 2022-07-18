//
//  MoreInfoCell.swift
//
//  Created by Shubham Jana on 09/07/22.
//

import UIKit

protocol MoreInfoCellDelegate: AnyObject {
  func buttonAction(_ sender: UIButton, WithIndexPath indexPath: IndexPath)
}

final class MoreInfoCell: UITableViewCell {
  
  // MARK: - PROPERTIES
  
  public static let identifier = "MoreInfoEditableCell"
  public var textChanged: ((String) -> Void)?
  public var indexPath: IndexPath?
  public var currentZoomLevel: CGFloat = 16
  public weak var cellDelegate: MoreInfoCellDelegate?
  private var fillContextViewBottomAnchor: NSLayoutConstraint!
  private var depriveContextViewBottomAnchor: NSLayoutConstraint!
  
  public lazy var contentTextView = ScrollableTextView(text: """
"Design is not just what it looks like and feels like. Design is how it works”
 - Steve Jobs
""",
                                                       font: .systemFont(ofSize: 16),
                                                       textColor: .label)
//  let pub = NotificationCenter.default.publisher(for:  NSControl.textDidChangeNotification, object: contentTextView)
  
  public let dividerView: UIView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .tertiaryLabel
    return $0
  }(UIView())
  
  public lazy var zoomButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(SFSymbol: .textFormat,
                            withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 16))),
                    for: .normal)
    button.addTarget(self, action: #selector(didTapZoomButton(_:)),
                     for: .touchUpInside)
    return button
  }()
  
  public lazy var editButton: UIButton = {
    $0.setTitle("Edit", for: .normal)
    $0.setTitle("Done", for: .selected)
    $0.setTitleColor(UIColor.systemBlue, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 20,
                                      weight: .light)
    $0.addTarget(self, action: #selector(didTapEditButton(_:)),
                 for: .touchUpInside)
    return $0
  }(UIButton())
  
  public lazy var horizontalStack: UIStackView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addArrangedSubview(zoomButton)
    $0.addArrangedSubview(editButton)
    $0.distribution = .equalSpacing
    return $0
  }(UIStackView())
  
  // MARK: - LIFECYCLE
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    
    [
      contentTextView
    ].forEach { textView in
      textView.delegate = self
      textView.backgroundColor = .secondarySystemGroupedBackground
    }
  }
  
  // MARK: - SELECTOR
  
  public func textChanged(action: @escaping (String) -> Void) {
    self.textChanged = action
  }
  
  public func updateTextViewConstraints() {
    textViewDidChange(contentTextView)
  }
  
  // MARK: SETUP UI
  
  private func setupUI() {
    contentView.addSubview(contentTextView)
    contentView.addSubview(dividerView)
    contentView.addSubview(horizontalStack)
    setupConstraints()
  }
  
  // MARK: CONSTRAINTS
  
  private func setupConstraints() {
    fillContextViewBottomAnchor =  contentTextView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
    depriveContextViewBottomAnchor = contentTextView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,
                                                                             constant: -35)
    
    NSLayoutConstraint.activate([
      contentTextView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
      contentTextView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
      contentTextView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
      
      dividerView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor),
      dividerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                                           constant: 5),
      dividerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                                            constant: -5),
      dividerView.heightAnchor.constraint(equalToConstant: 1),
      
      horizontalStack.topAnchor.constraint(equalTo: dividerView.bottomAnchor,
                                           constant: 2),
      horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -20),
      horizontalStack.widthAnchor.constraint(equalToConstant: 85)
    ])
  }
  
  public func fillContextView() {
    fillContextViewBottomAnchor.isActive = true
    depriveContextViewBottomAnchor.isActive = false
  }
  
  public func depriveContextView() {
    fillContextViewBottomAnchor.isActive = false
    depriveContextViewBottomAnchor.isActive = true
  }
  
  // MARK: HANDLERS
  
  @objc
  private func didTapZoomButton(_ sender: UIButton) {
    guard let indexPath = indexPath else { return }
    cellDelegate?.buttonAction(sender, WithIndexPath: indexPath)
  }
  
  @objc
  private func didTapEditButton(_ sender: UIButton) {
    sender.isSelected.toggle()
    if sender.isSelected {
      contentTextView.isEditable = true
    } else if !sender.isSelected {
      contentTextView.isEditable = false
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}



extension MoreInfoCell: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    textChanged?(textView.text)
  }
}
