import Foundation
import UIKit

class ImageLoader {
    weak var delegate: ImageLoaderDelegate?
    private var cache: NSCache<NSURL, UIImage> = NSCache()
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.imageLoader(self, didFailWith: error)
                    completion(nil)
                }
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSURL)
                DispatchQueue.main.async {
                    self.delegate?.imageLoader(self, didLoad: image)
                    completion(image)
                }
            }
        }.resume()
    }
}
