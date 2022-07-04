//
//  GitHubItem+mock.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/03.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

extension GitHubItem {
    /// Mock No.1
    static let mock1 =
        GitHubItem(id: 1111,
                   fullName: "Name1/Language1",
                   language: "Language1",
                   owner:    .mock,
                   stargazersCount: 1111,
                   forksCount:      1111,
                   openIssuesCount: 1111,
                   url: "")
    /// Mock No.2
    static let mock2 =
        GitHubItem(id: 2222,
                   fullName: "Name2/Language2",
                   language: "Language2",
                   owner:    .mock,
                   stargazersCount: 2222,
                   forksCount:      2222,
                   openIssuesCount: 2222,
                   url: "")
    /// Mock No.3
    static let mock3 =
        GitHubItem(id: 3333,
                   fullName: "Name3/Language3",
                   language: "Language3",
                   owner:    .mock,
                   stargazersCount: 3333,
                   forksCount:      3333,
                   openIssuesCount: 3333,
                   url: "")
}
