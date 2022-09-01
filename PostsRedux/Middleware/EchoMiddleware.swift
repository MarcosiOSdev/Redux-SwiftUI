//
//  EchoMiddleware.swift
//  PostsRedux
//
//  Created by marcos.felipe.souza on 01/09/22.
//

import Foundation

/// `EchoMiddleware` usado para atribuir um nil.
struct EchoMiddleware<Action>: Middleware {
    func callAsFunction(action: Action) async -> Action? {
        return action
    }
}
