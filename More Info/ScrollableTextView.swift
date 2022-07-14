//
//  CustomTextView.swift
//
//  Created by Shubham Jana on 25/06/22.
//

import UIKit

class ScrollableTextView: UITextView {
  
  convenience init(text: String,
                   font: UIFont,
                   textColor: UIColor,
                   backgroundColor: UIColor = .systemBackground,
                   cornerRadius: CGFloat? = nil) {
    self.init(frame: .zero)
    self.text = text
    self.textColor = textColor
    self.font = font
    self.backgroundColor = backgroundColor
    self.layer.cornerRadius = cornerRadius ?? 0.0
  }
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    configure()
  }
  
  private func configure() {
    isEditable = false
    isScrollEnabled = false
    translatesAutoresizingMaskIntoConstraints = false
    textAlignment = .left
    autocorrectionType = .no
    autocapitalizationType = .words
    adjustsFontForContentSizeCategory = true
    font = UIFont.preferredFont(forTextStyle: .body)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension ScrollableTextView {
  func underlined(){
    let border = CALayer()
    let width = CGFloat(1.0)
    border.borderColor = UIColor.label.cgColor
    border.frame = CGRect(x: 0,
                          y: self.frame.size.height - width,
                          width:  self.frame.size.width,
                          height: self.frame.size.height)
    border.borderWidth = width
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
  }
}
