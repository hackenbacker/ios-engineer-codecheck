//
//  PageObject.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by Toshio Nakao on 2022/07/04.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest

/// For Page Object Pattern.
protocol PageObject {
    /// This Application
    var app:   XCUIApplication { get }
    /// Title of this page.
    var pageTitle: XCUIElement { get }
    /// Tells whether this page exists.
    var exists: Bool { get }
}

extension PageObject {
    var exists: Bool {
        pageTitle.exists
    }
}
