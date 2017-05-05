# LearnAppleTVOS

learning about tvOS

A. Register

  step 1. API from: https://www.themoviedb.org/documentation/api?language=e
  userName Reminder: f
  password Reminder: l

  step 2. Register API key and documation:   https://developers.themoviedb.org/3/getting-started
  user icon -> api --> request api key  --> developer --> (API Key and Acess Token)

B. xcode
  
   step1 xcode -> tvOS -> single View Application
   
   notes: p.list doesn't need "App Transport Security Settings" since is a "https" not "http"
   
C. download from the web useful GCD

//download data



    let url = URL(string: "somekeyfromAPIwebsite")
            let session = URLSession.shared
            let task = session.dataTask(with: url!) { (data, reponse, error) in

                guard let data = data else {return}//display error message

                if error != nil {
                    print(error.debugDescription)
                } else {
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data, 
                                                                  options: .allowFragments) as! Dictionary<String,Any>
                        if let result = dict["results"] as? [Dictionary<String,Any>] {

                            for obj in result {
                            //result an array of object
                            //each object will be put in an array of structs
                            //so it can be used as an collectionView datasource
                            
                                let obj= Movie(movieDict: obj)
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








//if data contain image/video/song url process it in UICollectionCells

    DispatchQueue.global(qos: .userInitiated).async {
       //Background thread
       
        DispatchQueue.main.async {
            // If you don't update UI here it will be VERY SLOW
        }
    }
    
    
# what happen in each situation

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
      
   //above code is the same as below since last two line was already in main queue 
   //(view wait for all pictures loaded - takes about 5 seconds
   //default picture does not even load

           do{
                  let data = try Data(contentsOf: url)
                  let img = UIImage(data: data)
                   self.imageView.image = img
              
            }catch{
                //no image
           }
           
# all in main


 loads default picture than once all images are loaded it displays/n
 it takes 5 secs/n
  

          DispatchQueue.main.async {
                do{
                        let data = try Data(contentsOf: url)
                        let img = UIImage(data: data)
                        self.imageView.image = img
                }catch{}
           }



           
# all line in global
   
  loads default picture than once all images are loaded it displays/n
  it takes 8-10 secs/n
   
            
              DispatchQueue.global(qos: .userInitiated).async {
                 do{
                    let data = try Data(contentsOf: url)
                    let img = UIImage(data: data)
                    self.imageView.image = img
                 }catch{}
              }
              

    
           


