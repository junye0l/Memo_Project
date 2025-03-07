//
//  ViewController.swift
//  memo_project
//
//  Created by 김준열 on 3/7/25.//
import UIKit

class MemoListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let memoManager = MemoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        memoManager.loadMemos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "메모"
        view.backgroundColor = .systemBackground
        
        // 네비게이션 바 설정
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        // 테이블뷰 설정
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "memoCell")
    }
    
    @objc private func addButtonTapped() {
        let memoDetailVC = MemoDetailViewController(mode: .create, memo: nil)
        navigationController?.pushViewController(memoDetailVC, animated: true)
    }
}

// UITableView 확장
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoManager.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
        let memo = memoManager.memos[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = memo.title
        
        // 날짜 포맷팅
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let dateString = dateFormatter.string(from: memo.updatedAt)
        content.secondaryText = "\(memo.content.prefix(30))... \(dateString)"
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let memo = memoManager.memos[indexPath.row]
        let memoDetailVC = MemoDetailViewController(mode: .edit, memo: memo)
        navigationController?.pushViewController(memoDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let memo = memoManager.memos[indexPath.row]
            memoManager.deleteMemo(id: memo.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
