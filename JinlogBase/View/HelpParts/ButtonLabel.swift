//
//  ButtonRow.swift
//  LoginScreen
//
//  Created by Ken Oonishi on 2022/08/11.
//

import SwiftUI

struct ButtonLabel: View {
    
    var message: String = "Button"
    var buttonColor: Color
    
    var body: some View {
        Text(message)
            .font(.title3)
            .padding(.all, 12)
            .frame(maxWidth: 400)
            .foregroundColor(.white)
            .background(
                LinearGradient( gradient: Gradient(colors: [InAppColor.buttonColor, InAppColor.buttonColor2]),
                                startPoint: .top,
                                endPoint: .bottom))
            .clipShape(Capsule())
            .padding(.horizontal, 20.0)
            .shadow(radius: 3)
        }
}


struct ButtonLabel_Outline: View {
    
    var message: String = "Button"
    var buttonColor: Color
    
    var body: some View {
        Text(message)
            .font(.title3)
            .padding(.all, 12)
            .frame(maxWidth: 400)
            .foregroundColor(buttonColor)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(buttonColor, lineWidth: 2))
            .padding(.horizontal, 20.0)
        }
}


struct ButtonRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonLabel(buttonColor: InAppColor.buttonColor)
            ButtonLabel_Outline(buttonColor: InAppColor.buttonColor)
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
