//
//  SecondViewController.swift
//  memo_project
//
//  Created by 김준열 on 3/7/25.
//
import UIKit

enum MemoMode {
    case create
    case edit
}

class MemoDetailViewController: UIViewController {
    
    private let titleTextField = UITextField()
    private let contentTextView = UITextView()
    private let memoManager = MemoManager.shared
    private let mode: MemoMode
    private var memo: Memo?
    
    init(mode: MemoMode, memo: Memo?) {
        self.mode = mode
        self.memo = memo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 네비게이션 바 설정
        title = mode == .create ? "새 메모" : "메모 편집"
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        // 제목 필드 설정
        titleTextField.placeholder = "제목"
        titleTextField.font = UIFont.preferredFont(forTextStyle: .headline)
        titleTextField.borderStyle = .roundedRect
        titleTextField.layer.cornerRadius = 5
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        // 내용 텍스트뷰 설정
        contentTextView.font = UIFont.preferredFont(forTextStyle: .body)
        contentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 5
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentTextView)
        
        // 레이아웃 설정
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureData() {
        if mode == .edit, let memo = memo {
            titleTextField.text = memo.title
            contentTextView.text = memo.content
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextView.text, !content.isEmpty else {
            showAlert(message: "제목과 내용을 모두 입력해주세요.")
            return
        }
        
        switch mode {
        case .create:
            memoManager.addMemo(title: title, content: content)
        case .edit:
            if let memo = memo {
                memoManager.updateMemo(id: memo.id, title: title, content: content)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
