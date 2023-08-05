//
//  ContentView.swift
//  IdeaAutocomplete
//
//  Created by Kaustubh on 04/08/23.
//

import SwiftUI

struct ContentView: View {
    @State var showEditIdea:Bool = false
    @StateObject var ideaData = IdeaData()
    var body: some View {
        NavigationView {
            ZStack {
                if ideaData.ideaNotes.isEmpty {
                    Text("Go ahead, let an idea flow!")
                        .italic()
                        .foregroundColor(.gray)
                } else {
                    HomeView()
                        .padding(.top, 20)
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showEditIdea.toggle()
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                        .padding(16)
                        .background(.red)
                        .mask(Circle())
                        .zIndex(1)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 26))
            }
            .navigationTitle("iDeaFlow")
            .sheet(isPresented: $showEditIdea) {
                IdeaDetailView(note: IdeaNote(id: UUID(), body: "", links: []), allIdeas: ideaData.getAllIdeas(), isCreate: true)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation{
                            ideaData.resetUserData()
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.pink)
                }
            }
        }
        .environmentObject(ideaData)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
