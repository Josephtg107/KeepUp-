//
//  AuthenticationView.swift
//  KeepUp!
//
//  Created by Joseph Garcia on 23/05/24.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInview: Bool
    
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView(showSignInview: .constant(false))
            } label: {
                Text("Sign in with Email")
                    .font(.headline)
                    .foregroundStyle(Color(.white))
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInview: .constant(false))
    }
}
