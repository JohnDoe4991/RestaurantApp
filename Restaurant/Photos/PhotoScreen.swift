//
//  PhotoScreen.swift
//  Restaurant
//
//  Created by John Tejada on 2/13/24.
//

import SwiftUI
import PhotosUI

struct PhotoScreen: View {
    @State private var avatarImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack{
            HStack(spacing:20){
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    Image(uiImage: avatarImage ?? UIImage(systemName: "person.crop.circle")!)
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width:100, height: 100)
                        .clipShape(.circle)
                }
                
                VStack(alignment: .leading) {
                    Text("New User")
                        .font(.largeTitle.bold())
                    
                    Text("iOS Developer")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(30)
        .onChange(of: photoPickerItem) { newItem in
            Task {
                if let photoPickerItem = newItem,
                   let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        avatarImage = image
                    }
                }
                
                self.photoPickerItem = nil // Reset the picker item
            }
        }

    }
}

#Preview {
    PhotoScreen()
}
