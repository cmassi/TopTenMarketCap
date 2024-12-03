//
//  StringExtensions.swift
//  TopTenMarketCap
//
//  Created by Swift on 29/11/24.
//

import Foundation
import UIKit

extension String {

    @available(*, unavailable, message: "This is not in use")
    @MainActor func canOpenUrl() -> Bool {
        guard let url = URL(string: self), UIApplication.shared.canOpenURL(url) else { return false }
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
    
    public func isImage() -> Bool {
        let imageFormats = ["jpg", "jpeg", "png", "gif"]
        guard let ext = self.getExtension(), imageFormats.contains(ext) else {
            return false
        }
        return true
    }
    
    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        guard !ext.isEmpty else { return nil }
        return ext
    }
    
    public func isURL() -> Bool {
        return URL(string: self) != nil
    }
}
