//
//  GitHubDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

typealias GitHubDetailViewState = ViewState<(Data, Int)>

/// 詳細画面用のView Model.
@MainActor
final class GitHubDetailViewModel: ObservableObject {

    /// Viewの状態.
    @Published private(set) var state: GitHubDetailViewState = .idle

    private let dataRepository: GitHubDetailRepository

    /// Initializer.
    /// - Parameter dataRepository: GitHubDetailRepositoryに準拠したオブジェクトの注入用.
    init(dataRepository: GitHubDetailRepository = GitHubDetailDataRepository()) {
       self.dataRepository = dataRepository
    }

    /// 画面が表示されたときの処理.
    /// - Parameter item: GitHub item.
    func onAppear(_ item: GitHubItem?) async {
        await getDisplayData(with: item)
    }
    
    /// 詳細画面で使用するデータを取得する.
    /// - Parameter item: GitHub item.
    private func getDisplayData(with item: GitHubItem?) async {
        state = .loading

        do {
            async let avatarimage   = dataRepository.getAvatarImage  (with: item)
            async let watchersCount = dataRepository.getWatchersCount(with: item)
            state = .loaded(try await (avatarimage, watchersCount))
        } catch {
            state = .failed(error)
        }
    }
}
