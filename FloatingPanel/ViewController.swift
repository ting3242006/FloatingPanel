//
//  ViewController.swift
//  FloatingPanel
//
//  Created by Ting on 2023/10/29.
//

import UIKit
import FloatingPanel

class ViewController: UIViewController, FloatingPanelControllerDelegate {
    
    private lazy var fpc: FloatingPanelController = {
        let controller = FloatingPanelController(delegate: self)
        let contentVC = TableViewController()
        contentVC.didSelect = { [weak self](item: String) in
            self?.label.text = item
        }
        controller.set(contentViewController: contentVC)
        controller.track(scrollView: contentVC.tableView)
        controller.isRemovalInteractionEnabled = false
        // 如果是設 true，會完全 dismiss contentVC
        return controller
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Toggle", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "None"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        fpc.hide(animated: true)
    }
    
    private func layout() {
        fpc.addPanel(toParent: self)
        [toggleButton, label].forEach(view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: toggleButton.bottomAnchor, constant: 40),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func buttonDidTap() {
        switch fpc.state {
        case .half:
            fpc.move(to: .full, animated: true)
        case .hidden:
            fpc.move(to: .tip, animated: true)
        case .tip:
            fpc.move(to: .half, animated: true)
        default: break
        }
    }

    // MARK: - FloatingPanelControllerDelegate
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        print(fpc.state)
    }
}

class TableViewController: UITableViewController {
    
    var didSelect: ((String) -> Void)?
    
    private let items: [String] = [
    "option A",
    "option B",
    "option C",
    "option D",
    "option E",
    "option F",
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = items[indexPath.row]
        cell.contentView.backgroundColor = indexPath.item % 2 == 0 ? .systemGray6 : .systemGray5
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(items[indexPath.row])
    }
}
