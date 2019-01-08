// MIT License
//
// Copyright (c) 2019 Wes Wickwire
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
