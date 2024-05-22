//
//  CameraViewOne.swift
//  KeepUp!
//
//  Created by Joseph Garcia on 03/09/23.
//

import SwiftUI

struct CameraViewOne: View {
    @State private var isImagePickerPresented: Bool = false
    @State private var backImage: UIImage?
    
    let userDefaultsKey = "backImageURLForViewOne"
    
    var body: some View {
        VStack {
            if let backImage = backImage {
                Image(uiImage: backImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Button("Take Photo") {
                isImagePickerPresented = true
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(isPresented: $isImagePickerPresented, backImage: $backImage)
        }
        .onChange(of: backImage) { newImage in
            if let newImage = newImage {
                saveImageToUserDefaults(image: newImage, forKey: userDefaultsKey)
            }
        }
        .onAppear {
            checkAndRemoveImageIfExpired(forKey: userDefaultsKey)
            if backImage == nil {
                self.loadInitialImage(forKey: userDefaultsKey)
            }
        }
    }
    
    func loadInitialImage(forKey key: String) {
        if let imageUrlString = UserDefaults.standard.string(forKey: key),
           let imageURL = URL(string: imageUrlString),
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            self.backImage = image
        }
    }
    
    func saveImageToUserDefaults(image: UIImage, forKey key: String) {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        let filename = getDocumentsDirectory().appendingPathComponent("\(key).jpg")
        
        do {
            try data.write(to: filename)
            UserDefaults.standard.set(filename.absoluteString, forKey: key)
        } catch {
            print("Could not save image")
        }
        UserDefaults.standard.set(Date(), forKey: key + "Timestamp")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func checkAndRemoveImageIfExpired(forKey key: String) {
        if let savedDate = UserDefaults.standard.object(forKey: key + "Timestamp") as? Date,
           Date().timeIntervalSince(savedDate) >= 30  { //Remove the Image after 24 hours
            print("Image is expired. Removing it.")
            self.removeImage(forKey: key)
        }
    }
    
    func removeImage(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.removeObject(forKey: key + "Timestamp")
        
        if let imageUrlString = UserDefaults.standard.string(forKey: key),
           let imageURL = URL(string: imageUrlString) {
            do {
                try FileManager.default.removeItem(at: imageURL)
            } catch {
                print("Failed to remove image from directory: \(error)")
            }
        } else {
            print("Couldn't find image URL in UserDefaults.")
        }
        self.backImage = nil
    }
}
    


struct CameraViewOne_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewOne()
    }
}





//struct FirstView: View {
//    @State private var isCameraPresented: Bool = false
//    @State private var image: UIImage?
//
//    var body: some View {
//        VStack {
//            if let image = image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//            }
//
//            Button("Open Camera") {
//                isCameraPresented.toggle()
//            }
//            .sheet(isPresented: $isCameraPresented) {
//                ImagePicker(isPresented: $isCameraPresented, image: $image)
//            }
//        }
//    }
//}

