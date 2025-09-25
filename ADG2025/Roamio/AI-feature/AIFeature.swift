//
//  AIFeatures.swift
//  adg trial
//

import SwiftUI
import UIKit

struct AIFeatures: View {
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var prediction: String = "Take or upload a photo to identify the monument"
    @State private var isProcessing: Bool = false // if app is analyzing if yes spinning

    var body: some View {
        VStack(spacing: 20) {
            
            // Image preview
            if let image = selectedImage {
                Image(uiImage: image) // convert ui to swift img
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(Text("No image selected"))
                    .cornerRadius(12)
            }
            
            // Prediction text
            Text(prediction)
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)
            
            // Activity indicator
            if isProcessing {
                ProgressView("Analyzing...") // shows loading indicator
            }
            
            // Camera button
            Button(action: {
                if UIImagePickerController.isSourceTypeAvailable(.camera)
                // checks if the device has a camera if yes show
                {
                    showCamera = true
                }
            })
            {
                Label("Open Camera", systemImage: "camera.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
            // Sample image button
            Button("Use Random Sample Image") {
                let sampleImages = ["tajmahal", "indiagate", "redfort",
                                    "goldenbridge", "qutubminar",
                                    "goldentemple", "lotustemple"]
                if let randomName = sampleImages.randomElement(),
                   let sample = UIImage(named: randomName) {
                    selectedImage = sample
                    //    uploadImage(sample)
                    // sets @state to this new random image
                    prediction = " this looks like-: \(randomName.capitalized)"
                    
                    
                } else {
                    prediction = "Could not load sample image"
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            
        }
        .padding()
        .navigationTitle("AI Monument Scanner")
        .navigationBarTitleDisplayMode(.inline)
            
        .sheet(isPresented: $showCamera) { // pop up screen
            // is presented-controls whether screen is visible or no
            CameraPicker(selectedImage: $selectedImage, onImagePicked: uploadImage)
            
            // selectedImage: $selectedImage
          //  A binding to your state variable selectedImage.
//  When CameraPicker sets a photo, it updates your main screen automatically.

         //   onImagePicked: uploadImage

          //  Tells CameraPicker: “When a new image is captured, call this function (uploadImage) to process or send it.”
        }
    }
    
    // MARK: - Call API send pic to server
    private func uploadImage(_ image: UIImage) // takes 1 imput a uiimg
    {
        isProcessing = true // sets loading
        prediction = "Uploading..." //

        APIService.shared.uploadImage(image) // calls the api service and sends img to server
        
        
        { result in  // what to do when server replies
            
            DispatchQueue.main.async // ensures ui update happpends on main thread
            {
                self.isProcessing = false // stop showing spinner we done
                switch result { // result can be success or fail handles both
                case .success(let response): // decodes json
                    let confidence = Int((response.probabilities.max() ?? 0) * 100)
                    self.prediction = "This looks like \(response.predicted_class)\nConfidence: \(confidence)%"
                case .failure(let error): // contains details of error
                    self.prediction = "Upload failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Camera Picker

//the bridge that lets SwiftUI open the native iOS Camera (UIKit component) and send the captured photo back into your SwiftUI view.
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onImagePicked: (UIImage) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onImagePicked(image)
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview{
    AIFeatures()
}
