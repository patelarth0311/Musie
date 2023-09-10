//
//  Helpers.swift
//  Musie
//
//  Created by Arth Patel on 8/15/23.
//

import Foundation
import SwiftUI
import MusicKit

struct CardStyle: ViewModifier {
func body(content: Content) -> some View {
content
    .padding()
    .foregroundColor(.white)
    .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
   
    .clipShape(RoundedRectangle(cornerRadius: 20))
   
}
}

struct ScrollItemStyle : ViewModifier {
func body(content: Content) -> some View {
content
    .padding(2)
   
    .frame(maxWidth: .infinity)
    .scrollTransition(.animated.threshold(.visible(0.3))) { content, phase in
     
        content
            .opacity(phase.isIdentity ? 1.0 : 0.85)
            .scaleEffect(phase.isIdentity ? 1.0 : 0.80)
     
           
     
    }

}
}

struct BlurredNavBar : ViewModifier {
var height:  CGFloat
var color: Color?
func body(content: Content) -> some View {
content
    .overlay(alignment: .top) {
        VStack {
            
            if let color = self.color {
                Color(color.opacity(0.9))
                  
                   
                   
              
            } else {
                TransparentBlurView()
                    .blur(radius:20,opaque: false)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
     
        .frame(height: height)
            .padding([.leading,.trailing],-30)
        
            .padding(.top,-35)
            .ignoresSafeArea(.all)
        
           
    }
}

}

struct MusicItemCardStyle : ViewModifier {
var specBG : SpecBG
var color : Color

func body(content: Content) -> some View {
    content
    
      .if(specBG == .avgColor, transform: { view in
          view
              .background( color.brightness(0.04) )
              .getContrastText(backgroundColor: Color(color))
      })
       
          .listRowBackground(Color(red: 0.07, green: 0.07, blue: 0.07))
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets(top: 4.0, leading: 10.0, bottom: 4.0, trailing: 10.0))
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .padding(1)
}

}


extension View {
func cardStyle() -> some View {
    modifier(CardStyle()) 
}

func scrollItemStyle() -> some View {
modifier(ScrollItemStyle())
}

func musicItemCardStyle(specBG: SpecBG, color: Color) -> some View {
modifier(MusicItemCardStyle(specBG: specBG, color: color))
}

func blurredNavBar(height: CGFloat, color: Color? = nil) -> some View {
modifier(BlurredNavBar(height: height, color: color))
}

func getContrastText(backgroundColor: Color) -> some View {
var r, g, b, a: CGFloat
(r, g, b, a) = (0, 0, 0, 0)
UIColor(backgroundColor).getRed(&r, green: &g, blue: &b, alpha: &a)
let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
return  luminance < 0.6 ? self.foregroundColor(.white) : self.foregroundColor(.black)

}

@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {

if condition {
    transform(self)
} else {
    self
        .background(.ultraThinMaterial
        )
}
}
}

extension UIImage {
var averageColor: UIColor? {
guard let inputImage = CIImage(image: self) else { return nil }
let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
guard let outputImage = filter.outputImage else { return nil }

var bitmap = [UInt8](repeating: 0, count: 4)
let context = CIContext(options: [.workingColorSpace: kCFNull])
context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
}
}

struct InsightView : View, Animatable {

var title: String
var geometry: GeometryProxy
var number: Double
var animatableData: Double {
get {number}
set {number = newValue}
}

var body: some View {
VStack {
    HStack {
        Text(title)
            .font(.system(.title3,weight: .semibold))
            .foregroundStyle(.secondary)
        Spacer()
    }
    
    
    Text("\(Int(number))")
     
        .font(.system(size: 1000, weight: .bold))
        .minimumScaleFactor(0.05)
        .lineLimit(1)
       
        .frame(width: geometry.size.width * 0.4)
        .frame(height: geometry.size.width * 0.1)
       
       
    
    Spacer()
        
}



}
}

struct DateView : View {

var recentlyListenDate : Date?
var addedDate : Date?
var geometry: GeometryProxy

var body: some View {

HStack(alignment: .bottom, spacing: 10) {
    VStack(alignment: .leading) {
        HStack {
            Text("Last Played")
                .font(.system(.title3,weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer()
        }
        
        
        if let recentlyListenDate = self.recentlyListenDate {
            Text(recentlyListenDate.formatted(date: .long, time: .omitted))
                .font(.system(.title2, weight: .bold))
               
                .lineLimit(1)
               
        } else {
            Text("N/A")
                .font(.system(.title2, weight: .bold))
        }
       
        
        
    }
    
    
    VStack(alignment: .leading) {
        HStack {
            Text("Added")
                .font(.system(.title3,weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer()
        }
        
        if let addedDate = self.addedDate {
            Text(addedDate.formatted(date: .long, time: .omitted))
                .font(.system(.title2, weight: .bold))
              
                .lineLimit(1)
                
            
        } else {
            Text("N/A")
                .font(.system(.title2, weight: .bold))
        }
        
        
        
        
    }
}

}
}


func sortSongs(sortOption: SortOption, _ completion: @escaping (_ data: MusicItemCollection<MusicKit.Song>) -> Void) {
    
    Task(priority: .high) {
        var songSortRequest = MusicLibraryRequest<MusicKit.Song>()
        let songSortResult = try await songSortRequest.sort(by: sortOption).response()
        completion(songSortResult.items)
       
    }

   
}

func sortArtists(sortOption: SortOption, _ completion: @escaping (_ data: MusicItemCollection<MusicKit.Artist>) -> Void) {
    Task(priority: .high) {
        var artistSortRequest = MusicLibraryRequest<MusicKit.Artist>()
        let artistSortResult = try await artistSortRequest.sort(by: sortOption).response()
        completion(artistSortResult.items)
       
    }

}

func sortAlbums(sortOption: SortOption, _ completion: @escaping (_ data: MusicItemCollection<MusicKit.Album>) -> Void) {
    
    Task(priority: .high) {
        var albumSortRequest = MusicLibraryRequest<MusicKit.Album>()
        let albumSortResult = try await albumSortRequest.sort(by: sortOption).response()
        completion(albumSortResult.items)
    }

}





enum ContentType: String {
case songs = "Songs"
case artists = "Artists"
case albums = "Albums"


var filterOption : [SortOption] {
    switch self {
    case .songs:
        return  [.title,.recentlyAdded,.lastPlayed,.artist,.playCount]
    case .artists:
        return [.name, .recentlyAdded]
    case .albums:
        return [.title,.recentlyAdded,.lastPlayed,.artist]
    }
}


}



enum SortOption : String {


case title = "Title"
case artist = "Artist"
case playCount = "Play count"
case recentlyAdded = "Recently added"
case lastPlayed = "Last played"
case name = "Name"

}

extension MusicLibraryRequest<MusicKit.Song> {
    func sort(by sortOption: SortOption) -> Self {
        var request = self
        switch sortOption {
        case .title:
      
            request.sort(by: \.title, ascending: true)
        case .artist:
            request.sort(by: \.artistName, ascending: true)
        case .playCount:
            request.sort(by: \.playCount, ascending: false)
        case .recentlyAdded:
            request.sort(by: \.libraryAddedDate, ascending: false)
        case .lastPlayed:
            request.sort(by: \.lastPlayedDate, ascending: false)
        default:
            request.sort(by: \.title, ascending: true)
        }
        return request
    }
}

extension MusicLibraryRequest<MusicKit.Album> {
    func sort(by sortOption: SortOption) -> Self {
        var request = self
        switch sortOption {
        case .title:
            request.sort(by: \.title, ascending: true)
        case .artist:
            request.sort(by: \.artistName, ascending: true)
        case .recentlyAdded:
            request.sort(by: \.libraryAddedDate, ascending: false)
        case .lastPlayed:
            request.sort(by: \.lastPlayedDate, ascending: false)
        default:
            request.sort(by: \.title, ascending: true)
        }
        return request
    }
}

extension MusicLibraryRequest<MusicKit.Artist> {
    func sort(by sortOption: SortOption) -> Self {
        var request = self
        switch sortOption {
        case .recentlyAdded:
            request.sort(by: \.libraryAddedDate, ascending: false)
        case .name:
            request.sort(by: \.name, ascending: true)
        default:
            request.sort(by: \.name, ascending: true)
        }
        return request
    }
}



struct TransparentBlurView: UIViewRepresentable {
    var removeAllFilters : Bool = false
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removeAllFilters {
                    backdropLayer.filters = []
                } else {
                    backdropLayer.filters?.removeAll(where: { filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialLight))
        
        return view
    }
}
