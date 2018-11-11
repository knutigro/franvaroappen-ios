//
//  ChildListViewModel.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-10-30.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import Foundation

public protocol ChildListViewModelInputs {
//    func currentUserUpdated()
//    func logoutCanceled()
//    func logoutConfirmed()
//    func settingsCellTapped(cellType: SettingsCellType)
//    func viewDidLoad()
//    func viewWillAppear()
}

public protocol ChildListViewModelOutputs {
//    var goToAppStoreRating: Signal<String, NoError> { get }
//    var logoutWithParams: Signal<DiscoveryParams, NoError> { get }
//    var reloadDataWithUser: Signal<User, NoError> { get }
//    var showConfirmLogoutPrompt: Signal<(message: String, cancel: String, confirm: String), NoError> { get }
//    var transitionToViewController: Signal<UIViewController, NoError> { get }
}

public protocol ChildListViewModelType {
    var inputs: ChildListViewModelInputs { get }
    var outputs: ChildListViewModelOutputs { get }
}

final class ChildListViewModel: ChildListViewModelInputs,
ChildListViewModelOutputs, ChildListViewModelType {
    
    public var inputs: ChildListViewModelInputs { return self }
    public var outputs: ChildListViewModelOutputs { return self }

}
