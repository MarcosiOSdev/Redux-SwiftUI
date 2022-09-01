//
//  ContentView.swift
//  PostsRedux
//
//  Created by marcos.felipe.souza on 01/09/22.
//

import SwiftUI

struct ApplicationState {
    var count: Int
}

extension ApplicationState: State {
    init() {
        self.init(count: 0)
    }
}

enum ApplicationAction {
    case incrementCount
    case login(String, String)
    case setAccessToken(String)
}

extension ApplicationAction: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.incrementCount, .incrementCount):
            return true
        case let (.login(lhsLogin, lhsPassword), .login(rhsLogin, rhsPassword)):
            return lhsLogin == rhsLogin && lhsPassword == rhsPassword
        case let (.setAccessToken(lhsAccessToken), .setAccessToken(rhsAccessToken)):
            return lhsAccessToken == rhsAccessToken
        default:
            return false
        }        
    }
}

typealias ApplicationStore = Store<ApplicationState, ApplicationAction>

struct ContentView: View {
    
    @StateObject
    private var store: ApplicationStore = ApplicationStore { state, action in
        var newState = state
        switch action {
        case .incrementCount, .login: newState.count += 1
            default : break
        }
        return newState
    } middleware: {
        LogMiddleware()
        LoginMiddleware()
        LogMiddleware()
    }
    
    var body: some View {
        VStack {
            Text("Count: \(store.state.count)")
            
            Button {
                Task {
                    await store.dispatch(action: .incrementCount)
                }
            } label: {
                Text("Increment")
            }
            .buttonStyle(.borderedProminent)

        }.padding()
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
