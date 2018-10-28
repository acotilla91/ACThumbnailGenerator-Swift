//
//  ViewController.swift
//  ACThumbnailGenerator-Swift
//
//  Created by Alejandro Cotilla on 10/18/2018.
//  Copyright (c) 2018 Alejandro Cotilla. All rights reserved.
//

import UIKit
import ACThumbnailGenerator_Swift

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var images: [UIImage] = []
    var generator: ACThumbnailGenerator!
    
    let maxImages = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let streamUrl = URL(string: "https://p-events-delivery.akamaized.net/18oijbasfvuhbfsdvoijhbsdfvljkb6/m3u8/hls_vod_mvp.m3u8")!
        generator = ACThumbnailGenerator(streamUrl: streamUrl)
        generator.delegate = self
        
        for i in 1...maxImages {
            generator.captureImage(at: Double(300 * i))
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.frame.width * 9 / 16
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as! CellView
        
        let image = images[indexPath.section]
        cell.fullImageView.image = image
        
        return cell
    }
}

extension ViewController: ACThumbnailGeneratorDelegate {
    func generator(_ generator: ACThumbnailGenerator, didCapture image: UIImage, at position: Double) {
        images.append(image)
        tableView.insertSections([images.count - 1], with: .fade)
    }
}


