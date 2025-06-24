//
//  TitleService.swift
//  SwiftBlogs
//
//  Created by Alex Seifert on 24.06.25.
//

struct TitleService {
    static let defaultTitle = "Swift Blogs"
    
    static func getTitle() -> String {
        return TitleService.defaultTitle
    }
    
    static func getTitle(title: String?) -> String {
        return (title != nil) ? title! + " | " + TitleService.defaultTitle : TitleService.defaultTitle
    }
}
