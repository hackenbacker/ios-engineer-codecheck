//
//  RepositoryListProvider.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/06/30.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// リポジトリ一覧を提供するObjectの定義.
protocol GitHubItemsProvider: AnyObject {
    /// リポジトリ一覧.
    //var repositoryList: [[String: Any]] { get }
    var gitHubItems: [GitHubItem] { get }
    /// 選択中のリポジトリ.
    //var selectedRepository: [String: Any]? { get }
    var selectedGitHubItem: GitHubItem? { get }
}
