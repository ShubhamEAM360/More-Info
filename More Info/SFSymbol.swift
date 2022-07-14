//
//  SFSymbol.swift
//
//  Created by Shubham Jana on 05/07/22.
//

import UIKit

/// From iOS 13.0 system has `SF Symbols` to provide default images.
public enum SFSymbol: String {
  case textFormat = "textformat.size"
}

// MARK: - UIImage+Init

extension UIImage {
  convenience init?(SFSymbol: SFSymbol,
                    withConfiguration configuration: UIImage.SymbolConfiguration?) {
    self.init(systemName: SFSymbol.rawValue,
              withConfiguration: configuration)
  }
}
