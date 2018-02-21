
import UIKit

extension UIImageView {



    func loadImage(url: URL ) -> URLSessionDownloadTask {

        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url,
          completionHandler: { [weak self] url, response, error in

            if error == nil, let url = url {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {

                    if let weakSelf = self {
                        DispatchQueue.main.async {
                            weakSelf.image = image

                        }
                    }
                }
            }
        })
        downloadTask.resume()
        return downloadTask
    }
}
