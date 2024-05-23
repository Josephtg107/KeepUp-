//
//  RootView.swift
//  KeepUp!
//
//  Created by Joseph Garcia on 23/05/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInview: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignInView: $showSignInview)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInview = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInview) {
            NavigationStack {
                AuthenticationView(showSignInview: $showSignInview)
            }
        }
    }
}

#Preview {
    RootView()
}
