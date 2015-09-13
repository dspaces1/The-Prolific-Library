## The-Prolific-Library ##
The SWAG committee's personal library book tracking app.

### App Images ###
![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/LandingScreen.png?token=AD4GsrifLPiILTKVxlMtOAaJdUK-0mUUks5V_wJvwA%3D%3D) ![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/BookDetails.png?token=AD4Gsp7UoiXsZ8pxeK72hfHSmeit71k4ks5V_wLBwA%3D%3D) ![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/AddBook.png?token=AD4Gsn4XWQDCVaEaQKXjUC_MD-3FjOZ3ks5V_wMJwA%3D%3D) ![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/DeleteBook.png?token=AD4GslB2sMuly6UYg1LYr_1_1rIGlQ8Eks5V_xFLwA%3D%3D)

### Git Workflow ###
1. Created Master repo with Github
2. Created Library View branch
3. Created Add Book View branch
4. Created Book Detail View branch
5. Merged Back to Master For MVP

### Architecture Decisions ###
- Before I started coding I knew I was going to need a data model to hold all the book's JSON information. So I created a Library class that would serve as a helper class for all JSON RESTFul request and a Book Class that would inherit all those methods. The Book class would also be in charge of holding all of the book's JSON data.
- When choosing a UITableViewCell style I went with the default subtitle style because it fit the requirments just right. I also chose to let the book's title and author text get cut off in order to maintain the same cell sizes. This decision also prevents an edge case in which a user types in a book name that is long enough to cover the screen. 
- When creating the autolayout for the BookDetailViewController I knew the labels might grow in size and push the rest of the content down. In order to prevent the a case where the buttons were off the screen, I added a scroll view to dyamically increase the content size.
- When thinking about how to handle editing book information I thought about creating a brand new ViewController but since the interface was going to be very similair to AddBookViewController I decided to reuse that. I did so by creating 2 modes for the ViewController. 1 mode handled POST request and the other handled PUT request.
- For all the RESTful calls I knew I was going to need to block UI interactions when while the user was waiting so I created a Progress Helper Class. This Class pauses the UI and shows a a progress indicator icon. When I got response or no response from the server I would use the same class to reEnable the UI.

### Libraries Used ###
- AlamoFire (https://github.com/Alamofire/Alamofire) <br />
Used for all RESTful calls
- SwiftyJSON (https://github.com/SwiftyJSON/SwiftyJSON) <br />
Used for handling JSON data
- MBProgressHUD (https://github.com/jdg/MBProgressHUD) <br />
Used as my HUD indicator 
- IQKeyboardManager (https://github.com/hackiftekhar/IQKeyboardManager) <br />
Used to handle all keyboard interactions and view scrolling

### Code Optimization ###
- After finishing the MVP (Minimal Viable Product) I went back and noticed I was getting a lot of my book data from a dictionary that held all the JSON data. To speed things up a bit I created a property for each JSON field that would be set whenever I got fetched JSON data. <br />
```bookTitleTextField.text = book.jsonDictionary["title"] ``` -> ```bookTitleTextField.text = book.bookName```
- I was handling UserInteraction enable and disable logic with two different functions which I now combined into 1.
```
static func enableUI(flag: Bool, currentView:UIViewController) {
        if flag {
            reEnableUI(currentView)
        } else{
            startLoadAnimationAndDisableUI(currentView)
        }
}
```

### Challenges Faced ###
- First time using alamofire for more than just GET request was a bit a challenging setting it up. However, after working with alamofire and SwiftyJSON I can really apperciate how easy it can be to talk to a server using RESTful.
- Getting the Date right took me a bit because I was trying to turn JSON string date into a formated string date. After a bit of research I found that it is easier to convert the JSON string to date and then the NSDate to String with ```stringFromDate(date)```.
