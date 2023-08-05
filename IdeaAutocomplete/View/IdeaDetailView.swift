//
//  IdeaDetailView.swift
//  IdeaAutocomplete
//
//  Created by Kaustubh on 04/08/23.
//

import SwiftUI


struct IdeaDetailView: View {
    @EnvironmentObject var ideaData: IdeaData
    @State var note: IdeaNote
    @State var ideaLinks: [[IdeaLink]]
    let isCreate: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @State private var ideaText = ""
    
    var allIdeas: [IdeaLink]
    
    init(note: IdeaNote, allIdeas: [IdeaLink], isCreate: Bool) {
        self._note = State(initialValue: note)
        self._ideaLinks = State(initialValue: [note.links])
        self.allIdeas = allIdeas
        self.isCreate = isCreate
    }
    
    var filteredLinks: [IdeaLink] {
        if ideaText.isEmpty {
            return allIdeas.filter { ideaLink in
                !note.links.contains { $0.link.lowercased() == ideaLink.link.lowercased() }
            }
        } else {
            return allIdeas.filter { ideaLink in
                !note.links.contains { $0.link.lowercased() == ideaLink.link.lowercased() }
                    && ideaLink.link.lowercased().contains(ideaText.lowercased())
            }
        }
    }

    
    var body: some View {
        VStack {
            Text("Edit your idea")
                .fontWeight(.bold)
                .padding()
            TextField("Idea", text: $note.body)
                .textSelection(.enabled)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(ideaLinks.indices, id:\.self) { index in
                            
                            HStack {
                                ForEach(ideaLinks[index].indices, id:\.self) { chipIndex in
                                    ChipView(text: ideaLinks[index][chipIndex].link)
                                        .overlay(GeometryReader{reader -> Color in
                                            let maxX = reader.frame(in: .global).maxX
                                            if maxX > UIScreen.main.bounds.width - 70 && !ideaLinks[index][chipIndex].isExceeded {
                                                DispatchQueue.main.async{
                                                    ideaLinks[index][chipIndex].isExceeded = true
                                                    
                                                    let lastItem = ideaLinks[index][chipIndex]
                                                    ideaLinks.append([lastItem])
                                                    ideaLinks[index].remove(at: chipIndex)
                                                }
                                            }
                                            return Color.clear
                                        },
                                                 alignment:.trailing
                                        )
                                        .clipShape(Capsule())
                                        .onTapGesture {
                                            var linearIndex = 0
                                            for i in 0..<ideaLinks.count {
                                                for _ in 0..<ideaLinks[i].count {
                                                    if note.links[linearIndex].link == ideaLinks[index][chipIndex].link {
                                                        note.links.remove(at: linearIndex)
                                                        break
                                                    }
                                                    linearIndex += 1
                                                }
                                            }
                                            
                                            ideaLinks[index].remove(at: chipIndex)
                                            
                                            if ideaLinks[index].isEmpty {
                                                ideaLinks.remove(at: index)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background( RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(note.links.count) ideas linked")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height / 3)
            
            
            VStack {
                TextField("Link existing ideas", text: $ideaText)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
                
                
                if !ideaText.isEmpty {
                    LazyVStack {
                        ScrollView {
                            ForEach(filteredLinks, id: \.id) { link in
                                HStack {
                                    Text(link.link)
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 12)
                                    
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if ideaLinks.isEmpty {
                                        ideaLinks.append([])
                                    }
                                    note.links.append(IdeaLink(link: link.link))
                                    ideaLinks[ideaLinks.count-1].append(IdeaLink(link: link.link))
                                    ideaText = ""
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color("bg")).shadow(radius: 5))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    print("Confirming changes...")
                    if note.body != "" && !allIdeas.contains(where: {$0.link == note.body}) {
                        if isCreate {
                            ideaData.addIdea(body: note.body, links: note.links)
                        } else {
                            ideaData.editIdea(id: note.id, body: note.body, links: note.links)
                        }
                        ideaLinks = [[]]
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Confirm changes")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(.pink.opacity(note.body == "" || allIdeas.contains {$0.link == note.body} ? 0.4 : 0.7))
                        .cornerRadius(10)
                })
            }
        }
        .padding(.bottom, 40)
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct IdeaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        IdeaDetailView(note: IdeaNote(id: UUID(), body: "Sample idea 1", links: [IdeaLink(id: UUID(), link: "Some good idea"), IdeaLink(id: UUID(),link:"Idea 2"), IdeaLink(id: UUID(),link:"My amazing idea"), IdeaLink(id: UUID(),link:"Idea 4")]), allIdeas: [IdeaLink(id: UUID(),link:"Idea 2"), IdeaLink(id: UUID(),link:"My amazing idea"), IdeaLink(id: UUID(),link:"Idea 4"), IdeaLink(id: UUID(),link:"Idea 5")], isCreate: true)
            .environmentObject(IdeaData())
    }
}
