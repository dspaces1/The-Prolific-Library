## The-Prolific-Library ##
The SWAG committee's personal library book tracking app.

### App Images ###
![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/LandingScreen.png?token=AD4GsrifLPiILTKVxlMtOAaJdUK-0mUUks5V_wJvwA%3D%3D) ![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/BookDetails.png?token=AD4Gsp7UoiXsZ8pxeK72hfHSmeit71k4ks5V_wLBwA%3D%3D) ![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/AddBook.png?token=AD4Gsn4XWQDCVaEaQKXjUC_MD-3FjOZ3ks5V_wMJwA%3D%3D) ![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/DeleteBook.png?token=AD4GslB2sMuly6UYg1LYr_1_1rIGlQ8Eks5V_xFLwA%3D%3D)
![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/PullToRefresh.png?token=AD4Gsv4LqcmV0uXObSWF3f5LcS2S5O3Hks5V_xnlwA%3D%3D)
![alt tag](https://raw.githubusercontent.com/dspaces1/The-Prolific-Library/master/App%20Screenshots/WarningMessage.png?token=AD4GsgCAeFcvuD6hycq1U2DQISH3VixLks5V_xn5wA%3D%3D)

### Git Workflow ###
1. Created Master repo with Github
2. Created Library View branch
3. Created Add Book View branch
4. Created Book Detail View branch
5. Merged Back to Master For MVP

### Architecture Decisions ###
- Before I started coding, I knew I was going to need a data model to hold all the book's JSON information. So I created a Library class that would serve as a helper class for all JSON RESTful request and a Book class that would inherit all of those methods. The Book class would also be in charge of holding all of the book's JSON data.
- When choosing a UITableViewCell style I chose the default subtitle style because it fit the requirements perfectly. I also chose to let the book's title and author text get cut off in order to maintain the same cell sizes. This decision prevents an edge case where a user types in a book name that is long enough to cover the screen. 
- When creating the autolayout for the BookDetailViewController I knew the labels might grow in size and push the rest of the content down. In order to prevent the edge case where the buttons gets pushed off the screen, I added a scroll view to dynamically increase the content size.
- When thinking about how to handle editing book information I thought about creating a brand new ViewController but since the interface was going to be very similar to AddBookViewController I decided to reuse it instead. I did so by creating 2 modes for the ViewController: one mode handled POST requests and the other mode handled PUT requests.
- For all the RESTful calls I knew I was going to need to block UI interactions while the user was waiting so I created a Progress Helper Class. This class pauses the UI and shows a progress indicator icon. After the server response is received, the same class re-enables the UI.

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
- After finishing the Minimal Viable Product (MVP) I revisited my code and noticed I was getting my book data from a dictionary that held all of the JSON data. To quicken the process I created a property for each JSON field that would be set whenever I fetched JSON data. <br />
```bookTitleTextField.text = book.jsonDictionary["title"] ``` -> ```bookTitleTextField.text = book.bookName```
- I handled UserInteraction enable and disable logic with two different functions which I now combined into one.
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
- The first time using alamofire for more than just GET request was slightly challenging to set up. However, after working with alamofire and SwiftyJSON I came to appreciate how easy it is to talk to a server using RESTful.
- Getting the date in the right format was difficult because I tried to turn JSON string date into a formatted string date. After some research I found that it is easier to convert the JSON string to NSDate and then the NSDate to string with ```stringFromDate(date)```.
