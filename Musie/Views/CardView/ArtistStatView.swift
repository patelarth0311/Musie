    //
    //  ArtistStatView.swift
    //  Musie
    //
    //  Created by Arth Patel on 8/26/23.
    //

    import Foundation
    import MusicKit
    import SwiftUI

    struct ArtistStatView : View {
        var number: Double
        var title: String
        var  artists: MusicItemCollection<MusicKit.Artist>
        @State var artist: Artist
        @State var selected : Artist
        @Binding var libraryData: LibraryData
        @Namespace var namespace
        @Binding var modal: Modal
        var body: some View {
            VStack(alignment: .leading, spacing: 3) {
                
                    HStack(alignment: .bottom) {
                        
                        
                        
                        
                        if let artwork = selected.artwork {
                            
                            if (artist == selected) {
                          
                                VStack(alignment: .leading) {
                                    ArtworkImage(artwork, width: (Double(Int(UIScreen.main.bounds.width - 115))))
                                    
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.25), radius: 20)
                                        .onTapGesture {
                                          
                                                withAnimation( .smooth){
                                                   
                                                   
                                                    modal.songModal = SongModalData()
                                                    modal.albumModal = AlbumModalData()
                                                    modal.artistModal = ArtistModalData(artist: artist)
                                                  
                                                 
                                                   
                                                    
                                                    
                                                    
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
                                
                               
                                
                                
                            }
                            
                        }
                        
                        
                        VStack(spacing: 5) {
                            ForEach(artists.prefix(5)) { artist  in
                                
                                if let artwork = artist.artwork {
                                    
                                    if (selected != artist) {
                                        Button {
                                            withAnimation(.smooth) {
                                                self.artist = artist
                                                self.selected = artist
                                                modal.songModal = SongModalData()
                                                modal.albumModal = AlbumModalData()
                                                modal.artistModal = ArtistModalData(artist: artist)
                                            }
                                        } label : {
                                            ArtworkImage(artwork, width: (Double(Int(UIScreen.main.bounds.width - 130)) / 4))
                                                .clipShape(Circle())
                                                
                                            
                                                .shadow(color: .black.opacity(0.3), radius: 7)
                                    
                                            
                                            
                                            
                                                .overlay(alignment: .bottomTrailing) {
                                                    
                                                    
                                                    
                                                    Text("")
                                                        .font(.system(size: 20 , weight: .bold))
                                                        .minimumScaleFactor(0.05)
                                                        .lineLimit(1)
                                                        .offset(x: -10)
                                                }
                                            
                                            
                                        }
                                        .matchedGeometryEffect(id: artist.id.rawValue + title, in: namespace)
                                        
                                    
                                    
                                }
                            }
                          
                        }
                        
                            Spacer()
                    }
                   
            }
                   
                
                
           
                   
                   HStack(alignment: .bottom) {
                       VStack(alignment: .leading) {
                           Text(selected.name)
                               .font(.system(size: 35 , weight: .bold))
                               .minimumScaleFactor(0.05)
                               .lineLimit(1)
                           
                       }
                       
                   }
            }
            .onChange(of: libraryData.artists, { oldValue, newValue in
                self.artist = artists[0]
                self.selected = artists[0]
            })
       
        }
    }

