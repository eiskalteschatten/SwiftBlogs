//
//  TitleService.swift
//  SwiftBlogs
//
//  Created by Alex Seifert on 24.06.25.
//

enum TitleService {
    private static let siteTitle = "Swift Blogs"
    private static let separator = " | "
    
    static func getTitle(_ pageTitle: String? = nil) -> String {
        guard let pageTitle = pageTitle, !pageTitle.isEmpty else {
            return siteTitle
        }
        return "\(pageTitle)\(separator)\(siteTitle)"
    }
}
