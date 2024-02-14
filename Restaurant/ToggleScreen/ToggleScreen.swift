//
//  ToggleScreen.swift
//  Restaurant
//
//  Created by John Tejada on 2/13/24.
//

import SwiftUI



struct ToggleScreen: View {
    @EnvironmentObject var userInfo: UserInformation
    
    @State private var isToggleOn = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $isToggleOn) {
                Text("Who Am I?")
            }
            .padding()
            
            if isToggleOn {
                Text("\(userInfo.firstName) \(userInfo.lastName)") 
            } else {
                Text("Toggle is off")
            }
        }
    }
}


struct ToggleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ToggleScreen().environmentObject(UserInformation())
    }
}

