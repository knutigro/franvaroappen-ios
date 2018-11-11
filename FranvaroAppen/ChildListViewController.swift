//
//  ChildListViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-10.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RxSwift

class ChildListViewController: UITableViewController {
    
    var disposeBag = DisposeBag()
    var applicationRouter: ApplicationRouter?
    var dataSource: ChildListDataSource? {
        didSet {
            if let dataSource = dataSource {
                tableView.dataSource = dataSource
                tableView.emptyDataSetSource = dataSource
            }
        }
    }
    var viewControllerIsFirstTimeLoading = true
    var childPersistenceController: ChildPersistenceProtocol?
    fileprivate let viewModel: ChildListViewModel = ChildListViewModel()

    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Barn", comment: "")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        guard let childPersistenceController = childPersistenceController else {
            assertionFailure("childPersistenceController can't be nil")
            return
        }

        tableView.emptyDataSetDelegate = self

        applicationRouter = ApplicationRouter(viewController: self.navigationController ?? self, childPersistenceController: childPersistenceController)
        dataSource = ChildListDataSource(childPersistenceController: childPersistenceController)
        guard let dataSource = dataSource else { return }

        dataSource.models.asObservable().subscribe(onNext: { [weak self] _ in
            guard let children = self?.dataSource?.models.value else { return }
            if !children.isEmpty {
                let childrenNames = children.map{ $0.name} as NSArray
                Analytics.trackValue(value: childrenNames, forProfileAttribute: Analytics.ProfileAttributesKey.children)
            }
            Analytics.trackValue(value: NSNumber(integerLiteral: children.count), forProfileAttribute: Analytics.ProfileAttributesKey.numberOfChildren)
            DispatchQueue.main.async(execute: { [weak self] () in
                self?.tableView.reloadData()
            });
        }).disposed(by: disposeBag)
        
        dataSource.update()
        
        if dataSource.models.value.isEmpty {
            applicationRouter?.presentAddChildViewController(animated: false)
        } else if dataSource.models.value.count == 1, let child = dataSource.models.value.first {
            applicationRouter?.presentMenuViewController(with: child, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewControllerIsFirstTimeLoading {
            viewControllerIsFirstTimeLoading = false
        } else {
            dataSource?.update()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: .childList)
    }
    
    @IBAction func didTapAddChild(_ button: UIBarButtonItem) {
        applicationRouter?.presentAddChildViewController(animated: true)
    }
}

// MARK: TableViewDelegate

extension ChildListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let child = dataSource?.models.value[indexPath.row] {
            applicationRouter?.presentMenuViewController(with: child, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Radera") { [weak self] action, index in
            self?.dataSource?.delete(atIndexPath: indexPath)
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
}

// MARK: DZNEmptyDataSetDelegate

extension ChildListViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView) {
        applicationRouter?.presentAddChildViewController(animated: true)
    }
}
