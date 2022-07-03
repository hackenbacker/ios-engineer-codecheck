//
//  MockGitHubDetailRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/03.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// GitHubDetailDataRepositoryの正常系Mock.
struct MockGitHubDetailDataRepository: GitHubDetailRepository {
    let avatarData: Data?
    let watchersCount: Int?

    /// Initializer.
    /// - Parameters:
    ///   - avatarData:    Data of Avatar image.
    ///   - watchersCount: Number of Watcheers.
    init(avatarData: Data? = nil, watchersCount: Int? = nil) {
        self.avatarData    = avatarData
        self.watchersCount = watchersCount
    }

    func getAvatarImage(with item: GitHubItem?) async throws -> Data {
        return avatarData!
    }

    func getWatchersCount(with item: GitHubItem?) async throws -> Int {
        return watchersCount!
    }
}

/// GitHubDetailDataRepositoryの異常系Mock.
struct MockGitHubDetailDataRepositoryFailed: GitHubDetailRepository {
    let error: Error
    
    /// Initializer.
    /// - Parameters:
    ///   - with: Error object.
    init(with error: Error) {
        self.error = error
    }

    func getAvatarImage(with item: GitHubItem?) async throws -> Data {
        throw error
    }

    func getWatchersCount(with item: GitHubItem?) async throws -> Int {
        throw error
    }
}
