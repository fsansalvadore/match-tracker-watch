//
//  match_tracker_watch_standalone_Watch_AppUITestsLaunchTests.swift
//  match-tracker-watch-standalone Watch AppUITests
//
//  Created by Francesco Sansalvadore on 15/12/24.
//

import XCTest

final class match_tracker_watch_standalone_Watch_AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
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
