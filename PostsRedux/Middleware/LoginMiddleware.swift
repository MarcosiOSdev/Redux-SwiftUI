//
//  LoginMiddleware.swift
//  PostsRedux
//
//  Created by marcos.felipe.souza on 01/09/22.
//

import Foundation

struct LoginMiddleware: Middleware {
    func callAsFunction(action: ApplicationAction) async -> ApplicationAction? {
        
        if action == .incrementCount {
            return .login("Markim", "123")
        }
        
        guard case let .login(username, password) = action else {
            return action
        }

        print("TODO: asynchronously login with \(username) and \(password)")

        return .setAccessToken("AUTHORIZED")
    }
}

