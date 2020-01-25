//
//  ViewController.swift
//  Running JavaScript
//
//  Created by Perez Willie-Nwobu on 1/24/20.
//  Copyright © 2020 Perez Willie-Nwobu. All rights reserved.
//

import UIKit
import WebKit



// WKSpcriptMessagehandler is a protocol that comes with the userContentController function
class ViewController: UIViewController, WKScriptMessageHandler {
    
    let MV = MessageViewModel.shared
    // The progressViews will represent the visual format of the 4 operations
    @IBOutlet var progressViews: [UIProgressView]!
    
    var webView: WKWebView?
    let userContentController = WKUserContentController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        MV.getMessage { (error, javaScript) in
            self.webView?.evaluateJavaScript(javaScript) { _, error in
                if let error = error { fatalError("Error evaluating initial javaScript: \(error)") }
                //We are calling the start operation function the same amount of time as we have progressView.count
                for id in self.MV.ids {
                    self.webView?.evaluateJavaScript("startOperation('\(id)')")
                }
            }
        }
    }
    
    
    //User content controller is kind of like a listener that takes in a WKScriptMessage, and if the message matches, it executes whatever function is written in its parameter.
    // So here we are using the message.name to verify that we are the right listener.
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jumbo" {
            guard let bodyString = message.body as? String else { fatalError("Message body not a string") }
            guard let body = bodyString.data(using: .utf8) else { fatalError("Error encoding body string to data") }
            let jsonMessage = try? JSONDecoder().decode(JSONMessage.self, from: body)
            updateView(with: jsonMessage)
        }
    }
    
    func setupView() {
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        self.webView = WKWebView(frame: .zero, configuration: config)
        userContentController.add(self, name: "jumbo")
    }
    
    func updateView(with message: JSONMessage?) {
        guard let message = message else { fatalError("No message returned") }
        guard let idString = message.id else { fatalError("No id") }
        guard let id = Int(idString) else { fatalError("id not an int") }
        let progressBar = progressViews[id]
        if let progress = message.progress {
            let progressFloat = Float(progress) / Float(100)
            progressBar.setProgress(progressFloat, animated: true)
        }
        // We change the color of the progressView depending on the percentage of completio we get from the callback.
        if let state = message.state {
            switch state {
            case "error":
                progressBar.tintColor = .red
            case "success":
                progressBar.setProgress(1, animated: true)
                progressBar.tintColor = .green
            default:
                return
            }
        }
    }
}

