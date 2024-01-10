//
//  ViewController.swift
//  NaverLogin
//
//  Created by adam on 2024/01/09.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire

class ViewController: UIViewController {
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.naverLoginInstance?.delegate = self
    }

    @IBAction func loginButtonDidTapped(_ sender: UIButton) {
        self.naverLoginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func logoutButtonDidTapped(_ sender: UIButton) {
        self.naverLoginInstance?.requestDeleteToken()
    }
    
    @IBAction func refreshTokenButtonDidTapped(_ sender: UIButton) {
        
        if ((self.naverLoginInstance?.isValidAccessTokenExpireTimeNow()) != nil) {
            self.naverLoginInstance?.requestAccessTokenWithRefreshToken()
        }
        
    }
    
}

extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    
    // 로그인 성공
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Login success")
    }
    
    // referesh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        self.naverLoginInstance?.accessToken
        print("referesh token success")
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("Logout")
    }
    
    // error 발생
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error ::: \(error.localizedDescription)")
        self.naverLoginInstance?.requestDeleteToken()
    }
    
    func naverLoginPaser(url: URL, header: HTTPHeaders) {
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header).responseString() { response in
            switch response.result {
            case .success(let success):
                print("Naver Data - \(success)")
               
                
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
}
