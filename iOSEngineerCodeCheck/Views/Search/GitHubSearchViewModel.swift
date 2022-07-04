//
//  GitHubSearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

typealias GitHubSearchViewState = ViewState<[GitHubItem]>

/// 検索画面用のView Model.
@MainActor
final class GitHubSearchViewModel: ObservableObject {

    /// Viewの状態.
    @Published private(set) var state: GitHubSearchViewState = .idle

    private let dataRepository: GitHubRepository

    /// Initializer.
    /// - Parameter dataRepository: GitHubRepositoryに準拠したオブジェクトの注入用.
    init(dataRepository: GitHubRepository = SearchGitHubRepository()) {
       self.dataRepository = dataRepository
    }

    /// 検索ボタンが押されたときの処理.
    func onSearchButtonTapped(_ query: String) async {
        await searchGitHub(with: query)
    }

    /// GitHubリポジトリの検索を行う.
    private func searchGitHub(with query: String) async {
        state = .loading

        do {
            let value = try await dataRepository.searchGitHub(with: query)
            state = .loaded(value)
        } catch {
            state = .failed(error)
        }
    }
}
