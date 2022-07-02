//
//  GitHubItem.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// Search Repositoriesのレスポンス.
/// See: https://docs.github.com/ja/rest/search#search-repositories
struct SearchRepositoriesResponse: Codable {
    var items: [GitHubItem]
}

/// Representation of an element of "items".
struct GitHubItem: Codable, Identifiable {
    var id:              Int
    var fullName:        String
    var language:        String?
    var owner:           Owner?
    var stargazersCount: Int
    var watchersCount:   Int
    var forksCount:      Int
    var openIssuesCount: Int
}

extension GitHubItem: Equatable {
    static func == (lhs: GitHubItem, rhs: GitHubItem) -> Bool {
        lhs.id == rhs.id
    }
}
