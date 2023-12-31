//
//  MainView.swift
//  First-Try-App
//
//  Created by Max Young on 11/1/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Feed", systemImage: "list.and.film")
                }
            CameraView()
                .tabItem {
                    Label("Record", systemImage: "camera")
                }
            LeaderView()
                .tabItem {
                    Label("Rankings", systemImage: "trophy")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
