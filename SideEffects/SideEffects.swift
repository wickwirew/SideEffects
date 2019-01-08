//
//  SideEffects.swift
//  FlipIt
//
//  Created by Wes Wickwire on 11/27/18.
//

import ReSwift

/// Hide the `SideEffect` type under the `Store`.
/// Each app should make a type alias for this for ease of use.
extension Store {
    
    public struct SideEffect {

        let invoke: (Action, State, @escaping DispatchFunction) -> Void

        public init<A: Action>(of actionType: A.Type,
                               handler: @escaping (A, State, @escaping DispatchFunction) -> Void) {
            self.invoke = { action, state, dispatch in
                guard let action = action as? A else { return }
                handler(action, state, dispatch)
            }
        }
    }
}

public func createSideEffectMiddleware<State: StateType>(effects: [Store<State>.SideEffect]) -> Middleware<State> {
    return { dispatch, getState in
        return { next in
            return { action in
                
                guard let state = getState() else {
                    return next(action)
                }
                
                effects.forEach{
                    $0.invoke(action, state, dispatch)
                }
                
                return next(action)
            }
        }
    }
}
