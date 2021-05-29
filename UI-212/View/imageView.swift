//
//  imageView.swift
//  UI-212
//
//  Created by にゃんにゃん丸 on 2021/05/29.
//

import SwiftUI

struct imageView: UIViewControllerRepresentable {
    
    @Binding var showPicker : Bool
    @Binding var imageData : Data
    func makeCoordinator() -> Coordinator {
        
        return imageView.Coordinator(parent: self)
        
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let view = UIImagePickerController()
        view.sourceType = .photoLibrary
        
        view.delegate = context.coordinator
        return view
        
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : imageView
        
        init(parent : imageView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            if let imageData = (info[.originalImage] as? UIImage)?.pngData(){
                
                parent.imageData = imageData
                parent.showPicker.toggle()
                
                
            }
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showPicker.toggle()
            
        }
        
        
        
        
        
        
    }
}

