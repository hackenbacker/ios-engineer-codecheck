//
//  GitHubItemsRecipient.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/06/30.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// リポジトリ情報を使用するObjectの定義.
protocol GitHubItemRecipient: AnyObject {
    /// GitHub item (リポジトリ一情報 ).
    var gitHubItem: GitHubItem? { get set }
}
