//
//  github_action_swiftUITestsLaunchTests.swift
//  github_action_swiftUITests
//
//  Created by takuto ono on 2025/07/07.
//

import XCTest

final class github_action_swiftUITestsLaunchTests: XCTestCase {
    static override var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
