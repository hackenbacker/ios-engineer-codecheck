//
//  GitHubDetailPage.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by Toshio Nakao on 2022/07/04.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest

/// 詳細画面用のPageObject.
final class GitHubDetailPage: PageObject {
    let app: XCUIApplication = XCUIApplication()

    var pageTitle: XCUIElement {
        app.navigationBars["詳細"].firstMatch
    }
}
