    //
    //  DetailedStatView.swift
    //  Musie
    //
    //  Created by Arth Patel on 8/10/23.
    //

    import SwiftUI
    import MusicKit

struct DetailedStatView: View {

        @State var expand = false
        @Binding var  libraryData : LibraryData
        @Binding var modal : Modal
        var contentType: ContentType
        @State var optionChoose : SortOption = .title
        @State var sortToggled : Bool = false

          
        @State var  query : String = ""
        
        
        @State var songs = MusicItemCollection<MusicKit.Song>()
        @State var albums = MusicItemCollection<MusicKit.Album>()
        @State var artists = MusicItemCollection<MusicKit.Artist>()

       
        
        var body: some View {
        
               
                  
                        List {
                            
                            
                            switch contentType {
                            case .songs:
                             
                                ForEach(songs) { song in
                                        SongSpecView(song: song, modal: $modal, specBG: .avgColor)
                                       
                                }
                                
                                
                            case .artists:
                                ForEach(artists) { artist in
                                        ArtistSpecView(artist: artist, modal: $modal, specBG: .avgColor)
                                            
                                        
                                }
                                
                                
                                
                            case .albums:
                                ForEach(albums) { album in
                                        AlbumSpecView(album: album, modal: $modal, specBG: .avgColor)
                                            
                                }
                            }
                        }
                       
                     
                        .scrollContentBackground(.hidden)
                        .listStyle(PlainListStyle())
                        
                        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
                        
                    
                   
                    .navigationTitle("\(contentType.rawValue)")
                       
                    .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
                    .onChange(of: query) { oldValue, newValue in
                      
                        Task {
                            
                            do {
                                switch contentType {
                                case .songs:
                                   
                                    var result = try await search(query: query, contentType: .songs, request: MusicKit.Song.self )
                                    
                                    guard let res = result else {
                                        return
                                    }
                                    
                                    self.songs = res.items
                                    
                                case .artists:
                                    var result = try await search(query: query, contentType: .songs, request: MusicKit.Artist.self )
                                    
                                    guard let res = result else {
                                        return
                                    }
                                    
                                    self.artists = res.items
                                 
                                case .albums:
                                    var result = try await search(query: query, contentType: .songs, request: MusicKit.Album.self )
                                    
                                    guard let res = result else {
                                        return
                                    }
                                    
                                    self.albums = res.items
                                }
                            } catch {
                                print(error)
                            }
                           
                           
                        }
                      
                    }
                    
                    .task(priority: .high, {
                        switch contentType {
                        case .songs:
                            self.songs = libraryData.songs
                        case .artists:
                            self.artists = libraryData.artists
                        case .albums:
                            self.albums = libraryData.albums
                        }
                    })
                    
                    
                   
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            VStack {
                                
                                Menu {
                                    SortOptionButton(contentType: contentType,  optionChoose: $optionChoose)
                                        
                                        .onChange(of: optionChoose) { oldValue, newValue in
                                        
                                            Task {
                                                switch contentType {
                                                case .songs:
                                                    sortSongs(sortOption: optionChoose) { data in
                                                        self.songs = data
                                                    }
                                                case .artists:
                                                    sortArtists(sortOption: optionChoose) { data in
                                                        self.artists = data
                                                    }
                                                case .albums:
                                                    sortAlbums(sortOption: optionChoose) { data in
                                                        self.albums = data
                                                    }
                                                }
                                               
                                            }
                                            
                                            withAnimation {
                                                sortToggled.toggle()
                                             
                                            }
                                            
                                        
                                           
                                        }
                                } label: {
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                        .symbolEffect(.bounce.byLayer, value: sortToggled)
                                }
                               
                                .onTapGesture {
                                    withAnimation {
                                        sortToggled.toggle()
                                    }
                                }
                                
                            }
                        }
                    }
                
                .tint(.white)
                
            
        }
    }



func search<T : MusicLibraryRequestable>(query: String, contentType: ContentType, request: T.Type) async throws ->  MusicLibraryResponse<T>? {
        do {
           
            var request = MusicLibraryRequest<T>()
            request.filter(text: query)
            let results = try await request.response()
            return results
        } catch {
            print(error)
        }
        return nil
    }


