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
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    func Check() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            setUp()
            return
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
            
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
            
        }
    }
    
    func setUp() {
        do {
            
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        }
        catch {
            
            print(error.localizedDescription)
            
        }
    }
    
    func takePic() {
        
        DispatchQueue.global(qos: .background).async {
            
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation{ self.isTaken.toggle() }
            }
            
        }
        
    }
    
    func retake() {
        
        DispatchQueue.global(qos: .background).async {
            
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation{ self.isTaken.toggle() }
                self.isSaved = false
            }
            
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if error != nil { return }
        
        print("pic taken successfully")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.picData = imageData
        
    }
    
    func savePic() {
        
        guard let image = UIImage(data: self.picData) else {
            print("Failed to create UIImage from picData")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG data")
            return
        }
        
        let key = "images/\(UUID().uuidString).jpg"
        
        let uploadTask = Amplify.Storage.uploadData(key: key, data: imageData)
        
        Task {
            for await progress in await uploadTask.progress {
                print("Upload progress: \(progress.fractionCompleted)")
            }
        }
    }
}
