//
//  FranvaroAppenUITests.swift
//  FranvaroAppenUITests
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import XCTest

class FranvaroAppenUITests: XCTestCase {
    
    let app = XCUIApplication()

    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        XCUIDevice.shared().orientation = .portrait
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenshots() {
        
        // Create child
        let tablesQuery = app.tables
        tablesQuery.textFields["Namn"].tap()
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Namn").children(matching: .textField).element
        textField.typeText("Lind")
        tablesQuery.textFields["ÅÅMMDD-NNNN"].tap()
        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"Person nummer").children(matching: .textField).element
        textField2.typeText("131223-3432")
        
        // Add avatar
//        tablesQuery.children(matching: .button).element.tap()
//        app.alerts["”Frånvaro” begär åtkomst till dina bilder"].buttons["OK"].tap()
//        tablesQuery.buttons["Ögonblick"].tap()
//        app.collectionViews["PhotosGridView"].children(matching: .cell).matching(identifier: "Bild, Liggande, 13 november 17:12").element(boundBy: 2).tap()
        
        // Save child
        app.navigationBars["Lind"].buttons["Save"].tap()
        tablesQuery.staticTexts["Lind"].tap()

        snapshot("MainMenu")
    }
    
}
