//
//  Modal.swift
//  Musie
//
//  Created by Arth Patel on 8/14/23.
//

import Foundation
import SwiftUI
import MusicKit

@Observable class Modal {


var songModal  : SongModalData = SongModalData()
var artistModal  : ArtistModalData  = ArtistModalData()
var albumModal  : AlbumModalData  = AlbumModalData()


}

protocol ModalData {

func filterContent()  -> Void
func getPlayCount()  -> Double
func getMinutesPlayed()  -> Double

}

extension String: MusicLibraryRequestFilterValueMembershipComparable {
    
}

@Observable class SongModalData : ModalData {


var song : Song? = nil
var artists : MusicItemCollection<MusicKit.Artist> = MusicItemCollection<MusicKit.Artist>()
var artistsArray : [MusicKit.Artist] = []
var playCount : Double = 0.0
var minutesListened : Double = 0.0
var loaded = false


init(song: Song? = nil) {
    self.song = song
    self.filterContent()
   
}

func filterContent() {
    Task {
        do {
            if let song = self.song {
                
                
               
                var artists = song.artistName.split(whereSeparator: { character in
                    let stringCharacter = String(character)
                    return NSPredicate(format: "SELF MATCHES %@", "[&/,]").evaluate(with: stringCharacter)
                }).map(String.init)
                if (!artists.contains(song.artistName)) {
                    artists.append(song.artistName)
                }
              
            
                 try await withThrowingTaskGroup(of: MusicItemCollection<Artist>.self) { taskgroup in
                    for item in artists {
                      
                    
                        taskgroup.addTask {
                            
                            
                            var artist = item.description.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            var filterRequest = MusicLibraryRequest<MusicKit.Artist>()
                            filterRequest.filter(matching: \.name, equalTo: artist)
                            
                            
                            return try await filterRequest.response().items
                            
                           
                        }
                       
                    }
                    for try await result in taskgroup {
                        self.artistsArray.append(contentsOf: result)
                        }
                  
                }
                
                if (self.artistsArray.isEmpty) {
                    var filterRequest = MusicLibraryRequest<MusicKit.Artist>()
                    filterRequest.filter(matching: \.name, contains: song.artistName)
                    let results = try await filterRequest.response().items
                    self.artistsArray.append(contentsOf: results)
                }
                
                
              
                self.playCount = Double(song.playCount ?? 0)
                self.minutesListened = (Double(song.duration ?? 0.0)/60.0) * Double(song.playCount ?? 0)
                self.loaded = true
            }
        } catch {
            print(error)
        }
    }
}


func getPlayCount() -> Double {
    return self.playCount
}

func getMinutesPlayed() -> Double {
    return self.minutesListened
}
}


@Observable class ArtistModalData : ModalData {

var artist : Artist? = nil
var albums : MusicItemCollection<MusicKit.Album> = MusicItemCollection<MusicKit.Album>()
var songs : MusicItemCollection<MusicKit.Song> = MusicItemCollection<MusicKit.Song>()
var playCount : Double = 0.0
var minutesListened : Double = 0.0
var loaded = false
    
init(artist: Artist? = nil)  {
    self.artist = artist
    self.filterContent()
}
    
    func sort(sortOption: SortOption) {
        Task {
            do {
                if let artist = self.artist {
                    var filterRequest = MusicLibraryRequest<MusicKit.Album>()
                    filterRequest.filter(matching: \.artistName, equalTo: artist.name)
                    self.albums = try await filterRequest.sort(by: sortOption).response().items
                  
                }
           
            } catch {
                print(error)
            }
           
                
            
        }

    }

    
func filterContent() {
    Task {
        do {
           
            if let artist = self.artist {
                var filterRequest = MusicLibraryRequest<MusicKit.Album>()
                filterRequest.filter(matching: \.artistName, equalTo: artist.name)
                let response = try await filterRequest.response()
                self.albums = response.items
                
                var songFilterRequest = MusicLibraryRequest<MusicKit.Song>()
                songFilterRequest.filter(matching: \.artistName, equalTo: artist.name)
                songFilterRequest.sort(by: \.playCount, ascending: false)
                let songsResponse = try await  songFilterRequest.response()
                self.songs = songsResponse.items
                self.getPlaysandMinutes()
                self.loaded = true
               
              
                
            }
        } catch {
            print(error)
        }
    }
}

func getPlaysandMinutes() {
    self.songs.forEach { song in
       
        self.playCount = self.playCount + Double(song.playCount ?? 0)
       
        if let interval = song.duration {
            self.minutesListened = self.minutesListened +  Double(song.playCount ?? 0) * (interval/60.0)
        }
    }
    
    
}



func getPlayCount() -> Double {
    
    return self.playCount
}




func getMinutesPlayed() -> Double {
    
    return self.minutesListened
}
}

@Observable class AlbumModalData : ModalData {

var album : Album? = nil
var songs : MusicItemCollection<MusicKit.Song> = MusicItemCollection<MusicKit.Song>()
var artists : MusicItemCollection<MusicKit.Artist> = MusicItemCollection<MusicKit.Artist>()
var playCount : Double = 0.0
var minutesListened : Double = 0.0
var loaded = false
init(album: Album? = nil) {
    self.album = album
    self.filterContent()
    
}

    
    func sort(sortOption: SortOption) {
        Task {
            do {
                if let album = self.album {
                    var filterRequest = MusicLibraryRequest<MusicKit.Song>()
                   
                    filterRequest.filter(matching: \.albumTitle, contains: album.title)
                    self.songs = try await filterRequest.sort(by: sortOption).response().items
                }
           
            } catch {
                print(error)
            }
           
                
            
        }

    }


    
    
func filterContent() {
    
    Task {
        do {
            if let album = self.album {
                var filterRequest = MusicLibraryRequest<MusicKit.Song>()
                filterRequest.filter(matching: \.albumTitle, equalTo: album.title)
                filterRequest.sort(by: \.playCount, ascending: false)
                let response = try await filterRequest.response()
                self.songs = response.items
              
              
                
                
                if (album.title.contains("Deluxe")) {
                    var filterRequest = MusicLibraryRequest<MusicKit.Song>()
                    filterRequest.filter(matching: \.albumTitle, contains: album.title)
                    filterRequest.sort(by: \.playCount, ascending: false)
                    let response = try await filterRequest.response()
                    self.songs = response.items
                    
                }
               
                
                var filterArtistRequest = MusicLibraryRequest<MusicKit.Artist>()
                filterArtistRequest.filter(matching: \.name, equalTo: album.artistName)
                let artistResponse = try await filterArtistRequest.response()
                self.artists = artistResponse.items
                self.getPlaysandMinutes()
                self.loaded = true
              
            }
        } catch {
            print(error)
        }
    }
}

func getPlaysandMinutes()  {
    self.songs.forEach { song in
       
        self.playCount = self.playCount + Double(song.playCount ?? 0)
       
        if let interval = song.duration {
            self.minutesListened = self.minutesListened +  Double(song.playCount ?? 0) * (interval/60.0)
        }
    }
    self.loaded = true
}



func getPlayCount() -> Double {

    
    return self.playCount
}

func getMinutesPlayed() -> Double {
    return self.minutesListened
}
}


