//
//  LoginViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/01/2022.
//

import UIKit
import SnapKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class LoginViewController: UIViewController {
    
    // =============================================
    // MARK: - Properties
    // =============================================
    
    fileprivate var currentNonce: String?
    fileprivate var sha256: String?
    
    lazy var loginView: LoginView = {
        let view = LoginView()
        return view
    }()
    
    lazy var btnSignIn: UIButton = {
        let view = UIButton()
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Sign in with Apple", for: .normal)
        view.setImage(#imageLiteral(resourceName: "Logo - SIWA - Left-aligned - White - Small").withRenderingMode(.alwaysOriginal), for: .normal)
        view.layer.cornerRadius = 7
        view.backgroundColor = .black
        view.addTarget(
            self,
            action: #selector(handleSignIn),
            for: .touchUpInside
        )
        return view
    }()
    
    // =============================================
    // MARK: - Lifecycle
    // =============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        view.backgroundColor = .loginBackground
        configureLogin()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // =============================================
    // MARK: - Helpers
    // =============================================
    
    func configureLogin() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(btnSignIn)
        btnSignIn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-80)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalToSuperview().offset(-50)
        }
    }
    
    func presentMainContoller() {
        navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    // Unhashed nonce.
    
    @available(iOS 13, *)
    @objc func handleSignIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// =============================================
// MARK: - Extensions
// =============================================

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("DEBUG: Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                debugPrint("DEBUG: Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                debugPrint("DEBUG: Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) {(authDataResult, error) in
                if error != nil {
                    debugPrint("DEBUG: Failed to Login: \(String(describing: error))")
                } else {
                    if let user = authDataResult?.user {
                        
                        let values = ["email": user.email]
                        Service.shared.updateUserValues(values: values as [String: Any])
                        UserService.refreshUser()
                        self.presentMainContoller()
                    }
                }
            }
        }
    }
}

func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    debugPrint("DEBUG: Sign in with Apple errored: \(error)")
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}
