//
//  CameraView.swift
//  CampusPets
//
//  Created by Justin Souza on 6/22/24.
//

import SwiftUI
import Foundation
import AVFoundation

struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    @EnvironmentObject private var entryService: EntryService
    @EnvironmentObject private var storageService: StorageService
    @EnvironmentObject var mapModel: MapModel
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
            
                Spacer()
                
                if camera.isTaken {
                    VStack {
                        HStack {
                            
                            Button(action: camera.retake, label: {
                                Text("Retake")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            })
                            
                            Spacer()
                            
                            Button(action: { camera.showingEntryForm = true }, label: {
                                Text("Use Photo")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            })
                            
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                        
                } else {
                    
                    Spacer()
                    
                    Button(action: camera.takePic, label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 65, height: 65)
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 75, height: 75)
                        }
                    })
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $camera.showingEntryForm) {
            EntryFormSheet(camera: camera, mapModel: mapModel)
        }
        .onAppear {
            camera.Check()
        }
        .onDisappear {
            camera.session.stopRunning()
        }
    }
}
