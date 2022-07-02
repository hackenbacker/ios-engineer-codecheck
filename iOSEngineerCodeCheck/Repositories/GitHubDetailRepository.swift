//
//  GitHubDetailRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// アバター関連のRepository.
protocol GitHubAvatarRepository {
    /// アバター画像を取得する.
    /// - Parameter with: GitHub item.
    /// - Returns: アバター画像データ.
    func getAvatarImage(with: GitHubItem?) async throws -> Data
}

/// Watchers関連のRepository.
protocol GitHunWatchersRepository {
    /// Watch数を取得する.
    /// - Parameter item: GitHub item.
    /// - Returns: Watch数.
    func getWatchersCount(with item: GitHubItem?) async throws -> Int
}

/// 詳細画面用Repository.
protocol GitHubDetailRepository: GitHubAvatarRepository, GitHunWatchersRepository {}

/// GitHubDetailRepositoryの実装.
struct GitHubDetailDataRepository: GitHubDetailRepository {
    func getAvatarImage(with item: GitHubItem?) async throws -> Data {
        try await GitHubAPIClient().getAvatarImage(with: item)
    }

    func getWatchersCount(with item: GitHubItem?) async throws -> Int {
        try await GitHubAPIClient().getWatchersCount(with: item)
    }
}
