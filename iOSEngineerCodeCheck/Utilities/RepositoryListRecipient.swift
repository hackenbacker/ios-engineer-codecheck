//
//  RepositoryListRecipient.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/06/30.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// リポジトリ一覧を使用するObjectの定義.
protocol RepositoryListRecipient: AnyObject {
    /// リポジトリ一覧を提供するObject.
    var repositoryListProvider: RepositoryListProvider? { get set }
}
