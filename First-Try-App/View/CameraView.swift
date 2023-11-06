//
//  ProfileView.swift
//  First-Try-App
//
//  Created by Max Young on 11/2/23.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = FrameHandler()
    
    var body: some View {
        FrameView(image: model.frame)
            .ignoresSafeArea()
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
