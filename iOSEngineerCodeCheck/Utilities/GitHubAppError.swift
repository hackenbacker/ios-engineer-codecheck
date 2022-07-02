//
//  GitHubAppError.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/06/29.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// このアプリのエラーを表現します.
enum GitHubAppError: LocalizedError {
    case communicationError // 通信エラー
    case invalidInput       // 無効な入力
    case noRepositories     // リポジトリが見つからない

    var errorDescription: String? {
        switch self {
        case .communicationError:
            return "通信中にエラーが発生しました。"
        case .invalidInput:
            return "無効な文字列が入力されました。"
        case .noRepositories:
            return "リポジトリが見つかりませんでした。"
        }
    }
}

