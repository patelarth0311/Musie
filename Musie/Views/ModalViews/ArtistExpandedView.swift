//
//  ArtistExpandedView.swift
//  Musie
//
//  Created by Arth Patel on 8/22/23.
//

import SwiftUI
import MusicKit
struct ArtistExpandedView: View {


@Binding var modal: Modal
var geometry: GeometryProxy

@Binding var libraryData: LibraryData
@State private var playedCount: Double = 0
@State private var minutesListened: Double = 0
@State private var recentlyListened: Date = Date()
@State private var albums : MusicItemCollection<Album> = MusicItemCollection<Album>()
@State var sortToggled = false
@Environment(\.dismiss) private var dismiss


@State var optionChoose : SortOption = .playCount
var body: some View {
    
    
    if let artist = modal.artistModal.artist {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    Spacer()
                    
                    if let artwork = artist.artwork{
                        
                        ArtworkImage(artwork, width: geometry.size.width - 40)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.25), radius: 20)
                        
                          
                        
                        
                        
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2)  {
                            
                            ScrollView(.horizontal) {
                                Text(artist.name)
                                    .font(.system(.title, weight: .bold))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(1)
                            }
                            .frame(width: geometry.size.width - 40, alignment: .leading)
                            .scrollIndicators(.hidden)
                            
                            
                        }
                        Spacer()
                        
                    }
                    HStack {
                        
                    }
                    
                    
                    .font(.system(.subheadline,weight: .semibold))
                    
                    
                    
                    
                    DateView(recentlyListenDate: recentlyListened, addedDate: artist.libraryAddedDate, geometry: geometry)
                    
                  
                    
                    Spacer()
                        .frame(height: 0)
                    
                    VStack(spacing: 10) {
                        
                        InsightView(title: "Play Count", geometry: geometry, number: playedCount)
                        
                        InsightView(title: "Minutes Listened", geometry: geometry, number: minutesListened)
                        
                        
                    }
                    Spacer()
                    
                    VStack(alignment: .center) {
                       
                            ForEach(modal.artistModal.albums) { album in
                                
                                
                                AlbumSpecView(album: album, modal: $modal,  specBG: .material)
                                
                            }
                            .scrollItemStyle()
                        
                        
                        HStack {
                            
                            
                            Text("\(modal.artistModal.albums.count) album\(modal.artistModal.albums.count > 0 ? "s" : "")")
                            
                            
                        }
                        
                        
                        .font(.system(.subheadline,weight: .semibold))
                        
                        
                    }
                    .padding(.bottom,20)
                    
                    
                    
                }
                .padding([.leading,.trailing])
                .padding(.top, 95)
                
            }
            .blurredNavBar(height: 130)
            .scrollIndicators(.hidden)
            
         
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation( .smooth){
                            modal.artistModal = ArtistModalData()
                        }
                           
                            
                        
                        
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward")
                            .font(.system(size: 20,weight: .medium))
                            .getContrastText(backgroundColor: Color(artist.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        SortOptionButton(contentType: .albums,  optionChoose: $optionChoose)
                            .onChange(of: optionChoose) { oldValue, newValue in
                                
                                withAnimation {
                                    sortToggled.toggle()
                                }
                                modal.artistModal.sort(sortOption: optionChoose)
                                
                            }
                    } label: {
                        
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20,weight: .medium))
                            .symbolEffect(.bounce.byLayer, value: sortToggled)
                            .getContrastText(backgroundColor: Color(artist.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
                    }
                    
                }
            }
            .background(Color(artist.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ).brightness(0.04))
            .getContrastText(backgroundColor: Color(artist.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
            
            
           
            .frame(minWidth: geometry.size.width,maxWidth: .infinity,maxHeight: .infinity)
          
          
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .onChange(of: modal.artistModal.loaded, { _, _ in
                
              
                    withAnimation(.easeIn) {
                        playedCount = modal.artistModal.getPlayCount()
                        
                        minutesListened = modal.artistModal.getMinutesPlayed()
                       
                    }
                   
               
            })
          
            .task(priority: .high, {
                 
                   withAnimation(.easeIn) {
                       playedCount = modal.artistModal.getPlayCount()
                       
                       minutesListened = modal.artistModal.getMinutesPlayed()
                       
                   }
            })
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .ignoresSafeArea(.all)
        
      
       
    }
        
}

}
