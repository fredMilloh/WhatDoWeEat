# WhatDoWeEat

## Table of Contents

-   [Introduction](https://github.com/fredMilloh/WhatDoWeEat#introduction)
-   [Features](https://github.com/fredMilloh/WhatDoWeEat#features)
-   [Screenshots](https://github.com/fredMilloh/WhatDoWeEat#screenshots)
-   [IDE](https://github.com/fredMilloh/WhatDoWeEat#ide)
-   [Skills](https://github.com/fredMilloh/WhatDoWeEat#skills)
-   [How to use](https://github.com/fredMilloh/WhatDoWeEat#how-to-use)
-   [License](https://github.com/fredMilloh/WhatDoWeEat#license)


## Introduction

An application that allows users to obtain recipes based on the inventory in their fridge. Users can save their favourite recipes at the touch of a button. They can find them at any time in the *Favourite* tab.

## Features

Entering ingredients :
 - As long as the list is empty, the user cannot launch a search.
 - The user enters the ingredients one by one, or together, separated by a comma.
 - The entry of several commas or spaces is accepted.
 - Entering a number or a character other than a letter and a comma will result in an error message when the *Add* button is pressed 
 - When the user adds ingredients, they are displayed in a list.
 - Ingredients in the list can be removed separately.
 - The list can be cleared with the *Clear* button

The result of the recipes :
 - The recipes corresponding to the entered ingredients are displayed in the list.
 - By selecting a recipe, more details are displayed in a new view.
 - A button displays the recipe's web page, to get the preparation instructions.

Favorites :
 - The saved recipes are displayed in a list in the *Favorite* tab.
 - If the list is empty, a message informs the user of the procedure to follow to add a recipe to the favorites.
 - In the detail view, a recessed button in the upper right-hand corner allows the recipe to be placed in the favorites.
 - When the button is tinted, the recipe can be removed from the favorites by pressing the button again.
 - A left drag also allows to remove a recipe.

## Screenshots

https://user-images.githubusercontent.com/47221695/184693701-e940a02b-a39a-45da-a247-a77705b552e6.mp4

## IDE
-   Swift 5.3
-   iOS deployment target 15
-   Xcode 13.2.1

## Skills
-   MVVM
-   Protocols
-   Alamofire
-   Callback
-   nestedContainer
-   PrefetchDataSource
-   CAGradientLayer
-   UIAlertController
-   UITabBarAppearance
-   UITableView
-   Core Data
-   Cellule xib
-   TDD ViewModel
-   Code coverage

## How To Use

 - Fork the project
 
From your terminal :

 - Create a branch and work on it
 - Publish the branch on its fork
 - Create the pull-request


**Alamofire**

The *Alamofire* library (https://cocoapods.org/pods/Alamofire) is used.

With *Cocoapods*, once the project is cloned, in the terminal, go to the project directory, and run `pod install`.


**API**

This application uses the following API :

Edamam : https://developer.edamam.com/edamam-docs-recipe-api

Project without API key. Add your API key :

 - Delete the ConfigKeys file and add a new "configuration settings file" to the project.

 - Name it *ConfigKeys*.

 - Set the configurations (Debug, Release) in the project, with this configuration file.

 - Add your API key and application ID to the following keys :

    API_KEY =

    ID_APP_KEY =




## License

[MIT License](https://github.com/fredMilloh/WhatDoWeEat/blob/master)

----------------------------------------------------------------------------------------

This application was realized from a specification, within the framework of a study project.

