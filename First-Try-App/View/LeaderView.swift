//
//  LeaderView.swift
//  First-Try-App
//
//  Created by Max Young on 11/2/23.
//

import SwiftUI

struct LeaderView: View {
    var body: some View {
        NavigationStack {
            ScrollView {}
            .navigationTitle("LeaderBoard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderView()
    }
}
