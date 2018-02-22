
import UIKit

class LandscapeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    var searchResults: [SearchResult]
    lazy var collectionView: UICollectionView = {

        let screenWidth = view.frame.size.height
        let cellWidth = ((screenWidth/6.0)  /  4.0) * 3
        let cellSpacing = ((screenWidth/6.0) /  4.0)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.0;
        layout.minimumLineSpacing = cellSpacing
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return collectionView
    }()
    let pageControl = UIPageControl()
    private var downloads = [URLSessionDownloadTask]()

    init(searchResults: [SearchResult]) {
        self.searchResults = searchResults
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("deinit \(self)")
        for task in downloads {
            task.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor =  UIColor(patternImage: #imageLiteral(resourceName: "pattern"))

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(iconCollectionViewCell.self, forCellWithReuseIdentifier: "iconCell")
        collectionView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "pattern"))

        pageControl.numberOfPages = Int(ceilf(Float(searchResults.count) / 18.0)) // round up
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)

        for v in [collectionView, pageControl] as! [UIView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }

        NSLayoutConstraint.activate([

//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            pageControl.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])

    }

    

    @objc func pageChanged(_ sender: UIPageControl) {
        collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
    }

    //MARK:- collectionView delegate mathods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // if index path greather than results count return an empty cell (dogy thing for pagination)
        if indexPath.row >= searchResults.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath)
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"iconCell", for: indexPath) as! iconCollectionViewCell
            downloadImage(for: searchResults[indexPath.row], andPlaceOn: cell.iconButton)
            return cell
        }
    }

    func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
        if let url = URL(string: searchResult.imageSmall) {
            let task = URLSession.shared.downloadTask(with: url) {
                [weak button] url, response, error in
                if error == nil, let url = url, let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let button = button {
                            button.setImage(image, for: .normal)
                        }
                    }
                }
            }
            task.resume()
            downloads.append(task)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // always return a multiple of 18 (dodgy fix for last page pagination error)
        if searchResults.count % 18 == 0 {
            return  searchResults.count
        } else {
            return  searchResults.count + (18 - searchResults.count % 18)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let page = Int((scrollView.contentOffset.x + width / 2) / width)
        pageControl.currentPage = page
    }

}
