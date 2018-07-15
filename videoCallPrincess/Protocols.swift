//
//  ShareViewDelegate.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 2/17/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

protocol ShareViewDelegate: class {
    func cancelBtnAction()
    func verticalBtnAction()
    func boxBtnAction()
    func shareBtnAction()
}

protocol DeleteViewDelegate: class {
    func deleteBtnAction()
}

protocol SecondViewControllerDelegate: class {
  func settingsUpdated(light: Bool)
}
