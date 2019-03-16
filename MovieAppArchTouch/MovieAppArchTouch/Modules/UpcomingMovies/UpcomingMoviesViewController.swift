//
//  UpcomingMoviesViewController.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright (c) 2019 Yuri Ramos. All rights reserved.
//

import UIKit
import Kingfisher

class UpcomingMoviesViewController: UIViewController {
    
    var hud = HUD()
    var movies : [Movie] = []
    lazy var searchBar = UISearchBar()
    // MARK: Outlets
    @IBOutlet weak var moviesCollectionView : UICollectionView!
    
    // MARK: Injections
    var presenter: UpcomingMoviesPresenterInput!
    var configurator: UpcomingMoviesConfigurable!

    // MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        configurator = UpcomingMoviesConfigurator()
        configurator.configure(viewController: self)
        presenter.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .didReceiveGenre, object: nil, queue: nil) { (_) in
            self.moviesCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .didReceiveGenre, object: nil)
    }
    
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape,
            let layout = moviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = getCollectionViewCellSize()
            layout.invalidateLayout()
        } else if UIDevice.current.orientation.isPortrait,
            let layout = moviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = getCollectionViewCellSize()
            layout.invalidateLayout()
        }
    }
    
    private func getCollectionViewCellSize() -> CGSize {
        let deviceWidth = UIScreen.main.bounds.width
        let numColumns = CGFloat(floor(deviceWidth / 300.0))
        let cellWidth = (deviceWidth - 8 - (numColumns * 8)) / numColumns
        let cellHeight = cellWidth * 0.75
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
    }
    
    private func setNavigationBar() {
        self.navigationItem.title = "Upcomming Movies"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchClicked))
    }
    
    @objc func searchClicked() {
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search by Title"
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
    }
}

// MARK: - UpcomingMoviesPresenterOutput
extension UpcomingMoviesViewController: UpcomingMoviesPresenterOutput {
    func showMovies(movies: [Movie]) {
        self.movies.removeAll()
        self.movies.append(contentsOf: movies)
        self.moviesCollectionView.reloadData()
    }
    
    func showMoreMovies(movies: [Movie]) {
        self.movies.append(contentsOf: movies)
        self.moviesCollectionView.reloadData()
    }
    
    func toggleLoading(_ on: Bool) {
        if on {
            hud.showIn(self.view)
        } else {
            hud.hide(animated: true)
        }
    }
}

// MARK: - CollectionView
extension UpcomingMoviesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        let row = indexPath.row
        let movie = movies[row]
        
        cell.title.text = movie.title ?? ""
        let genres = movie.genreIds?.map{ GenreCache.shared.nameOfGenre(with: $0)}
                                .filter{ $0 != nil }
                                .map{$0 ?? ""}
                                .joined(separator: ", ")
        cell.genres.text = genres
        cell.releaseDate.text = movie.releaseDate ?? ""
        if let posterPath = movie.posterPath {
            let url = URL(string: APIImageUrl.w342.imageUrl(imageName: posterPath))!
            cell.poster.kf.setImage(with: url)
        }
        return cell
    }
}

extension UpcomingMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getCollectionViewCellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        self.presenter.selectedMovie(id: selectedMovie.id)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            self.presenter.getNextPage(search: searchBar.text)
        }
    }
}

// MARK: - SearchBar
extension UpcomingMoviesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.navigationItem.titleView = nil
        self.setNavigationBar()
        self.presenter.getUpcommingMovies(search: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.getUpcommingMovies(search: searchText)
    }
}
