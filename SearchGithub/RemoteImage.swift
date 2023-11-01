//
//  RemoteImage.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import UIKit

// MARK: - Image Cache
let imageCache = NSCache<AnyObject, AnyObject>()

class RemoteImage: UIImageView {
    var task: URLSessionDataTask?
    var activityIndicator = UIActivityIndicatorView(style: .medium)

    func loadRemoteImage(from urlString: String) async throws {
        // Implement this method
    }
    
    func loadImage(with imgUrl: String){
        image = nil
        if let task {
            task.cancel()
        }
        
        guard !imgUrl.isEmpty, let url = URL(string: imgUrl) else { return }
        if let imgFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imgFromCache
            self.removeSpinner()
            return
        }
        addSpinner()
        task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil, let data = data, let img = UIImage(data: data) else {
                print(error.debugDescription)
                return
            }
            DispatchQueue.main.async {
                self.image = img
                imageCache.setObject(img, forKey: url.absoluteString as AnyObject)
                self.removeSpinner()
            }
        }
        task?.resume()
    }
    private func addSpinner(){
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        activityIndicator.startAnimating()
    }
    private func removeSpinner() {
        activityIndicator.removeFromSuperview()
    }
}
