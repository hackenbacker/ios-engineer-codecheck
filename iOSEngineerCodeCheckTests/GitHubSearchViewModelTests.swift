//
//  GitHubSearchViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Toshio Nakao on 2022/07/04.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

/// 検索画面用ViewModelのテスト.
@MainActor
final class GitHubSearchViewModelTests: XCTestCase {

    /// stateの初期状態のテスト.
    func testInitialStateIsIdle() async {

        let viewModel = GitHubSearchViewModel(
            dataRepository: MockGitHubSearchDataRepository(items: [])
        )

        switch viewModel.state {
        case .idle:
            break
        default:
            XCTFail("statusが(.idle)ではありません。")
        }
    }

    /// onSearchButtonTapped()の呼び出しでstateがloadedになる場合のテスト.
    func testOnSearchButtonTappedResultWithLoaded() async {

        let inputItems: [GitHubItem] = [.mock1, .mock2, .mock3]

        let viewModel = GitHubSearchViewModel(
            dataRepository: MockGitHubSearchDataRepository(
                items: inputItems
            )
        )

        await viewModel.onSearchButtonTapped("Swift")

        switch viewModel.state {
        case .loaded(let items):
            XCTAssertEqual(items, inputItems, "itemsが入力値と異なります。")
        default:
            XCTFail("statusが(.loaded)ではありません。")
        }
    }

    /// onSearchButtonTapped()の呼び出しでstateがfailedになる場合のテスト.
    func testOnSearchButtonTappedResultWithFailed() async {

        let viewModel = GitHubSearchViewModel(
            dataRepository: MockGitHubSearchDataRepositoryFailed(
                with: MockError()
            )
        )

        await viewModel.onSearchButtonTapped("Swift")

        switch viewModel.state {
        case .failed(let error):
            XCTAssert(error is MockError, "errorが入力値と異なります。")
        default:
            XCTFail("statusが(.failed)ではありません。")
        }
    }
}
