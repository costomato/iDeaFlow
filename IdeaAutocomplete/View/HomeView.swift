//
//  HomeView.swift
//  IdeaAutocomplete
//
//  Created by Kaustubh on 04/08/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var ideaData: IdeaData
    
    var body: some View {
        List {
            ForEach(ideaData.ideaNotes) { note in
                
                NavigationLink(destination: IdeaDetailView(note: note, allIdeas: ideaData.getIdeasExcept(id: note.id), isCreate: false)) {
                    
                    HStack{
                        Image("lightbulb.max")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 35, alignment: .center)
                            .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 6))
                        
                        VStack(alignment: .leading) {
                            Text(note.body + " <>")
                                .lineLimit(2)
                            Text(note.links.map { $0.link }.joined(separator: ", "))
                                .lineLimit(5)
                            
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(IdeaData())
    }
}
