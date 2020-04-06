# Dengage.Framework v2.3.11

## Requirements

* Dengage Integration Key
* iOS Push Cerificate
* iOS Device ( you must test on real device for notifications)
* A mac with latest Xcode

## Installation

Dengage.Framework is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Dengage.Framework'
```

## License

Dengage.Framework is available under the GNU General Public License v3.0 license. See the LICENSE file for more info.

***Dengage.Framework*** provides necessary classes and functions which handles notification registration and sending open events to developer.  Also it gives classes to send subscription events to dengage infrastructure.

Supports 11.0+

## 1. Add Notification Service Extention

1.1 In Xcode Select ```File``` > ```New``` > ```Target```

1.2 Select ```Notification Service Extension``` then press ```Next```.

![](./docs/img/extension.png)

1.3 Enter the product name as ```DengageNotificationServiceExtension``` and press ```Finish```.

![](./docs/img/settings.png)

1.4 Press Cancel on the Activate scheme prompt.

![](./docs/img/activate.png)

1.5 Open ```NotificationService.swift``` and replace the whole file contents with the below code.

```swift

    import Dengage_Framework // import sdk

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
         
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
           
            Dengage.didReceiveNotificationExtentionRequest(receivedRequest: request, with: bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }

```

### Note : While sending push notifications, Dengage senders puts a messageSource to the message payload. Notification messages will handle if messageSource has the value of DENGAGE.

## 2. Add Required Code

Navigate to the AppDelegate file and add the following ```Dengage``` initialization code to ```didFinishLaunchingWithOptions```.

```swift
    import Dengage_Framework // import sdk

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
       // set integration key
       Dengage.setDengageIntegrationKey(key: "dengage-integration-key")
       
       Dengage.useCloudForSubscription(enable: true)
        
       Dengage.initWithLaunchOptions(withLaunchOptions: launchOptions, badgeCountReset: true)
            
       // add this method to ask for user permission
       Dengage.promptForPushNotifications()


       return true
    }

```
**Note:** If you want SDK **not to manage** remote notification registration; set  ```registerForRemoteNotifications``` to false, you need to implement ```UIApplication.shared.registerForRemoteNotifications()```

**Note:** If you prefer not to use ```promptForPushNotifications``` method, you should inform sdk about user permission by using ```setUserPermission(permission: BOOL)``` method.

```swift
    import Dengage_Framework // import sdk

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
       // set integration key     
       Dengage.setDengageIntegrationKey(key: "dengage-integration-key")
       
       Dengage.useCloudForSubscription(enable: true)
       
       Dengage.initWithLaunchOptions(withLaunchOptions: launchOptions, badgeCountReset: true)
       
       
       ...{
           // ask for user permission, and send permission status either false or true
           Dengage.setUserPermission(true)
       }

       
       return true
    }

```

Navigate to the AppDelegate file and add the following ```Dengage``` code to ```didRegisterForRemoteNotificationsWithDeviceToken```

```swift 


    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        Dengage.setToken(token : token)
        
    }

```


## 3. Logging

SDK logs any important operation by using logs. In default, logs will not be displayed. To enable logs call ```setLogStatus(isVisiable : BOOL)``` method.

```swift
        func someFunction(){

            Dengage.setLogStatus(isVisible: true)
            
        }
```

## 4. Callbacks

You can access to ```UNUserNotificationCenterDelegate``` callback with ```HandleNotificationActionBlock``` method. Callback object is type of ```UNNotificationResponse```

```swift

    Dengage.HandleNotificationActionBlock { (notificationResponse) in
                
                
                let messageDetails = notificationResponse.notification.request.content.userInfo["messageDetails"] as! String;
                let messageId = notificationResponse.notification.request.content.userInfo["messageId"] as! Int;
                
                print(messageDetails)
                print(String(messageId))
            }


```

## 5. Deeplinking

SDK supports URL schema deeplink. If target url has a valid  link, it will redirect to related link.

* [Apple URL Scheme Deeplinking](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app)

* [Apple Universal Link](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content)


# Event Collection

## Requirements

* Dengage.Framework

Framework provides Event Methods for integration.

**Note:** *Before sending an event, Dengage.Framework opens a Session by defualt. But according to implementation, developer can able to open a session manually.*

### 1. ``` DengageEvent.shared.StartSession(actionUrl: location) ```

- Parameter location : *deeplink (page link)*

```swift
    DengageEvent.shared.StartSession(actionUrl: location)
