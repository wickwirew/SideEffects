//
//  SideEffectsTests.swift
//  SideEffectsTests
//
//  Created by Wes Wickwire on 12/30/18.
//  Copyright © 2018 WesWickwire. All rights reserved.
//

import XCTest
import ReSwift
@testable import SideEffects

class SideEffectsTests: XCTestCase {

    func testSideEffect() {
        var wasCalled = false

        let store = testStore(effects: [
            SideEffect(of: TestAction.self) { _, _, _ in
                wasCalled = true
            }
        ])

        store.dispatch(Test2Action())
        XCTAssert(!wasCalled)
        store.dispatch(TestAction())
        XCTAssert(wasCalled)
    }
    
    func testMuiltpleSideEffects() {
        var wasCalled = false
        
        let store = testStore(effects: [
            SideEffect(ofAny: TestAction.self, Test2Action.self) { _, _, _ in
                wasCalled = true
            }
        ])
        
        store.dispatch(Test3Action())
        XCTAssert(!wasCalled)
        store.dispatch(TestAction())
        XCTAssert(wasCalled)
        
        wasCalled = false
        
        store.dispatch(Test2Action())
        XCTAssert(wasCalled)
    }
}

typealias SideEffect = Store<State>.SideEffect

struct TestAction: Action {

}

struct Test2Action: Action {

}

struct Test3Action: Action {
    
}

struct State: StateType {

}

func testStore(effects: [SideEffect]) -> Store<State> {
    return Store<State>(
        reducer: { _, _ in State() },
        state: nil,
        middleware: [createSideEffectMiddleware(effects: effects)]
    )
}
