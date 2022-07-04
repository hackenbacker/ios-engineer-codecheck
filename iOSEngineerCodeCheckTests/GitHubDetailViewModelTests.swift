//
//  GitHubDetailViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Toshio Nakao on 2022/07/03.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

/// 詳細画面用ViewModelのテスト.
@MainActor
final class GitHubDetailViewModelTests: XCTestCase {

    /// stateの初期状態のテスト.
    func testInitialStateIsIdle() async {

        let viewModel = GitHubDetailViewModel(
            dataRepository: MockGitHubDetailDataRepository()
        )

        switch viewModel.state {
        case .idle:
            break
        default:
            XCTFail("statusが(.idle)ではありません。")
        }
    }

    /// onAppear()の呼び出しでstateがloadedになる場合のテスト.
    func testOnAppearResultWithLoaded() async {

        let avatarData    = UIImage(systemName: "person.crop.square")!.pngData()!
        let watchersCount = GetARepositoryResponse.mock.subscribersCount

        let viewModel = GitHubDetailViewModel(
            dataRepository: MockGitHubDetailDataRepository(
                avatarData:    avatarData,
                watchersCount: watchersCount
            )
        )

        await viewModel.onAppear(GitHubItem.mock1)

        switch viewModel.state {
        case .loaded(let (data, count)):
            XCTAssertEqual(data,  avatarData,    "avatar画像が入力値と異なります。")
            XCTAssertEqual(count, watchersCount, "watchersCountが入力値と異なります。")
        default:
            XCTFail("statusが(.loaded)ではありません。")
        }
    }

    /// onAppear()の呼び出しでstateがfailedになる場合のテスト.
    func testOnAppearResultWithFailed() async {

        let viewModel = GitHubDetailViewModel(
            dataRepository: MockGitHubDetailDataRepositoryFailed(
                with: MockError()
            )
        )

        await viewModel.onAppear(GitHubItem.mock1)

        switch viewModel.state {
        case .failed(let error):
            XCTAssert(error is MockError, "errorが入力値と異なります。")
        default:
            XCTFail("statusが(.failed)ではありません。")
        }
    }
}
