//
//  ContentView.swift
//  KeepUp!
//
//  Created by Joseph Garcia on 21/08/23.
//

/*
 DOCUMENTATION
 
 
 COMMIT USAGE
 
 */

import SwiftUI

struct ContentView: View {
    @ObservedObject var userSettings = UserSettings()
        @State private var showNavigationLink: Bool = UserDefaults.standard.string(forKey: "userName") != nil
        @State private var isEditable: Bool = UserDefaults.standard.string(forKey: "userName") == nil
    
    init() {
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            userSettings.userName = savedName
            self._showNavigationLink = State(initialValue: true)
            self._isEditable = State(initialValue: false)
        } else {
            self._showNavigationLink = State(initialValue: false)
            self._isEditable = State(initialValue: true)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if isEditable {
                    Spacer()
                }
                Spacer()
                Image("KeepUp!logo")
                    .resizable()
                    .frame(width: 250, height: 80)
                    .padding()
                
                if isEditable {
                    TextField("Enter your name", text: $userSettings.userName, onCommit: {
                        if !userSettings.userName.isEmpty {
                            showNavigationLink = true
                            isEditable = false
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                } else {
                    Text(userSettings.userName)
                        .padding()
                    
                    if showNavigationLink {
                        NavigationLink(destination: mainDashboard(userSettings: userSettings)) {
                            Text("Go to Main Dashboard")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                    HStack {
                        Text("UserName:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if showNavigationLink {
                            Button(action: {
                                isEditable.toggle()
                            }) {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func formattedDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter.string(from: date)
}
