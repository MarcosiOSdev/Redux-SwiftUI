//
//  MiddlewarePipeline.swift
//  PostsRedux
//
//  Created by marcos.felipe.souza on 01/09/22.
//

import Foundation

/// `MiddlewarePipeline` usado para utilizar mais de um middleware e eles concatenados.
struct MiddlewarePipeline<Action>: Middleware {
    private let middleware: [AnyMiddleware<Action>]

    init(_ middleware: [AnyMiddleware<Action>]) {
        self.middleware = middleware
    }

    func callAsFunction(action: Action) async -> Action? {
        var currentAction: Action = action
        for m in middleware {
            guard let newAction = await m(action: currentAction) else {
                return nil
            }

            currentAction = newAction
        }

        return currentAction
    }
}