```

### 2.  ```DengageEvent.shared.TokenRefresh(token : String)```

- Parameter token : *apns token*

```swift
    DengageEvent.shared.TokenRefresh(token: String)
```

### 3.  ```DengageEvent.shared.ProductDetail(productId: String, price: Double, discountedPrice: Double, currency:String, supplierId:String)```

- Parameter productId : *productId*
- Parameter price : *price*
- Parameter discountedPrice : *discountedPrice*
- Parameter currency : *currency*
- Parameter supplierId : *supplierId*

```swift

    DengageEvent.shared.ProductDetail(productId: String, price: Double, discountedPrice: Double, currency:String, supplierId:String)

```

### 4.  ```DengageEvent.shared.PromotionPage(promotionId: String)```

- Parameter promotionId : *promotionId*

```swift
    DengageEvent.shared.PromotionPage(promotionId: String)
```


### 5.  ```DengageEvent.shared.CategoryPage(categoryId: String, parentCategoryId: String)```

- Parameter categoryId : *categoryId*
- Parameter parentCategoryId : *parentCategoryId*

```swift
    DengageEvent.shared.CategoryPage(categoryId: String, parentCategoryId: String)
```

### 6.  ```DengageEvent.shared.HomePage()```

```swift
    DengageEvent.shared.HomePage()
```

### 7.  ```DengageEvent.shared.SearchPage(keyword: String, resultCount:Int)```

- Parameter keyword : *keyword*
- Parameter resultCount : *resultCount*

```swift
    DengageEvent.shared.SearchPage(keyword: String, resultCount:Int)
```

### 8.  ```DengageEvent.shared.LoginPage()```

```swift
    DengageEvent.shared.LoginPage()
```

### 9.  ```DengageEvent.shared.LoginAction(memberId: String, status: Bool, origin: String)```

- Parameter memberId : *memberId*
- Parameter status : *status*
- Parameter origin : *origin*

```swift
    DengageEvent.shared.LoginAction(memberId: String, status: Bool, origin: String)
```

### 10.  ```DengageEvent.shared.RegisterPage()```

```swift
    DengageEvent.shared.RegisterPage()
```

### 11.  ```DengageEvent.shared.RegisterAction(memberId: String, status: Bool, origin: String)```

- Parameter memberId : *memberId*
- Parameter status : *status*
- Parameter origin : *origin*

```swift
    DengageEvent.shared.RegisterAction(memberId: String, status: Bool, origin: String)
```

### 12.  ```DengageEvent.shared.BasketPage(items : [CartItem], totalPrice : Double, basketId: String)```

- Parameter items : *items*
- Parameter totalPrice : *totalPrice*
- Parameter basketId : *basketId*

```swift
    DengageEvent.shared.BasketPage(items : [CartItem], totalPrice : Double, basketId: String)
```

### 13.  ```DengageEvent.shared.AddToBasket(item : CartItem, origin : String, basketId: String)```

- Parameter item : *item*
- Parameter origin : *origin*
- Parameter basketId : *basketId*

```swift
    DengageEvent.shared.AddToBasket(item : CartItem, origin : String, basketId: String)
```

### 14.  ```DengageEvent.shared.RemoveFromBasket(productId: String, variantId: String, quantity : Int, basketId: String)```

- Parameter productId : *productId*
- Parameter variantId : *variantId*
- Parameter quantity : *quantity*
- Parameter basketId : *basketId*

```swift
    DengageEvent.shared.RemoveFromBasket(productId: String, variantId: String, quantity : Int, basketId: String)
```

### 15.  ```DengageEvent.shared.OrderSummary(items : [CartItem], totalPrice : Double, basketId: String, orderId: String, paymentMethod: String)```

- Parameter items : *items*
- Parameter totalPrice : *totalPrice*
- Parameter basketId : *basketId*
- Parameter orderId : *orderId*
- Parameter paymentMethod : *paymentMethod*

```swift
    DengageEvent.shared.OrderSummary(items : [CartItem], totalPrice : Double, basketId: String, orderId: String, paymentMethod: String)
```

### 16.  ```DengageEvent.shared.Refinement(pageType : PageType, filters : Dictionary<String, [String]>, resultCount : Int)```

- Parameter pageType : *pageType*
- Parameter filters : *filters*
- Parameter resultCount : *resultCount*

```swift
    DengageEvent.shared.Refinement(pageType : PageType, filters : Dictionary<String, [String]>, resultCount : Int)
```
