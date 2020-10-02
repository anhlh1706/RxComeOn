//
//  ViewController.swift
//  RxComeOn
//
//  Created by Lê Hoàng Anh on 02/10/2020.
//

import UIKit
import RxSwift
import RxCocoa
import Anchorage
import AVFoundation

enum SomeError: Error {
    case some
}

final class ViewController: UIViewController {
    
    let label = UIButton()
    
    let dis = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doStuff(dis: dis)
        setupView()
    }
    
    private func setupView() {
        title = "First"
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        label.setTitle("Tap", for: .normal)
        label.setTitleColor(.darkText, for: .normal)
        label.edgeAnchors == view.edgeAnchors
        label.addTarget(self, action: #selector(push), for: .touchUpInside)
    }

    @objc
    func push() {
        let vc = ViewController2()
        navigationController?.pushViewController(vc, animated: true)
    }
}

final class ViewController2: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let dis = DisposeBag()
    
    var value = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doStuff(dis: dis)
        title = "Second"
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        Observable<String>.create { observer -> Disposable in
            observer.onNext("1")
            
            observer.onNext("2")
            
            observer.onNext("3")
            
            observer.onNext("4")
            
            //observer.onError(MyError.anError)
            
            observer.onNext("5")
            
            //observer.onCompleted()
            
            observer.onNext("6")
            
            return Disposables.create()
        }
        .subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        )
        .disposed(by: dis)
    }

}
