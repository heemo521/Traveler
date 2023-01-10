
# Traveler - Onramp x Realtor.com iOS Engineer (Interview: Take Home Project)

Are you working remotely and forgetting to step outside and enjoy the nature around you? Or are you frequently searching online for the best places to visit while planning your next getaway? **The _Traveler_ application can help! With just a few clicks, Traveler will assist you in finding up to 50 top landmarks and outdoor destinations anywhere in the world.**

**Quick Note**: It is recommended to view this repository in [light mode](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-personal-account-settings/managing-your-theme-settings) for better readability.

## Overview

***Traveler*** is powered by [Foursquare's Places API](https://location.foursquare.com/places/docs/home) to search exclusively for landmarks and outdoor destinations. Using iOS frameworks [Core Location](https://developer.apple.com/documentation/corelocation) and [Map Kit](https://developer.apple.com/documentation/mapkit/), this application allows users to quickly find nearby destinations and view their location on a map. This application is built using `Swift` and `UIKit`.

## Environment Variables

To run this project, you will need to add the following environment variables to your `Info.plist` file:
- `API_KEY`: Add Foursquare's Place's API Authentication API Key to your environment. Create a developer account with [Foursquare](https://location.foursquare.com/developer/) to receive your API Key.

## Features
### Landing Screen (Home)
By allowing access to the device's location, the user will be able to find the closest destination on the landing screen without making any searches. The user can also see the category, address, and distance in miles, as well as directions to the destination. 
### Search Screen
Users can search by typing into the search bar or by clicking on the "Use current location" button. The user can also click on recent searches to quickly repeat a search. The search bar also includes an auto completer to assist the user.
### Result Screen
Users can view the results of their search on the result screen and update their search query or apply filters for a better searching experience. The results include a small image, name, and address.
### Detail Screen
The detail screen includes swipeable oversized images, as well as the category, address, a map view, and a list of related places.

## Design & User Flow
### Landing Screen

![Main](https://i.imgur.com/48dazrwm.png)  -  ![Scroll down](https://i.imgur.com/Fhk6Z5xm.png)  -  ![LandScape](https://i.imgur.com/W2zd7LPm.png)
- The main landing screen includes a `scroll view` to display data with large fonts for readability and support for landscape mode.
- A guide view (not visible) covers the top half of the device's screen to help position and size the circular image view properly for device orientation.
- An `image view` tap gesture allows the user to go directly to the detail screen with animation to convey that this is a button.
- A search `button` in the top navigation clearly communicates the transition to the search screen.
- A distance `label` displays the distance in miles to the nearby recommended place.
- `MapKit` is used to show directions to the nearby recommended place.


### Search Screen

![Main](https://i.imgur.com/sgiYaNSm.png)  -  ![Edit Recent Search](https://i.imgur.com/1zYTDkSm.png)  -  ![Auto Completer](https://i.imgur.com/DdSoEGCm.png)
- The `UISearchBar` is auto-focused as the first responder so the user can start searching as soon as the screen appears.
- MKLocalSearchCompleter is configured to show only address results to assist the user in finding the best results.
- The "Use current location" button allows for quick searches of nearby places without typing.
- A recent search `table view` displays a list of search history and allows the user to delete recent searches with a swipe gesture.
- The search result label is displayed instead of the result search when displaying a table view list of results from MKLocalSearchCompleter.
- The user can press enter on the device keyboard or tap on a row in the table view to initiate a search.

### Result Screen

![Main](https://i.imgur.com/HIFJtC8m.png)  -  ![Filter](https://i.imgur.com/XZ46rxom.png) - ![LandScape](https://i.imgur.com/DycVopTm.png)
- As soon as the search is made, the Result Screen is displayed. 
    - Initially as _medium detent_ `Modal` from Search Screen so that user can quickly make another search without going back to the previous screen
- `Filter` section is placed on top of the modal and contains `Open Now`, `Search Limit`, and `Sort` to quickly apply filter
    - `Open Now` is a button configured to be a **toggle / selection button** to easily apply and remove the Open Now filter 
    - `Limit` and `Sort` buttons are **drop down menu button** with preset choices for users to easily select
    - When `Open Now` or `Sort` button is applied, the tableview will automatically scroll back to the top but when the limit button is applied, the view will stay the same as it is likely that the user is trying to display more results
    - When any of the filters are applied, the _spinning indicator_ is displayed to let the user know that the system is working 
- _Liked_ location will have a filled heart over the image
- User can tab on any of the result row to see the place in Detail Screen 
### Detail Screen
- ![Main](https://i.imgur.com/m31c8Esm.png) -  ![Related Places](https://i.imgur.com/SEoWcpPm.png) - ![LandScape](https://i.imgur.com/Sg7u9Dnm.png)
- The images are displayed using **collection view** to allow users to easily swipe between different images
- The `Name` is placed over the first image and the _transition animation_ is used to show and hide the name label
- The Image View is initially rendered with lower quality image displayed in the Result View and replaced with correct image quality fetched using the devices screen. 
    - All images shown in the application are fetched using the dimension of the image view (double height and width)
- The `Name` and `Related Places` are buttons (with disabled interactivity) rather than label for easy styling purpose 
- Like button to mark the place as liked which will be saved on the device 
- User can go back to Search / Result Screen by clicking on the back icon button on the top left corner (same as the back button on the navigation)
    
### Light / Dark Mode
 - The colors for the application are set using the system coloring to allow user's to view the application that is consistent with the phone's setting. Global variable is used to easily change overall color with ease
 - Please see the ***Demo*** section below

## Architecture
### Please reference this section for structure 
- **Folder**
- **`SwiftFile`** 
- _Properties_ and _Methods_
- ***Important***

### Model
- **Service**
    - **`UserService`**
        - Service / Manager for User data Model containing CRUD methods to manage `User`'s properties
        - Uses ***Singleton*** pattern with *shared* property and private init 
            - There will ever be only be one instance of `User` needed per application 
- **User**
    - **`User`**
        - User data model with Set of `RecentSearch`, Set of `LikedLocation`, and `Coordinate`
    - **`RecentSearch`**
        - One to many relationship with `User`
        - Includes title and subtitle property and conforms to Codable, Equatable, Hashable protocols to be used as a Set by `User`
    - **`LikedLocation`**
        - One to many relationship with `User`
        - Typealias String to be used as a Set by `User`
- **Place**
    - **`Response`**
        - Decodable data model for response from Places API 
    - **`Place`**
        - One to many relationship with `Response`
        - Decodable data model that defines model for each place 
    - **`Image`**
        - Decodable data model for Image response from Places API 
        - The image urls will be constructed from this data model as String and placed inside the `Place` data model's _imageUrls_ property
            - Places API requires separate http request for the images data. _imageUrls_ in `Place` is not part of the actually   
        - Can be viewed as One to Many Relationship with `Place`
- **CoreLocation**
    - **`LocationAnnotation`**
        - Data model for annotations to be placed on the map that conforms to MKAnnotation protocol
    - **`Coordindate`**
        - One to One relationship with `Place`
        - One to One relationship with `User` as *lastLocation* property

### View
- **Cell**
    - **`SearchCell`**
        - Defines UI for Search Screen's tableview row
        - _Update_ method is used by SearchViewController's to update data
        - There is two _Update_ method. One for `RecentSearch` to display recent searches and another for `MKLocalSearchCompletion` to display search completer results
    - **`ResultCell`**
        - Defines UI for Result Screen's tableview row  
        - _Update_ method is used by ResultViewController's to update data
    - **`ImageCell`**
        - Defines UI for Details Screen's collectionview row  
        - _Update_ method is used by DetailViewController's to update data
- **Extensions**
    - **`UIImageViewExtension`** 
        - Extends `UIImageView` with _loadFrom_ method that accepts url as an argument and loads the image.  
    - **`UIButtonExtension`** 
        - Extends `UIButton` with _configureButton_ method that helps with configuring the button easily with one method
    - **`UILabelExtension`** 
        - Extends `UILabel` with _configureLabel_ method for easy configuration
    - **`UITextViewExtension`** 
        - Extends `UITextView` with _configureNonEditableTextView_ method for easy configuration
- **`ColorPalette`**
    - Extends `UIColor` with _MyColor_ struct with color properties used in the application

### Controller
- **`HomeViewController`**
    - Subclass of `UIViewController` 
    - Conforms to `MKMapViewDelegate` protocol and acts as a ***delegate*** for a `MKMapView` object to display route to the destination from user's location
    - Conforms to `CLLocationManagerDelegate` protocol and acts as a ***delegate*** for `CLLocationManager` object to receive updates about the location of the device
    - Each ViewController is organized as extensions to maintain code readability.
- **`SearchViewController`**
    - Subclass of `UIViewController`
    - Conforms to `UISearchBarDelegate` protocol and acts a ***delegate*** for a `UISearchBar` object to display receive the search query entered into the search bar 
    - Conforms to `MKLocalSearchCompleterDelegate` protocol and acts as a ***delegate*** for a `MKLocalSearchCompleter` object that receives the completions based on a search query  
    - Conforms to `UITableViewDelegate` and `UITableViewDataSource` protocols and acts as a ***delegate*** and ***datasource*** for the `tableview` to define the data to be displayed and receives events when user clicks on the row
- **`ResultViewController`**
    - Subclass of `UIViewController` and conforms to `UITableViewDelegate` and `UITableViewDataSource`protocols 
- **`DetailViewController`**
    - Subclass of `UIViewController` and conforms to `UICollectionViewDelegate` and `UICollectionViewDataSource`protocols 
- **Utility**
    - **`HTTPRequest`** 
        - A class that contains static methods _buildRequest_ and _makeRequest_ that are used in the ViewControllers to build the http request and actually make the request 
        - Main use for this class is to avoid repetitive code 


## Demo
For Better Quality video, checkout the links below.
- [Dark Mode](https://youtu.be/5XqxA5RANRY) 
- [Light Mode](https://youtube.com/shorts/Na2P9n92aJY?feature=share)

<div>
    <img src="TimeTraveler/Resources/darkmode.gif" width="200px">
    <img src="TimeTraveler/Resources/lightmode.gif" width="200px">
</div>


## Beyond MVP: Future Development Goals

- [ ] Add user's settings page to personalize the landing screen recommendation and application
- [ ] Develop a recommendation algorithm that will be able to make more specific search using user's data
- [ ] Enable related places button to refresh the Detail screen with the selected location
- [ ] Add a view for review section
- [ ] Add a screen for liked locations and automatically organize them by city 
- [ ] Add a button to mark places as visited
- [ ] Connect with iPhone's Map for user to quickly turn on navigation to selected destination

 

