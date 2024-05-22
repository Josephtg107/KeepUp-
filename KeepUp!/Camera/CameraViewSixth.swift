//
//  CameraViewSix.swift
//  KeepUp!
//
//  Created by Joseph Garcia on 03/09/23.
//

import SwiftUI

struct CameraViewSixth: View {
    @State private var isImagePickerPresented: Bool = false
    @State private var backImage: UIImage?

    let userDefaultsKey = "backImageURLForViewSixth"
    
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
            self.loadInitialImage(forKey: userDefaultsKey)
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
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


struct CameraViewSixth_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewSixth()
    }
}
