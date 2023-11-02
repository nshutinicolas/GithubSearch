//
//  RemoteImage.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 31/10/2023.
//

import UIKit

class RemoteImage: UIImageView {
    private let imageCache = NSCache<NSString, UIImage>()
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from urlString: String) {
        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
        if let imgFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = imgFromCache
            self.removeSpinner()
            return
        }
        addSpinner()
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                let imageData = UIImage(data: data)
                guard let imageData else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.image = imageData
                    self.imageCache.setObject(imageData, forKey: url.absoluteString as NSString)
                    removeSpinner()
                }
            } catch {
                // TODO: Handle error - Add a placeholder image
                self.image = UIImage(systemName: "rectangle.portrait.slash")
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
    }
    private func addSpinner(){
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.addSubview(activityIndicator)
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            self.activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            self.activityIndicator.startAnimating()
        }
    }
    private func removeSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.activityIndicator.removeFromSuperview()
        }
    }
}
