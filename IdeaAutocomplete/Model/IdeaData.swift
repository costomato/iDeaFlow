//
//  NoteModel.swift
//  IdeaAutocomplete
//
//  Created by Kaustubh on 04/08/23.
//

import SwiftUI

struct IdeaLink: Codable, Hashable, Identifiable {
    var id = UUID()
    var link: String
    var isExceeded = false
}

struct IdeaNote: Codable, Hashable, Identifiable {
    var id = UUID()
    var body: String
    var links: [IdeaLink]
}

@MainActor class IdeaData: ObservableObject {
    let NOTES_KEY = "notes_key"
    var ideaNotes: [IdeaNote] {
        didSet {
            objectWillChange.send()
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: NOTES_KEY) {
            if let decodedIdeas = try? JSONDecoder().decode([IdeaNote].self, from: data){
                ideaNotes = decodedIdeas
                return
            }
        }
        ideaNotes = []
    }
    
    func getIdeasExcept(id: UUID) -> [IdeaLink] {
        return ideaNotes
            .filter { $0.id != id }
            .compactMap { IdeaLink(link: $0.body) }
    }
    
    func getAllIdeas() -> [IdeaLink] {
        return ideaNotes.compactMap { IdeaLink(link: $0.body) }
    }
    
    func addIdea(body: String, links: [IdeaLink] = []) {
        ideaNotes.insert(IdeaNote(body: body, links: links), at: 0)
        print("Note added")
        saveIdea()
    }
    
    func editIdea(id: UUID, body: String, links: [IdeaLink]) {
        if let index = ideaNotes.firstIndex(where: {$0.id == id}) {
            ideaNotes[index].body = body
            ideaNotes[index].links = links
            print("Note edited")
            saveIdea()
        }
        print("Outside note edited")
    }
    
    func saveIdea() {
        if let encodedIdeas = try? JSONEncoder().encode(ideaNotes) {
            UserDefaults.standard.set(encodedIdeas, forKey: NOTES_KEY)
        }
    }
    
    func resetUserData() {
        UserDefaults.standard.removeObject(forKey: NOTES_KEY)
        UserDefaults.resetStandardUserDefaults()
        
        ideaNotes = []
    }
}
