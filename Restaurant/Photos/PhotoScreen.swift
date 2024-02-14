//
//  PhotoScreen.swift
//  Restaurant
//
//  Created by John Tejada on 2/13/24.
//

import SwiftUI
import PhotosUI

struct PhotoScreen: View {
    @State private var images: [UIImage] = []
    @State private var photoPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack{
            PhotosPicker("Select Photos", selection: $photoPickerItems, maxSelectionCount: 5, selectionBehavior: .ordered)
            
            ScrollView(.horizontal) {
                    HStack(spacing:20){
                        ForEach(0..<images.count, id: \.self) {i in
                        Image(uiImage: images[i])
                            .resizable()
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .frame(width:100, height: 100)
                            .clipShape(.circle)
                    }
                }
            }
        }
        .padding(30)
        .onChange(of: photoPickerItems) { newItem in
            Task {
                for item in photoPickerItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            images.append(image)
                        }
                    }
                }
                
                self.photoPickerItems.removeAll() // Reset the picker item
            }
        }
        .navigationTitle("Photos")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: ToggleScreen()) {
                                Text("Next")
                            }
                        }
                    }
                }
            }

#Preview {
    PhotoScreen()
}
