
# Traveler - Onramp x Realtor.com iOS Engineer (Interview: Take Home Project)

Hello, fellow _Travelers_! Are you working remotely at home and often forget to step outside 
and enjoy the nature around you? Or are you frequently surfing on random destination websites 
to find the top 10 places to visit while your planning your quick getaway? **The _Traveler_
application helps you quicky find landmarks and outdoor places that you can visit anywhere 
in the world!** With just couple clicks, the **_Traveler_** will help you find up to top 50 places
that you can visit and help you plan your trip! 

Quick Note: Please view this repository in [light mode](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-personal-account-settings/managing-your-theme-settings) for better readability.

## Overview

The ***Traveler*** application is powered by [Foursquare's
Places API](https://location.foursquare.com/places/docs/home) to
make search exclusively for the [Landmarks and Outdoors](https://location.foursquare.com/places/docs/categories) category.
Using iOS frameworks [Core Location](https://developer.apple.com/documentation/corelocation) and 
[Map Kit](https://developer.apple.com/documentation/mapkit/), the application allows the users to 
quickly find nearby destinations as well as see them on the map. This application is built using `Swift` and `UIKit`.
## Environment Variables

To run this project, you will need to add the following environment 
variables to your `Info.plist` file.

- `API_KEY` Add Foursquare's Place's API Authentication API Key in your environment. Create your developer's account at [Foursquare](https://location.foursquare.com/developer/) to receive your API Key.

## Features
### Landing Screen (Home)
- By allowing the access to the device location, the user will see be able to find a closest place(destination) on the landing screen without making any search
- Users can see the category, address, and distance in miles along with routes to the displayed place 
### Search Screen
- User can make search by typing into the search bar or by clicking on current location button. The user can also click on the recent search to quickly make the same search.
- User will be assisted with auto completer when typing into the search bar
### Result Screen
- User can view the result over the search screen and quickly update search query or apply filters for better searching experience
- The result will be able to view small image, name, and address
### Detail Screen
- Swipeable oversized images are displayed along with category, address, map view, and list of related places

## Design & User Flow
1. **Landing Screen** 
    - ![Main](https://i.imgur.com/48dazrwm.png)  -  ![Scroll down](https://i.imgur.com/Fhk6Z5xm.png)  -  ![LandScape](https://i.imgur.com/W2zd7LPm.png)
    - **`Scroll View`** to display data with space and large fonts for readability and also support landscape mode
    - `Guide View` that covers the top half of the devices screen to help position and size the circular image view properly for device orientation.
    - **`Image View Tap Gesture`** to present Detail Screen directly from the Home Screen and animation while the tap is being applied to convey that this is a button
    - `Search Button` placed in the top navigation to clearly communicate segue to Search Screen 
    - `Distance` **label** displayed in miles to the nearby recommended place  
    - `Map Route` using **MapKit** to show direction to the nearby recommended place
    
2. **Search Screen**
    - ![Main](https://i.imgur.com/sgiYaNSm.png)  -  ![Edit Recent Search](https://i.imgur.com/1zYTDkSm.png)  -  ![Auto Completer](https://i.imgur.com/DdSoEGCm.png)
    - **`Search Bar`** is auto focused as the first responder so the user can start making search right away after the screen view appears
    - `MKLocalSearchCompleter` configured to show only address result type to better assist the users for the best searching results
    - `Use current location` **button** for quick search of nearby places without typing anything
    - `Recent Search` **table view** to see the list of search history and functionality to delete recent search with swipe gesture
    - `Search Result` **label** is displayed instead of Result Search when displaying tableview list of results from MKLocalSearchCompleter 
    - User can press enter on the device keyboard after typing in destination or tab on the row of table view to make the search
3. **Result Screen**
    - ![Main](https://i.imgur.com/HIFJtC8m.png)  -  ![Filter](https://i.imgur.com/XZ46rxom.png)
    - As soon as the search is made, the Result Screen is displayed. 
        - Initially as _medium detent_ `Modal` from Search Screen so that user can quickly make another search without going back to the previous screen
    - `Filter` section is placed on top of the modal and contains `Open Now`, `Search Limit`, and `Sort` to quickly apply filter
        - `Open Now` is a button configured to be a **toggle / selection button** to easily apply and remove the Open Now filter 
        - `Limit` and `Sort` buttons are **drop down menu button** with preset choices for users to easily select
        - When `Open Now` or `Sort` button is applied, the tableview will automatically scroll back to the top but when the limit button is applied, the view will stay the same as it is likely that the user is trying to display more results
        - When any of the filters are applied, the _spinning indicator_ is displayed to let the user know that the system is working 
    - _Liked_ location will have a filled heart over the image
    - User can tab on any of the result row to see the place in Detail Screen 
4. **Detail Screen**
    - ![Main](https://i.imgur.com/m31c8Esm.png) -  ![Related Places](https://i.imgur.com/SEoWcpPm.png)
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
- **`SwiftFile`** or `SwiftFile`
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
### Controller
- **`HomeViewController`**
    - UI and 
- **`SearchViewController`**
    - UI and 
- **`ResultViewController`**
    - UI and 
- **`DetailViewController`**
    - UI and 
- **Super**



## Features
- Overall features on each screen 
### Landing Screen (Home)
- By allowing the access to the device location, the user will see be able to find a closest place(destination) on the landing screen without making any search
- Users can see the category, address, and distance in miles along with routes to the displayed place 
### Search Screen
- User can make search by typing into the search bar or by clicking on current location button. The user can also click on the recent search to quickly make the same search.
- User will be assisted with auto completer when typing into the search bar
### Result Screen
- User can view the result over the search screen and quickly update search query or apply filters for better searching experience
- The result will be able to view small image, name, and address
### Detail Screen
- Swipeable oversized images are displayed along with category, address, map view, and list of related places

## Demo
For Better Quality video, checkout the links below.
- [Dark Mode](https://youtu.be/5XqxA5RANRY) 
- [Light Mode](https://youtube.com/shorts/Na2P9n92aJY?feature=share)

![Imgur](https://imgur.com/scI8tn9.gif)
![Imgur](https://imgur.com/6pfp3ZG.gif)



## Beyond MVP: Future Development Goals

- [ ] Add user's settings page to personalize the landing screen recommendation and application
- [ ] Develop a recommendation algorithm that will be able to make more specific search using user's data
- [ ] Enable related places button to refresh the Detail screen with the selected location
- [ ] Add a view for review section
- [ ] Add a screen for liked locations and automatically organize them by city 
- [ ] Add a button to mark places as visited
- [ ] Connect with iPhone's Map for user to quickly turn on navigation to selected destination

 

