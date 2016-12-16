# nas-app6
Zalando Favorites App
=====================

This is a Zalando Favorites app in which users can save their favorite products.   
The live open data API that was used is from the webshop Zalando (https://api.zalando.com/).   

On the start page, the user can log in or create an account.   
A login or register error is shown with an alert.   
UserDefaults was used to save very small user data, namely the last time the app was used.  
Under the last time the app was used, we not only consider signing out, but also closing the app.   
This date is shown when the app has been used at least once.   
State restoration is used to save the text that was filled in in the email address field when the application was terminated while on the log in screen.    

<img src="https://github.com/meltjh/nas-app6/raw/master/doc/login2.png" height="250">
<img src="https://github.com/meltjh/nas-app6/raw/master/doc/login-error.png" height="250">    

When the user has logged in, the search view appears. 
The user can search for products in the Zalando webshop, for example _shoes_.   
The results are shown with an thumbnail, the brand name, the product name and the price.   
Products that are discounted are shown with the original price striked through and the discounted price.   
<img src="https://github.com/meltjh/nas-app6/raw/master/doc/search2.png" height="250">  

When the user presses on a search result, a more detailed page is shown with two bigger product images, the brand name, the product name and the original price (and if present, the discount price).   
The button “View in browser” opens the webpage of the product, so that the user can order the product.   
The product can be added to favorites by pressing the button “Add to favourites!”.   
This button is then changed to "Remove from favorites!" with which the product can be removed from favorites. 

<img src="https://github.com/meltjh/nas-app6/raw/master/doc/detailed.png" height="250">
<img src="https://github.com/meltjh/nas-app6/raw/master/doc/detailed2.png" height="250">  

The Favorites button on the toolbar shows a list with the products that are favorited by the user.    
Again, a more detailed page is shown when pressing on a product.   
A product can also be deleted by swiping to the left on a product and pressing the “Delete” button.   

<img src="https://github.com/meltjh/nas-app6/raw/master/doc/favorites.png" height="250">
<img src="https://github.com/meltjh/nas-app6/raw/master/doc/delete.png" height="250">  

The prices in the app are up to date with the API, because the prices are not stored in Firebase, but called through the API.
