//
//  GitHubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// Abstraction of GitHub Repository.
protocol GitHubRepository {
    /// Searches GitHub repositories with a query string.
    /// - Parameter query: Query string for search.
    /// - Returns: GitHub items.
    func searchGitHub(with query: String) async throws -> [GitHubItem]
}

/// GitHubRepositoryの実装.
struct SearchGitHubRepository: GitHubRepository {
    func searchGitHub(with query: String) async throws -> [GitHubItem] {
        try await GitHubAPIClient().searchRepositories(with: query)
    }
}
