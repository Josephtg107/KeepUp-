//
//  mainDashboard.swift
//  KeepUp!
//
//  Created by Joseph Garcia on 31/08/23.
//

import SwiftUI

struct mainDashboard: View {
    
    @ObservedObject var userSettings: UserSettings
    var buttonCount: Binding<Int> { $userSettings.buttonCount }
    var buttonTitles: Binding<[String]> { $userSettings.buttonTitles }
    
    let destinations: [AnyView] = [
        AnyView(CameraViewOne()),
        AnyView(CameraViewTwo()),
        AnyView(CameraViewThree()),
        AnyView(CameraViewFour()),
        AnyView(CameraViewFifth()),
        AnyView(CameraViewSixth()),
        AnyView(CameraViewSeventh()),
        AnyView(CameraViewEight()),
        AnyView(CameraViewNinth()),
        AnyView(CameraViewTenth()),
    ]
    
    @State private var isActive: [Bool] = Array(repeating: false, count: 10)
    @State private var showElements: Bool = true
    @State private var areButtonsEnabled: Bool = true
    
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                Text("Hi \(userSettings.userName)!")
                    .font(Font.custom("InknutAntiqua-Black", size: 60).weight(.heavy))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(red: 0.15, green: 0.3, blue: 0.85))
                    .frame(width: .infinity, height: .infinity, alignment: .topLeading)
                    .padding(.leading)
                
                Text("Good Morning.")
                    .font(Font.custom("Inter", size: 20).weight(.bold))
                    .kerning(5)
                    .foregroundColor(Color(red: 0.59, green: 0.59, blue: 0.59).opacity(0.38))
                    .frame(width: .infinity, height: .infinity, alignment: .topLeading)
                    .padding(.leading)
                
                Image(uiImage: #imageLiteral(resourceName: "WelcomeBar"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding()
                
                    HStack {
                        Text("Today's Activities")
                            .padding()
                        
                        Spacer()
                        
                       Button(action: {
                            if areButtonsEnabled {
                                if self.userSettings.buttonCount < 10 {
                                    self.userSettings.buttonCount += 1
                                }
                            }
                        }) {
                            Image(systemName: "plus.square")
                                .foregroundColor(buttonCount.wrappedValue < 10 ? .blue : .gray)
                        }
                        
                        Button(action: {
                            if areButtonsEnabled {
                                self.userSettings.buttonCount = max(1, self.userSettings.buttonCount - 1)
                                self.userSettings.lastUpdatedTimestamp = Date() // Update timestamp
                            }
                        }) {
                            Image(systemName: "minus.square")
                                .foregroundColor(buttonCount.wrappedValue > 1 ? .red : .gray)
                        }
                    } .padding(.trailing)
                
                
                ForEach(0..<userSettings.buttonCount, id: \.self) { index in
                    if index < destinations.count && index < userSettings.buttonTitles.count {
                        CameraViewButton(destination: destinations[index], titleIndex: index, title: $userSettings.buttonTitles[index], isActive: $isActive[index], userSettings: userSettings)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .onAppear {
            checkFor24HourReset()
        }
    }
    
    func checkFor24HourReset() {
        let currentTime = Date()
        if let lastUpdated = userSettings.lastUpdatedTimestamp,
           currentTime.timeIntervalSince(lastUpdated) >= 30 { // 86400 seconds is 24 hours
            resetUserActions()
        }
    }
        
        func resetUserActions() {
            userSettings.buttonCount = 0
            UserDefaults.standard.set(0, forKey: "buttonCount")
            
            userSettings.buttonTitles = Array(repeating: "", count: 10)
            UserDefaults.standard.set(userSettings.buttonTitles, forKey: "buttonTitles")
            
            userSettings.lastUpdatedTimestamp = Date()
            UserDefaults.standard.set(userSettings.lastUpdatedTimestamp, forKey: "lastUpdatedTimestamp")
    }
}
            
    struct mainDashboard_Previews: PreviewProvider {
        static var previews: some View {
            mainDashboard(userSettings: UserSettings())
        }
    }

        struct CameraViewButton<Destination: View>: View {
            var destination: Destination
            var titleIndex: Int
            @Binding var title: String
            @Binding var isActive: Bool
            @ObservedObject var userSettings: UserSettings
            
            var body: some View {
                HStack {
                    TextField("Enter title", text: $title)
                        .onChange(of: title) { newValue in
                            userSettings.buttonTitles[titleIndex] = newValue
                        }
                    Button(action: {
                        if !title.isEmpty {
                            isActive = true
                        }
                    }) {
                        Image(systemName: "arrowshape.right")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                    }
                    .disabled(title.isEmpty)
                    .background(NavigationLink("", destination: destination, isActive: $isActive).opacity(0))
                }
                .padding()
            }
        }
