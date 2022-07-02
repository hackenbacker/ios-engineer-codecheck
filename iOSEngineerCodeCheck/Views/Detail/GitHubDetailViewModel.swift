//
//  GitHubDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

typealias GitHubDetailViewState = ViewState<Data?>

/// 詳細画面用のView Model.
@MainActor
final class GitHubDetailViewModel: ObservableObject {

    /// Viewの状態.
    @Published private(set) var state: GitHubDetailViewState = .idle

    private let dataRepository: AvatarRepository

    /// Initializer.
    /// - Parameter dataRepository: AvatarRepositoryに準拠したオブジェクトの注入用.
    init(dataRepository: AvatarRepository = AvatarImageRepository()) {
       self.dataRepository = dataRepository
    }

    /// 画面が表示されたときの処理.
    /// - Parameter item: GitHub item.
    func onAppear(_ item: GitHubItem?) async {
        await getAvatarImage(with: item)
    }
    
    /// アバター画像の取得
    /// - Parameter item: GitHub item.
    private func getAvatarImage(with item: GitHubItem?) async {
        state = .loading

        do {
            let image = try await dataRepository.getAvatarImage(with: item)
            state = .loaded(image)
        } catch {
            state = .failed(error)
        }
    }
}
