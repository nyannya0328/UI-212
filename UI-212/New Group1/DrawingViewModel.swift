//
//  DrawingViewModel.swift
//  UI-212
//
//  Created by にゃんにゃん丸 on 2021/05/29.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    
    @Published var showPicker = false
    @Published var imageData = Data(count: 0)
    
    @Published var canvas = PKCanvasView()
    
    @Published var toolPicker = PKToolPicker()
    
    @Published var textBoxes : [TextBox] = []
    
    @Published var addNewBox = false
    
    @Published var currentIndex : Int = 0
    
    @Published var message = ""
    @Published var showAlert = false
    
    @Published var rect : CGRect = .zero
    
    
    
    func SaveImage(){
        
        
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        
        let SwiftUIview = ZStack{
            
            ForEach(textBoxes){ [self] box in
                
                Text(textBoxes[currentIndex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: box.size))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textcolor)
                    .offset(box.offset)
            
            
            
        }
        }
        
        let hostview = UIHostingController(rootView: SwiftUIview).view!
        
        hostview.frame = rect
        hostview.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        hostview.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        
        
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        
        if let image = generatedImage?.pngData(){
            
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            
            print("Success")
            self.message = "OK"
            showAlert.toggle()
            
            
            
        }
        
        
    }
    
    
    func cancelImgeEditing(){
        imageData = Data(count: 0)
        
        canvas =  PKCanvasView()
        
        
        textBoxes.removeAll()
        
    }
    
    func cancelTextView(){
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
    
        canvas.becomeFirstResponder()
        
        withAnimation{
            
            addNewBox = false
        }
        
        if !textBoxes[currentIndex].isAdded{
            
            textBoxes.removeLast()
         
        }
        
        
        
        
        
    }
  
}

