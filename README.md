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

    DispatchQueue.global(qos: .userInitiated).async {
       //Background thread
       
        DispatchQueue.main.async {
            //update UI
        }
    }
