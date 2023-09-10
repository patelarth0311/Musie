import Foundation
import SwiftUI
import MusicKit

struct AlbumStatView : View {
    var number: Double
    var title: String
    var  albums: MusicItemCollection<MusicKit.Album>
    @State var album: Album
    @State var selected : Album
    @Binding var libraryData: LibraryData
    @Namespace var namespace
    @Binding var modal: Modal
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
           
    
                
                
                HStack(alignment: .bottom) {
                    
                    
                    
                    
                    if let artwork = selected.artwork {
                        
                        if (album == selected) {
                      
                            VStack(alignment: .leading) {
                                ArtworkImage(artwork, width: (Double(Int(UIScreen.main.bounds.width - 115))))
                                
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.25), radius: 20)
                                    .onTapGesture {
                                  
                                            withAnimation( .smooth){
                                                
                                               
                                                
                                                modal.songModal = SongModalData()
                                                modal.artistModal = ArtistModalData()
                                                modal.albumModal = AlbumModalData(album: album)
                                               
                                                
                                                
                                                
                                                
                                            }
                                        
                                               }
                                    .overlay (alignment: .bottomTrailing) {
                                        
                                        Text("")
                                            .font(.system(size: 50 , weight: .bold))
                                            .minimumScaleFactor(0.05)
                                            .lineLimit(1)
                                            .offset(x: -10)
                                        
                                    }
                                Spacer()
                                
                              
                                
                                
                                
                            }
                            .zIndex(10)
                            .matchedGeometryEffect(id: selected.id.rawValue + title, in: namespace)
                            
                            
                        }
                        
                    }
                    
                    
                    VStack(spacing: 5) {
                        ForEach(albums.prefix(5)) { album  in
                            
                            if let artwork = album.artwork {
                                
                                if (selected != album) {
                                    Button {
                                        withAnimation(.smooth) {
                                            self.album = album
                                            self.selected = album
                                            
                                             
                                             modal.songModal = SongModalData()
                                             modal.artistModal = ArtistModalData()
                                             modal.albumModal = AlbumModalData(album: album)
                                            
                                             
                                             
                                        }
                                    } label : {
                                        ArtworkImage(artwork, width: (Double(Int(UIScreen.main.bounds.width - 130)) / 4))
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                        
                                        
                                            .shadow(color: .black.opacity(0.3), radius: 7)
                                           
                                        
                                        
                                        
                                            .overlay(alignment: .bottomTrailing) {
                                                
                                                
                                                
                                                Text("")
                                                    .font(.system(size: 20 , weight: .bold))
                                                    .minimumScaleFactor(0.05)
                                                    .lineLimit(1)
                                                    .offset(x: -10)
                                            }
                                        
                                        
                                    }
                                    
                                
                                
                                
                            }
                        }
                      
                    }
                    
                        Spacer()
                }
            }
            
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(selected.title)
                        .font(.system(size: 35 , weight: .bold))
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                    
                    Text(selected.artistName)
                        .font(.system(size: 25 , weight: .regular))
                        .minimumScaleFactor(0.05)
                        .lineLimit(1)
                }
                
            }
        }
        .onChange(of: libraryData.albums, { oldValue, newValue in
            self.album = albums[0]
            self.selected = albums[0]
        })
   
    }
}
