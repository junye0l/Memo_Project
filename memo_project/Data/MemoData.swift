//
//  MemoData.swift
//  memo_project
//
//  Created by 김준열 on 3/7/25.
//

import Foundation

struct Memo: Codable {
    let id: UUID
    var title: String
    var content: String
    let createdAt: Date
    var updatedAt: Date
    
    init(id: UUID, title: String, content: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
