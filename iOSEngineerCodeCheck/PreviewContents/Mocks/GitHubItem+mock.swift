//
//  GitHubItem+mock.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/03.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

extension GitHubItem {
    static let mock =
        GitHubItem(id: 9999,
                   fullName: "Name/Language",
                   language: "Language",
                   owner:    .mock,
                   stargazersCount: 9999,
                   forksCount:      9999,
                   openIssuesCount: 9999,
                   url: "")
}
