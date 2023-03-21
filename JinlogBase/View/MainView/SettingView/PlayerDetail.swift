//
//  PlayerDetail.swift
//  JinlogBase
//
//  Created by Ken Oonishi on 2022/09/03.
//

import SwiftUI
//import Charts

struct PlayerDetail: View {
    
    let username :String
        
    var body: some View {
        
        PlayerRow(username: username)
            .frame(width:250)
            .background(InAppColor.textFieldColor)
            .cornerRadius(20)
            .shadow(radius: 3)
    
    }
}

struct PlayerDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetail(username: "Ken")
    }
}
