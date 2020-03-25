//
//  public func swift
//  Dengage.Framework
//
//  Created by Ekin Bulut on 25.03.2020.
//

import Foundation


public class DengageEvent
{
    public static let shared  = DengageEvent()
    static var eventCollectionService = DengageEventCollecitonService()
    
    
    public func SessionStart(location: String){
        
        Dengage.StartSession(actionUrl: location)
        
    }
    
    public func TokenRefresh(token : String){
        
        let parameters = [ "token" : token ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "sdkTokenAction", entityType: nil, pageType: nil, params: parameters)
    }
    
    public func ProductDetail(productId: String, price: Double, discountedPrice: Double, currency:String, supplierId:String){
        
        
        let parameters = [ "entityId" : productId,
                           "price" : price,
                           "discountedPrice" : discountedPrice,
                           "currency" : currency,
                           "supplierId" : supplierId
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: "product", pageType: "productDetail", params: parameters)
    }
    
    public func PromotionPage(promotionId: String){
        
        let parameters = [
            "entityId" : promotionId
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: "category", pageType: "categoryPage", params: parameters)
    }
    
    public func CategoryPage(categoryId: String, parentCategoryId: String){
        
        let parameters = [
            "entityId" : categoryId,
            "parentCategory" : parentCategoryId
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: "promotion", pageType: "promotionPage", params: parameters)
        
    }
    
    public func HomePage(){
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: nil, pageType: "homePage", params: [ : ] as NSMutableDictionary)
    }
    
    public func SearchPage(keyword: String, resultCount:Int){
        
        let parameters = [
            "keyword" : keyword,
            "resultCount" : resultCount
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: nil, pageType: "searchPage", params: parameters)
        
    }
    //    public func Refinement(filters, resultCount){}
    public func LoginPage(){
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: nil, pageType: "loginPage", params: [ : ] as NSMutableDictionary)
        
    }
    
    public func LoginAction(memberId: String, status: Bool, origin: String){
        
        let parameters = [
            "memberId" : memberId,
            "status" : status,
            "origin" : origin,
            "eventType" : "loginAction"
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "Action", entityType: nil, pageType: nil, params: parameters)
    }
    
    public func RegisterPage(){
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: nil, pageType: "registerPage", params: [ : ] as NSMutableDictionary)
    }
    
    public func RegisterAction(memberId: String, status: Bool, origin: String){
        
        let parameters = [
            "memberId" : memberId,
            "status" : status,
            "origin" : origin,
            "eventType" : "registerAction"
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "Action", entityType: nil, pageType: nil, params: parameters)
    }
    
    public func AddToBasket(item : Item, discountedPrice : Double, origin : String, basketId: String){
        
        let parameters = [
            "discountedPrice" : discountedPrice,
            "basketId" : basketId,
            "origin" : origin,
            "eventType":"addToBasket",
            "productId" : item.productId,
            "variantId" : item.variantId,
            "price" : item.price,
            "currency" : item.currency,
            "quantity" : item.quantity
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "Action", entityType: nil, pageType: nil, params: parameters)
    }
    
    public func RemoveFromBasket(productId: String, variantId: String, quantity : Int, basketId: String){
        
        let parameters = [
            "eventType" : "removeFromBasket",
            "productId" : productId,
            "variantId" : variantId,
            "quantity" : quantity,
            "basketId" : basketId
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "Action", entityType: nil, pageType: nil, params: parameters)
    }
    
    public func BasketPage(items : [Item], totalPrice : Double, basketId: String){
        
        var productIds = ""
        var prices = ""
        var quantities = ""
        var variantIds = ""
        var currencies = ""
        
        for item in items {
            
            prices.append(String(item.price) + "|")
            quantities.append(String(item.quantity) + "|")
            productIds.append(item.productId + "|")
            variantIds.append(item.variantId + "|")
            currencies.append(item.currency + "|")
        }
        
        let parameters = [
            "productIds" : productIds.dropLast(),
            "variantIds" : variantIds.dropLast(),
            "quantities" : quantities.dropLast(),
            "prices" : prices.dropLast(),
            "currencies" : currencies.dropLast(),
            "basketId" : basketId,
            "totalPrice": totalPrice
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: nil, pageType: "basketPage", params: parameters)
        
    }
    
    public func OrderSummary(items : [Item], totalPrice : Double, basketId: String, orderId: String, paymentMethod: String){
        
        var productIds = ""
        var prices = ""
        var quantities = ""
        var variantIds = ""
        var currencies = ""
        
        for item in items {
            
            prices.append(String(item.price) + "|")
            quantities.append(String(item.quantity) + "|")
            productIds.append(item.productId + "|")
            variantIds.append(item.variantId + "|")
            currencies.append(item.currency + "|")
        }
        
        
        let parameters = [
            "productIds" : productIds.dropLast(),
            "variantIds" : variantIds.dropLast(),
            "quantities" : quantities.dropLast(),
            "prices" : prices.dropLast(),
            "currencies" : currencies.dropLast(),
            "basketId" : basketId,
            "totalPrice": totalPrice,
            "orderId": orderId,
            "paymentMethod": paymentMethod
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "PV", entityType: nil, pageType: "orderSummary", params: parameters)
    }
    
    public func Refinement(pageType : PageType, filters : Dictionary<String, [String]>, resultCount : Int){
        
        var pt = ""
        
        switch pageType {
        case .SearchPage:
            pt = "searchPage"
        case .CategoryPage:
            pt = "categoryPage"
        case .PromotionPage:
            pt = "promotionPage"
        }
        
        let parameters = [
            "filters" : filters,
            "resultCount" : resultCount,
            "pageType" : pageType
            
            ] as NSMutableDictionary
        
        DengageEvent.eventCollectionService.customEvent(eventName: "Action", entityType: "products", pageType: pt, params: parameters)

    }
    
}



public class Item
{
    public var productId: String = ""
    public var variantId: String = ""
    public var price : Double = 0.0
    public var currency: String = ""
    public var quantity: Int = 0
}

public enum PageType {
    
    case SearchPage
    case CategoryPage
    case PromotionPage
}
