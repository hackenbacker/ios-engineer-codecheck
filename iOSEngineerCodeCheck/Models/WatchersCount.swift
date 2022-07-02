//
//  WatchersCount.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/02.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// Get a repositoryのレスポンス.
/// See: https://docs.github.com/ja/rest/repos/repos#get-a-repository
struct GetARepositoryResponse: Codable {
    var subscribersCount: Int
}
