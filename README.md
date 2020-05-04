# MComics

## Architecture 
I have used the MVVM Pattern with Combine and SwiftUI. 

For handling the navigations, instead of following the classic Coordinator pattern, I created the CharacterViewFactory that handles the creation and the dependency injection of the views. It follows a protocol. So the idea is of using the Factory pattern for handling the navigation of the views, by using this pattern I was able to use the NavigatioLink from SwfitUI and decoupling the navigation from the view, as it will ask the ViewModel and the ViewModel will return the next view by using the injected view Factory that is just a protocol so I can easily change the flow by just changing the CharacterViewFactory or by just creating another factory the follows the CharacterViewFactoryProtocol.


## iOS Target 13.2 
## API 
The app consumes the Marvel API. Check the documentation: https://developer.marvel.com/docs. To be able to run the project do not forget to set the API keys on the xcconfig files. 

## Running 

*  Run pod repo update.
*  Run pod install.
*  Select DEV Scheme. It already comes with the App keys configured. 
*  If you get errors after executing the steps above, run pod deintegrate and then run pod install again.
*  Set the api keys on the xxconfig files for the schemes you want to use. 

## Pods

*  SDWebImageSwiftU - Used to load images and cache them. 
*  KIF - Used for running fast UI Tests. 
*  Quick - Used to write tests on Behavior-Driven Testing style. 
*  Nimble - Used to assert unit tests. 
*  Swifter - Used to mock server calls. It runs a server on XCode on 8080 port. 

## Unit Tests
For running unit tests you **MUST** first select the **TESTS Scheme**. 

## Screens - Light/Dark

### Characters list: 
![](Screens/characters_list_light.jpg)
![](Screens/characters_list_dark.jpg)

### Characters Detail: 
![](Screens/character_detail_light.jpg)
![](Screens/character_detail_dark.jpg)

character_detail_dark
### Favorites list: 
![](Screens/favorites_characters_list_light.jpg)
![](Screens/favorites_characters_list_dark.jpg)

### Favorites Empty: 
![](Screens/no_favorite_characters_light.jpg)
![](Screens/no_favorite_characters_dark.jpg)

### Offline: 
![](Screens/offline_light.jpg)
![](Screens/offline_dark.jpg)

### Search: 
![](Screens/search_light.jpg)
![](Screens/search_dark.jpg)

### Error: 
![](Screens/error_light.jpg)
![](Screens/error_dark.jpg)

