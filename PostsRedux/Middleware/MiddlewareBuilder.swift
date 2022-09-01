//
//  MiddlewareBuilder.swift
//  PostsRedux
//
//  Created by marcos.felipe.souza on 01/09/22.
//

import Foundation

@resultBuilder
struct MiddlewareBuilder<Action> {
    static func buildBlock(
        _ components: AnyMiddleware<Action>...
    ) -> MiddlewarePipeline<Action> {
        MiddlewarePipeline(components)
    }

    static func buildExpression<M: Middleware>(
        _ expression: M
    ) -> AnyMiddleware<Action> where M.Action == Action {
        expression.eraseToAnyMiddleware()
    }

    static func buildFinalResult<M: Middleware>(
        _ component: M
    ) -> AnyMiddleware<Action> where M.Action == Action {
        component.eraseToAnyMiddleware()
    }

    static func buildOptional(
        _ component: MiddlewarePipeline<Action>?
    ) -> AnyMiddleware<Action> {
        guard let component = component else {
            return EchoMiddleware<Action>().eraseToAnyMiddleware()
        }

        return component.eraseToAnyMiddleware()
    }
}
