//
//  Middleware.swift
//  PostsRedux
//
//  Created by marcos.felipe.souza on 01/09/22.
//

import Foundation

protocol Middleware {
    associatedtype Action
    func callAsFunction(action: Action) async -> Action?
}
extension Middleware {
    func eraseToAnyMiddleware() -> AnyMiddleware<Action> {
        return self as? AnyMiddleware<Action> ?? AnyMiddleware(self)
    }
}


/// `AnyMiddleware` usado para wrapped do `Middleware` pois ele tem `associatedtype`
struct AnyMiddleware<Action>: Middleware {
    private let wrappedMiddleware: (Action) async -> Action?
    
    init<M: Middleware>(_ middleware: M) where M.Action == Action {
        self.wrappedMiddleware = middleware.callAsFunction(action:)
    }
    func callAsFunction(action: Action) async -> Action? {
        return await wrappedMiddleware(action)
    }
}
