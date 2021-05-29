//
//  DrawingScreen.swift
//  UI-212
//
//  Created by にゃんにゃん丸 on 2021/05/29.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @EnvironmentObject var model : DrawingViewModel
    var body: some View {
        ZStack{
            
            GeometryReader{proxy -> AnyView in
                
                let size = proxy.frame(in: .global)
                
                
                DispatchQueue.main.async {
                    if model.rect == .zero{
                        
                        model.rect = size
                    }
                }
                
                return AnyView(
                
                    ZStack{
                        
                        CanVasView(canvas: $model.canvas, imageData: $model.imageData, toolPicker: $model.toolPicker, rect: size.size)
                        
                        ForEach(model.textBoxes){box in
                            
                            Text(model.textBoxes[model.currentIndex].id == box.id && model.addNewBox ? "" : box.text)
                                .font(.system(size: box.size))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundColor(box.textcolor)
                                .offset(box.offset)
                                .gesture(DragGesture().onChanged({ value in
                                    
                                    
                                    let current = value.translation
                                    let lastoffset = box.lastoffset
                                    
                                    let newTranslation = CGSize(width: lastoffset.width + current.width, height: lastoffset.height + current.height)
                                    
                                    model.textBoxes[getIndex(textbox: box)].offset = newTranslation
                                    
                                    
                                    
                                }).onEnded({ value in
                                    
                                    model.textBoxes[getIndex(textbox: box)].lastoffset = value.translation
                                }))
                            
                                .onLongPressGesture {
                                    
                                    
                                    model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                                    model.canvas.resignFirstResponder()
                                    model.currentIndex = getIndex(textbox: box)
                                    withAnimation{
                                        
                                        
                                        model.addNewBox = true
                                        
                                    }
                                }
                            
                            
                            
                            
                        }
                        
                    }
                
                )
                
            }
            
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                
                Button(action: {
                    
                    model.SaveImage()
                }, label: {
                    Text("SAVE")
                })
                
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                
                Button(action: {
                    
                    model.textBoxes.append(TextBox())
                    model.currentIndex = model.textBoxes.count - 1
                    
                    
                    withAnimation{
                        
                        model.addNewBox.toggle()
                    }
                    
                    model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                    
                }, label: {
                 Image(systemName: "plus")
                })
                
            }
        })
    }
    
    func getIndex(textbox : TextBox)->Int{
        
        let index = model.textBoxes.firstIndex { box in
            textbox.id == box.id
        } ?? 0
        
        return index
        
        
        
        
    }
}

struct DrawingScreen_Previews: PreviewProvider {
    static var previews: some View {
       Home()
    }
}
struct CanVasView : UIViewRepresentable {
    
    @Binding var canvas : PKCanvasView
    
    @Binding var imageData : Data
    
    @Binding var toolPicker :PKToolPicker
    
    var rect : CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.drawingPolicy = .anyInput
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        
        if let image = UIImage(data: imageData){
            
            let ImageView = UIImageView(image: image)
            
            ImageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            ImageView.contentMode = .scaleAspectFit
            ImageView.clipsToBounds = true
            
            let subView = canvas.subviews[0]
            subView.addSubview(ImageView)
            subView.sendSubviewToBack(ImageView)
            
            
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        
            
            
            
            
            
        }
        
        
        
        
        
        
        
        return canvas
    
        
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}
