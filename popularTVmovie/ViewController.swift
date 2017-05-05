//
//  ViewController.swift
//  popularTVmovie
//
//  Created by eric yu on 5/4/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import UIKit

let cellId = "cellId"



class ViewController: UIViewController{
   
    
    let cellSize = CGSize(width: 280 , height: 400)
    let focusSize = CGSize(width: 280 * 1.10, height: 400 * 1.10)
    
    var movies = [Movie]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .blue
        cv.dataSource = self
        cv.delegate = self

        //cv.isPagingEnabled = true
        return cv
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        
        autolayoutCollectionView()
        
         collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    //put it in download manager later
    func downloadData(){
        

   
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?page=1&language=en-US&api_key=5d56f2ac1e8d1bdb9a6757d0d253042e")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, reponse, error) in
            
            guard let data = data else {return}//display error message
            
            if error != nil {
                print(error.debugDescription)
            } else {
                do{
                    let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                    if let result = dict["results"] as? [Dictionary<String,Any>] {
                        
                        for obj in result {
                            let movie = Movie(movieDict: obj)
                            self.movies.append(movie)
                        }
                        //Main UI thread
                        DispatchQueue.main.async(){
                            self.collectionView.reloadData()
                        }
                        
                    }
                }catch{}
            }
        }

       task.resume()
    }
    
    
    func autolayoutCollectionView(){
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: topLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    
    }

   

}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let movie = movies[indexPath.row]
        cell.configureCell(movie: movie)
        
        if cell.gestureRecognizers?.count == nil{
            let tap = UITapGestureRecognizer(target: self
                , action: #selector(cellTapped))
            
        
            tap.allowedPressTypes =  [NSNumber(value: UIPressType.select.rawValue)]
            
            cell.addGestureRecognizer(tap)
        }
        
     

        return cell
    }
    
    func cellTapped(gesture: UITapGestureRecognizer){
        

        if let cell = gesture.view as? PageCell {
            
            
            print("I am tapped")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return cellSize
    }
    
   
}
//focus
extension ViewController {
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let prev = context.previouslyFocusedView as? PageCell {
            UIView.animate(withDuration: 0.2, animations: { 
                prev.imageView.frame.size = self.cellSize
            })
        }
        
        if let next = context.nextFocusedView as? PageCell {
            UIView.animate(withDuration: 0.2, animations: {
                next.imageView.frame.size = self.focusSize
            })
        }

        
        
    }
}

class PageCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "batman"))
        return iv
    }()
    
    var label: UILabel = {
        let lb = UILabel()
        lb.text = "Batman Movie"
        lb.textAlignment = .center
        
        
        return lb
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(label)
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 50, paddingRight: 15, width: 0, height: 0)
        
        label.anchor(top: imageView.bottomAnchor, left: imageView.leftAnchor, bottom: bottomAnchor, right: imageView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 15, paddingRight: 0, width: 0, height: 0)
   
    }
    
    func configureCell(movie: Movie){
        
        if let title = movie.title {
            label.text = title
        }
        
        if let path = movie.posterPath {
            let url = URL(string: path)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                let data = try Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    //run UI
                    let img = UIImage(data: data)
                    self.imageView.image = img
                }
                }catch{
                    //no image
                }
            }
        }
    }
        
}
    
    
    

