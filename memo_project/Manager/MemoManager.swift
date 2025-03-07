//
//  MemoManager.swift
//  memo_project
//
//  Created by 김준열 on 3/7/25.
//
import Foundation

class MemoManager {
    static let shared = MemoManager()

    private let userDefaults = UserDefaults.standard
    private let memoKey = "memos"

    private init() {}

    var memos: [Memo] = [] {
        didSet {
            saveMemos()
        }
    }

    func loadMemos() {
        if let data = userDefaults.data(forKey: memoKey) {
            let decoder = JSONDecoder()
            if let savedMemos = try? decoder.decode([Memo].self, from: data) {
                memos = savedMemos
            }
        }
    }

    private func saveMemos() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(memos) {
            userDefaults.set(encoded, forKey: memoKey)
        }
    }

    func addMemo(title: String, content: String) {
        let newMemo = Memo(
            id: UUID(), title: title, content: content, createdAt: Date(),
            updatedAt: Date())
        memos.insert(newMemo, at: 0)
    }

    func updateMemo(id: UUID, title: String, content: String) {
        if let index = memos.firstIndex(where: { $0.id == id }) {
            var updatedMemo = memos[index]
            updatedMemo.title = title
            updatedMemo.content = content
            updatedMemo.updatedAt = Date()
            memos[index] = updatedMemo
        }
    }

    func deleteMemo(id: UUID) {
        memos.removeAll { $0.id == id }
    }
}
