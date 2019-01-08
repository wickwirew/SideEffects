//
//  SideEffects.swift
//  SideEffects
//
//  Created by Wes Wickwire on 11/27/18.
//

import ReSwift

// Hide the `SideEffect` type under the `Store` similarly to `ActionCreator`
// Each app should make a type alias for this for ease of use.
extension Store {
    
    /// A `SideEffect` is an action or side effect that happens as of a result
    /// of an `Action` being dispatched.
    public struct SideEffect {

        /// The action to invoke
        let invoke: (Action, State, @escaping DispatchFunction) -> Void

        /// Initializes a new `SideEffect`
        ///
        /// - Parameter actionType: The type of action that should trigger the side effect.
        /// - Parameter handler: A closure that is called when the side effect is invoked.
        public init<A: Action>(of actionType: A.Type,
                               handler: @escaping (A, State, @escaping DispatchFunction) -> Void) {
            self.invoke = { action, state, dispatch in
                // filter out any actions of incorrect type and then invoke.
                guard let action = action as? A else { return }
                handler(action, state, dispatch)
            }
        }
    }
}

/// Initializes a new Redux middleware to handle the list of `SideEffect`s
///
/// - Parameter effects: All of the application side effects
/// - Returns: A middleware to invoke side effects.
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
