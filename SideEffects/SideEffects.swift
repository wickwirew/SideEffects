//
//  SideEffects.swift
//  FlipIt
//
//  Created by Wes Wickwire on 11/27/18.
//

import ReSwift

public protocol AnySideEffect {
    func handles(_ action: Action) -> Bool
    func invoke(action: Action, dispatch: @escaping DispatchFunction, state: StateType)
}

public struct SideEffectWithState<A: Action, State: StateType>: AnySideEffect {
    let action: (A, State, @escaping DispatchFunction) -> Void
    public init(action: @escaping (A, State, @escaping DispatchFunction) -> Void) {
        self.action = action
    }
}

public extension SideEffectWithState {
    
    func handles(_ action: Action) -> Bool {
        return action is A
    }
    
    func invoke(action: Action, dispatch: @escaping DispatchFunction, state: StateType) {
        self.action(action as! A, state as! State, dispatch)
    }
}

public func createSideEffectMiddleware<State: StateType>(effects: [AnySideEffect]) -> Middleware<State> {
    return { dispatch, getState in
        return { next in
            return { action in
                
                guard let state = getState() else {
                    return next(action)
                }
                
                effects.filter{ $0.handles(action) }
                    .forEach{ $0.invoke(action: action, dispatch: dispatch, state: state) }
                
                return next(action)
            }
        }
    }
}
