//
//  MockGitHubSearchDataRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/04.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// GitHubSearchDataRepositoryの正常系Mock.
struct MockGitHubSearchDataRepository: GitHubRepository {
    let items: [GitHubItem]
    
    /// Initializer.
    /// - Parameters:
    ///   - avatarData:    Data of Avatar image.
    ///   - watchersCount: Number of Watcheers.
    init(items: [GitHubItem]) {
        self.items = items
    }

    func searchGitHub(with query: String) async throws -> [GitHubItem] {
        return items
    }
}

/// GitHubSearchDataRepositoryの異常系Mock.
struct MockGitHubSearchDataRepositoryFailed: GitHubRepository {
    let error: Error
    
    /// Initializer.
    /// - Parameters:
    ///   - with: Error object.
    init(with error: Error) {
        self.error = error
    }

    func searchGitHub(with query: String) async throws -> [GitHubItem] {
        throw error
    }
}
