//
//  GitHubAPIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// Calls GitHub APIs.
struct GitHubAPIClient {

    /// Search Repositoriesの実行.
    /// - Parameter with: A query string.
    /// - Returns: Search result.
    func searchRepositories(with query: String) async throws -> [GitHubItem] {

        let urlString = "https://api.github.com/search/repositories?q=\(query)&per_page=50"
        guard let url = URL(string: urlString) else {
            throw GitHubAppError.invalidInput
        }

        let searched = try await make(SearchRepositoriesResponse.self, from: url)
        return searched.items
    }

    /// Watch数の取得.
    /// - Parameter with: GitHub item.
    /// - Returns: Watch数.
    func getWatchersCount(with item: GitHubItem?) async throws -> Int {

        guard let urlString = item?.url,
              let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let repo = try await make(GetARepositoryResponse.self, from: url)
        return repo.subscribersCount
    }

    ///  Returns a value of the specified type from the URL.
    /// - Parameters:
    ///   - type: The type of the value to get.
    ///   - url:        The URL.
    /// - Returns: A value of the specified type.
    private func make<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/vnd.github.v3+json"
        ]

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let decoded = try decoder.decode(type.self, from: data)
            return decoded
        } catch let error {
            print(error)
            print(error.localizedDescription)
            throw GitHubAppError.communicationError
        }
    }

    /// アバター画像の取得.
    /// - Parameter item: GitHub item.
    /// - Returns: Response data.
    func getAvatarImage(with item: GitHubItem?) async throws -> Data {

        guard let urlString = item?.owner?.avatarUrl,
              let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return data
    }
}
