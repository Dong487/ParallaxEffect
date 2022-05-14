//
//  MovieItem.swift
//  MovieItem
//
//  Created by DONG SHENG on 2021/8/4.
//

import SwiftUI

struct MovieItem: View {
    
    let movie: Movie
    let screenSize: CGSize
    let width: CGFloat

    var body: some View {
        
        GeometryReader{ reader in
            
            let midX = reader.frame(in: .global).midX
            let distance = abs(screenSize.width / 2 - midX)
            let damping: CGFloat = 4.5     // 還沒移到中央時的 最小Size (越小 對比越大)
            let percentage = abs(distance / (screenSize.width / 2) / damping - 1) //123123 移到螢幕中央變大
            
            VStack {
                Image(movie.imgString)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.blue)
                    .frame(width: width)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .shadow(color: .black.opacity(0.6), radius: 14, y: 10)
                
                Text(movie.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top ,20)
                    .padding(.bottom, 10)
                
                // 電影評分View
                HStack(spacing: 5){
                    
                    ForEach(1 ..< 6){ i in
                        Image(systemName: i <= movie.rating ? "star.fill" : "star")
                            .font(.system(size: 20))
                            .foregroundColor(Color.yellow)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .scaleEffect(percentage)
        }
        .frame(width: width)
        .frame(maxHeight: .infinity)    //大小
   }
}

struct MovieItem_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
