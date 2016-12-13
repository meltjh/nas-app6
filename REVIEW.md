Code review
===========

**Names**:
In alle prepare functies wordt de naam van een DetailedViewController vc genoemd terwijl het bekend is dat het een DetailedViewController is.

**Headers**:
Enkele /// nog als // geschreven. Duidelijke korte beschrijvingen van functies die alleen de nodige eigenscahppen van de functies uitleggen. De struct user heeft geen headers. In favoriteViewController -allFavoriteItems, -FavoriteToShopItem en SingleTableView - setSelected geen headers.

**Comments**:
Er zijn alleen enkele comments tussen code dat niet (meer) relevant is. De struct user heeft geen comments. Verder zijn de comments duidelijk en goed samenvattend op alleen de plekken waar dit nodig is.

**Layout**:
Sommige regels zijn erg breed waardoor er ook met een breed scherm code word gewrapt. Dit kan beter tot maximaal 80-120 characters gehouden worden. Verder duidelijke idents en netjes overal spaties na comma's etc zodat de code onverzichtelijker en netter oogt.

**Formatting**:
Er zijn goede code blocks gegeven waar de functie wat langer is zoals in ShopItem, FavoriteToShopItem of getData. Meestal zijn de functies goed onderverdeeld en dus niet lang waardoor de codeblocks niet eens van toepassing zijn.

**Flow**:
De marks maken de code erg goed leesbaar en ook vanuit de dropdown list in de editer. Hierdoor is de flow gelijk duidelijk zichtbaar en is het zoeken naar functies ook gemakkelijker. De code is ook niet diep genest en er zijn geen dubbele stukken code die op een duidelijkere manier gemaakt kunnen worden. Dus lastige problemen zijn zo duidelijk mogelijk opgelost.

**Idom**:
De uitlog functies zijn identiek en zijn dus dubbelop in de ViewControllers. De ShopItem struct is goed te gebruiken voor de json van de API, het vult zichzelf dan goed in en is dan gelijk overal gemakkelijk te gebruiken. Gezien dit afhankelijk is van de json, is dit ook niet beter te maken zodat het meerdere API's aankan of iets dergelijks.

**Expressions**:
Datatypes zijn veral duidelijk gedefineerd en er wordt niet van tyoes veranderd binnen dezelfde variabelen. Er wordt alleen gecast van AnyObjects naar bijvoorbeeld String, maar dat kan niet anders gegeven de structuur van de API. Er wordt dus duidelijk gebruik gemaakt van types en variabelen. Variabele constanten zoals urls, segue anmen of (cell) identifiers kunnen beter bovenaan als constanten in plaats van binnen de code zoals in SearchViewController en FavoritesViewController. SearchViewController -getData en FavoritesViewController -favoriteToShopItem staat if variabele != nil {} else { code } en dit kan vervangen worden door een variabele == nil { code }. Ook zijn in deze functies lege catches gegven, deze zullen een error moeten afhandelen of throwen.

**Decomposition**:
Gehele code is goed onderverdeeld in korte functies die elk een duidelijke taak hebben. In searchViewController en favoritesViewController is de variabele selectedItem gebruikt dat niet nodig lijkt om tussen functies te gebruiken, echter is dit gezien de prepare for segue niet anders te doen. Dus ook de shared variabalen zijn minimaal gehouden en alleen gebruikt wanneer nodig.

**Modularization**:
Zoals hierboven al genoemd is de code goed onderverdeeld in korte duidelijke taken. De functies getData en favoritesToShopItem lijken onderverdeeld te kunnen worden, maar gezien de asynchrone code is het onduidelijk hoe. Dus de code is goed onderverdeeld.
