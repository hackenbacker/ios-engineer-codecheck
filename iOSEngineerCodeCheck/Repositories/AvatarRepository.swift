//
//  AvatarRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// Abstraction of Avartar Repository
protocol AvatarRepository {
    /// アバター画像を取得する.
    /// - Parameter with: GitHub item.
    /// - Returns: アバター画像データ.
    func getAvatarImage(with: GitHubItem?) async throws -> Data
}

/// AvatarRepositoryの実装.
struct AvatarImageRepository: AvatarRepository {
    func getAvatarImage(with item: GitHubItem?) async throws -> Data {
        try await GitHubAPIClient().getAvatarImage(with: item)
    }
}
