//
//  CameraModel.swift
//  CampusPets
//
//  Created by Justin Souza on 6/22/24.
//

import SwiftUI
import Foundation
import AVFoundation
import Amplify
import AWSS3StoragePlugin



class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    @Published var picData = Data(count: 0)
    @Published var showingEntryForm = false
    
    func Check() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                
            case .authorized:
                DispatchQueue.main.async {
                    self.setUp()
                }
                return
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    if status {
                        DispatchQueue.main.async {
                            self.setUp()
                        }
                    }
                }
                
            case .denied:
                DispatchQueue.main.async {
                    self.alert.toggle()
                }
                return
                
            default:
                return
                
            }
        }
    }
    
    func setUp() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            do {
                self.session.beginConfiguration()
                
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
                let input = try AVCaptureDeviceInput(device: device!)
                
                if self.session.canAddInput(input) { self.session.addInput(input) }
                
                if self.session.canAddOutput(self.output) { self.session.addOutput(self.output) }
                
                self.session.commitConfiguration()
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func takePic() {
        
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        withAnimation{ self.isTaken.toggle() }
    }
    
    func retake() {
        
        self.session.startRunning()
        withAnimation{ self.isTaken.toggle() }
        self.showingEntryForm = false
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        self.session.stopRunning()
        
        if error != nil { return }
        
        print("pic taken successfully")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.picData = imageData
        
    }
}

struct EntryFormSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var entryService: EntryService
    @EnvironmentObject private var storageService: StorageService
    @ObservedObject var camera: CameraModel
    @ObservedObject var mapModel: MapModel
    
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Button("Create Entry") {
                    let imageName = UUID().uuidString
                    let entry = Entry(
                        name: name,
                        description: description.isEmpty ? nil : description,
                        image: imageName,
                        latitude: mapModel.currentLocation?.coordinate.latitude ?? 0,
                        longitude: mapModel.currentLocation?.coordinate.longitude ?? 0
                    )
                    
                    Task {
                        await storageService.upload(camera.picData, name: imageName)
                        await entryService.save(entry)
                        mapModel.addAnnotation(entry)
                        dismiss()
                    }
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("New Entry")
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
}
