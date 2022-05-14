//
//  ContentView.swift
//  ParallaxEffect
//
//  Created by DONG SHENG on 2021/8/2.
//

import SwiftUI

struct Movie: Identifiable{
    
    var id: String { title }
    
    let title: String
    let rating: Int
    let imgString: String
    var bgString: String?
    
    static let sampleMovies = [
        Movie(title: "玩命抄劫", rating: 5, imgString: "m1", bgString: "m1"),
        Movie(title: "緝魂", rating: 2, imgString: "m22", bgString: "m22"),
        Movie(title: "玩命關頭 9", rating: 5, imgString: "m3", bgString: "m3"),
        Movie(title: "噪反", rating: 5, imgString: "m4", bgString: "m4"),
        Movie(title: "寶貝老大：家大業大", rating: 5, imgString: "m7", bgString: "m7"),
        Movie(title: "詭老", rating: 5, imgString: "m8", bgString: "m8"),
        Movie(title: "怪奇大廈", rating: 5, imgString: "m9", bgString: "m9"),
        Movie(title: "失控特工", rating: 5, imgString: "m10", bgString: "m10"),
        Movie(title: "未知嫌疑人", rating: 5, imgString: "m11", bgString: "m11")
        
    ]
}

struct ContentView: View {
    
    let movies = Movie.sampleMovies
    
    @State private var offsetX : CGFloat = 0
    @State private var maxOffsetX: CGFloat = -1
    
    var body: some View {
        GeometryReader{ reader in
            
            let screenSize = reader.size
            
            ZStack{
                
               backgroundCarousel(screenSize: screenSize)
                
                moviesCarousel(reader: reader)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    //後面
    func backgroundCarousel(screenSize: CGSize) -> some View{
        
        let bgWidth: CGFloat = screenSize.width * CGFloat(movies.count)
        let scrollPercentage = offsetX / maxOffsetX
        let clampedPercentage: CGFloat = 1 - max(0 , min(scrollPercentage, 1))
        let posX: CGFloat = (bgWidth -  screenSize.width) * clampedPercentage
        
        return HStack(spacing: 0){
            
            ForEach(movies.reversed()){ movie in
                
                Image(movie.bgString ?? movie.imgString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenSize.width)
                    .frame(maxHeight: .infinity)
                    .blur(radius: 1)
                    .scaleEffect(1.004)
                    .clipped()
                    .overlay(Color.black.opacity(0.45))
                    .ignoresSafeArea()
            }
        }
        .frame(width: bgWidth)
        .position(x: bgWidth / 2 - posX, y: screenSize.height / 2)
    }
    //前面
    func moviesCarousel(reader: GeometryProxy) -> some View{
        
        let screenSize = reader.size // 裡面有 .width(CGFloat) .height(CGFloat)
        let itemWidth : CGFloat = screenSize.width * 0.8 // 每一張電影圖片大小 為設備寬度*0.8
        
        
        //  讓Scroll 前後 多出一些空間 圖片才能置中
        let paddingX: CGFloat = (screenSize.width - itemWidth) / 2
        let spacing: CGFloat = 10
        
        return ScrollView(.horizontal){
            
            HStack(spacing: 0){
                
                GeometryReader{ geo -> Color in
                    
                    
                    DispatchQueue.main.async {
                        
                        offsetX = (geo.frame(in: .global).minX - paddingX) * -1
                        
                        let scrollContentWidth = itemWidth * CGFloat(movies.count) + spacing * CGFloat(movies.count - 1)
                        
                        let maxOffsetX = scrollContentWidth + 2 * paddingX - screenSize.width
                        
                        if self.maxOffsetX == -1 {
                            
                            self.maxOffsetX = maxOffsetX
                        }
                        print(offsetX / maxOffsetX)
                    }
                    return Color.clear
                }
                .frame(width: 0)
                
                HStack(spacing: spacing){
                    
                    ForEach(movies){ movie in
                        
                        MovieItem(movie: movie, screenSize: screenSize, width: itemWidth)
                    }
                }
            }
            .padding(.horizontal, paddingX)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
