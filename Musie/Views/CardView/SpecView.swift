//
//  SpecView.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import MusicKit

enum SpecBG {
case avgColor
case material
}

struct SongSpecView: View {

var song: MusicKit.Song
@Binding var modal: Modal

var specBG : SpecBG



var body: some View {
 
   
        HStack {
            if let artwork = song.artwork {
                
                ArtworkImage(artwork, width: 55)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                   
                   
                    .shadow(color: .black.opacity(0.3), radius: 7)
                    .padding( 5)
                
                
            }
            
            VStack(alignment: .leading)  {
                Text(song.title)
                    .font(.system(size:  15,weight: .bold))
                Text(song.artistName)
                    .font(.system(size:  15,weight: .medium))
            }
            .lineLimit(1)
            .truncationMode(.tail)
            
            
            Spacer()
            Text("\(song.playCount ?? 0)")
                .font(.system(size: 20,weight: .bold))
                .padding()
        }
        .musicItemCardStyle(specBG: specBG, color: Color(song.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
  
           
            
            .onTapGesture {
                           
          
                    
            withAnimation( .smooth){
                       
                        modal.artistModal =     ArtistModalData()
                        modal.albumModal =   AlbumModalData()
                        modal.songModal = SongModalData(song: song)
                     
               
                        
                    }
                
                       }
         
            
            
          
    }

    


        
        
    

}

struct ArtistSpecView: View {
    
var artist: MusicKit.Artist
@Binding var modal: Modal

var specBG : SpecBG



var body: some View {

    HStack {
        if let artwork = artist.artwork {
            ArtworkImage(artwork, width: 55)
                .clipShape(Circle())
                
                
               
                .shadow(color: .black.opacity(0.3), radius: 8)
                .padding(5)
        }
        VStack(alignment: .leading)  {
            Text(artist.name)
            .font(.system(size: 15,weight: .bold))
          
        }
        .lineLimit(1)
        .truncationMode(.tail)
        Spacer()
        
    }
    .musicItemCardStyle(specBG: specBG, color: Color(artist.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))

  
    .onTapGesture {
      
            withAnimation( .smooth){
               
               
                modal.songModal = SongModalData()
                modal.albumModal = AlbumModalData()
                modal.artistModal = ArtistModalData(artist: artist)
              
             
               
                
                
                
            }
        
               }

    }


}

struct AlbumSpecView: View {
var album: MusicKit.Album
@Binding var modal: Modal
var specBG : SpecBG


var body: some View {
    
  
        
        HStack {
            if let artwork = album.artwork {
                ArtworkImage(artwork, width: 55)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                  
                    
                    .shadow(color: .black.opacity(0.3), radius: 7)
                    .padding(5)
            }
            VStack(alignment: .leading)  {
                Text(album.title)
                .font(.system(size: 15,weight: .bold))
                Text(album.artistName)
                    .font(.system(size: 15,weight: .medium))
              
            }     .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            Text("\(album.trackCount)")
            .font(.system(size: 20,weight: .bold))
            .padding()
        }
       
        .musicItemCardStyle(specBG: specBG, color: Color(album.artwork?.backgroundColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 1.0) ))
    
        .onTapGesture {
      
            
                withAnimation( .smooth){
                    
                   
                    
                    modal.songModal = SongModalData()
                    modal.artistModal = ArtistModalData()
                    modal.albumModal = AlbumModalData(album: album)
                   
                    
                    
                    
                    
                }
            
                   }
    }


    

}

