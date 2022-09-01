//
//  CoreError.swift
//  PostsRedux
//
//  Created by marcos.felipe.souza on 01/09/22.
//

import Foundation
import UIKit

protocol State {
    init()
}

extension Store {
    func dispatch(_ factory: () async -> Action ) async {
        await self.dispatch(action: await factory())
    }
}

actor Store<S: State, Action>: ObservableObject {
    typealias Reducer = (S, Action) -> S
    
    @MainActor @Published private(set) var state: S = .init()
    
    private let middleware: AnyMiddleware<Action>
    private let reducer: Reducer
    
    init<M: Middleware>(
        reducer: @escaping Reducer,
        @MiddlewareBuilder<Action> middleware: () -> M
    ) where M.Action == Action {
        self.reducer = reducer
        self.middleware = middleware().eraseToAnyMiddleware()
    }
    
    convenience init(reducer: @escaping Reducer) {
        self.init(reducer: reducer) {
            EchoMiddleware<Action>().eraseToAnyMiddleware()
        }
    }
    
    func dispatch(action: Action) async {
        guard let newAction = await middleware(action: action) else {
            return
        }
        
        await MainActor.run {
            let currentState = state
            let newState = reducer(currentState, newAction)
            state = newState
        }
    }
}
