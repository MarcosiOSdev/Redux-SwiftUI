//
//  LogMiddleware.swift
//  PostsRedux
//
//  Created by marcos.felipe.souza on 01/09/22.
//

import Foundation

struct LogMiddleware<Action>: Middleware {
    func callAsFunction(action: Action) async -> Action? {
        print("\(action)")
        return action
    }
}
