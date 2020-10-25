//
//  HUD.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/25/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

enum HUDState {
    case isShowing
    case isHiding
}

/*:
 ### Initial Protocol Definition

What are the things that something conforming to htis protocol is required to do?
*/
protocol HUDShowing {
  func showHUD(in view: UIView,
               title: String?,
               animated: Bool) -> HUD
  
  func hideHUD(_ hud: HUD,
               animated: Bool)
}

/*:
 ### Default Protocol Extension

By default, what should something conforming to this protocol do in order to fulfill requirements of the protocol?
 
If something declared in the protocol isn't implemented here, anything that conforms to the protocol must provide an implementation.
*/
extension HUDShowing {
  
  func showHUD(in view: UIView,
               title: String?,
               animated: Bool = true) -> HUD {
    let hud = HUD(text: title)
    hud.frame = view.bounds
    view.addSubview(hud)
    hud.show(animated: animated)
    
    return hud
  }
  
  func hideHUD(_ hud: HUD,
               animated: Bool = true) {
    hud.hide(animated: animated, completion: {
      hud.removeFromSuperview()
    })
  }
}

/*:
 ### Adding a protocol extension to a default type

Allows everything directly or indirectly inheriting from this type to use the default implementation.
*/
extension UIView: HUDShowing {

  @discardableResult
  func showHUD(title: String?,
               animated: Bool = true) -> HUD {
    return self.showHUD(in: self,
                        title: title,
                        animated: animated)
  }

  func hideHUD(animated: Bool = true) {
    guard let hud = HUD.hud(in: self) else { return }

    self.hideHUD(hud, animated: animated)
  }
}

/*:
 ### Using the extended functionality in another default implementation

Now when making a view controller which conforms to UIViewController, you can use the same convenience methods as above.
 */

extension HUDShowing where Self: UIViewController {
  
  var viewToShowHUDIn: UIView {
    if let tabBar = self.tabBarController {
      return tabBar.view
    } else if let nav = self.navigationController {
      return nav.view
    } else {
      return self.view
    }
  }

  @discardableResult
  func showHUD(title: String?,
               animated: Bool = true) -> HUD {
    return self.viewToShowHUDIn.showHUD(title: title, animated: animated)
  }

  func hideHUD(animated: Bool = true) {
    self.viewToShowHUDIn.hideHUD(animated: animated)
  }
}

///*:
// ### Another protocol definition
//*/
//
//protocol UserDetailsFetching {
//
//  func handleError(_ error: Error)
//
//  func fetchUserDetails(successCompletion: @escaping (UserDetails) -> Void)
//}
//
///*:
// ### Default definition for multiple conditions
//
// Anything taking wishing to take advantage of these implementations must conform to all requirements: In this case it must be a UIViewController which already conforms to HUDShowing
//
// This allows you to use protocols like building blocks really easily.
//*/
//extension UserDetailsFetching where Self: UIViewController, Self: HUDShowing {
//
//  private func showErrorAlert(for error: Error) {
//    let alert = UIAlertController(title: "Error fetching details",
//                                  message: error.localizedDescription,
//                                  preferredStyle: .alert)
//
//    alert.addAction(UIAlertAction(title: "OK",
//                                  style: .default))
//
//    self.present(alert, animated: true)
//  }
//
//  func handleError(_ error: Error) {
//    self.showErrorAlert(for: error)
//  }
//
//  func fetchUserDetails(successCompletion: @escaping (UserDetails) -> Void) {
//    self.showHUD(title: "Fetching details...")
//    Network.fetchUserDetails(failureCompletion: { [weak self] error in
//      self?.hideHUD()
//      self?.handleError(error)
//    }, successCompletion: { [weak self] details in
//      self?.hideHUD()
//      successCompletion(details)
//    })
//  }
//}

// The Heads-Up Display class to show/hide

public class HUD: UIView {
  private lazy var progressIndicator: UIActivityIndicatorView = {
    let activityIndictor = UIActivityIndicatorView()
    activityIndictor.translatesAutoresizingMaskIntoConstraints = false
    activityIndictor.style = .large
    activityIndictor.startAnimating()
    
    
    return activityIndictor
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.textColor = .white
    label.textAlignment = .center
    
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    
    self.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
      stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
    ])
    
    return stackView
  }()
  
  private func setAlpha(_ alpha: CGFloat, animated: Bool, completion: (() -> Void)? = nil) {
    let duration = animated ? 0.5 : 0
    UIView.animate(withDuration: duration, animations: {
      self.alpha = alpha
    }, completion: { _ in
      completion?()
    })
  }
  
  public static func hud(in view: UIView) -> HUD? {
    return view.subviews.first(where: { $0 is HUD }) as? HUD
  }
  
  public convenience init(text: String?) {
    self.init(frame: .zero)
    self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    self.stackView.addArrangedSubview(progressIndicator)
    self.stackView.addArrangedSubview(titleLabel)
    self.titleLabel.text = text
    self.hide(animated: false)
  }
  
  public func show(animated: Bool, completion: (() -> Void)? = nil) {
    self.setAlpha(1, animated: animated, completion: completion)
  }
  
  public func hide(animated: Bool, completion: (() -> Void)? = nil)  {
    self.setAlpha(0, animated: animated, completion: completion)
  }
}

