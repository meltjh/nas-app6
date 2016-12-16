# nas-app6

This is a Zalando Favorites app in which users can save their favorite products.   
The live open data API that was used is from the webshop Zalando (https://api.zalando.com/).   

On the first page, the user can log in or create an account.   
A login or register error is shown with an alert.   
UserDefaults is used to save the last time the app was used.   
This date is shown when the app has been used at least once.   
State restoration is used to save the text that was filled in in the email address field when the application was terminated while on the log in screen.    

<img src="https://github.com/meltjh/nas-app6/raw/master/doc/login2.png" height="250">    

When the user has logged in, the search view appears. 
The user can search for products in the Zalando webshop.
<img src="https://github.com/meltjh/nas-app6/raw/master/doc/search.png" height="250">  

When the user presses on a search result, a more detailed page is shown.   
The button “View in browser” gives the webpage of the product.   
The product can be added to favorites by pressing the button “Add to favourites!”.   

<img src="https://github.com/meltjh/nas-app6/raw/master/doc/detailed.png" height="250">  

Via the same button, the product can be removed from favorites.  

<img src="https://github.com/meltjh/nas-app6/raw/master/doc/detailed2.png" height="250">  

The Favorites button on the toolbar shows a list with the products that are favorited by the user.    
Again, a more detailed page is shown when pressing on a product.   

<img src="https://github.com/meltjh/nas-app6/raw/master/doc/favorites.png" height="250">  

A product can also be deleted by swiping to the left on a product and pressing the “Delete” button.   

<img src="https://github.com/meltjh/nas-app6/raw/master/doc/delete.png" height="250">  
