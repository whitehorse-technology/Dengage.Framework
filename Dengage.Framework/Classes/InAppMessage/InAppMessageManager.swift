
import Foundation
final class InAppMessageManager {
    
    var settings: Settings
    var service: BaseService
    var logger: SDKLogger
    var inAppMessageWindow: UIWindow?
    
    init(settings:Settings, service:BaseService, logger: SDKLogger = .shared){
        self.settings = settings
        self.service = service
        self.logger = logger
        registerLifeCycleTrackers()
    }
}

//MARK: - API
extension InAppMessageManager{
    func fetchInAppMessages(){
        guard shouldFetchInAppMessages else {return}
        let accountName = settings.configuration?.accountName ?? ""
        let request = GetInAppMessagesRequest(accountName: accountName,
                                              contactKey: settings.contactKey.0,
                                              type: settings.contactKey.type,
                                              deviceId: settings.getApplicationIdentifier())
        service.send(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                let nextFetchTime = (Date().timeMiliseconds) + (self?.settings.configuration?.fetchIntervalInMin ?? 0.0)
                DengageLocalStorage.shared.set(value: nextFetchTime, for: .lastFetchedInAppMessageTime)
                self?.addInAppMessagesIfNeeded(response)
            case .failure(let error):
                self?.logger.Log(message: "fetchInAppMessages_ERROR %s", logtype: .debug, argument: error.localizedDescription)
            }
        }
    }
    
    private func markAsInAppMessageAsDisplayed(inAppMessageId: String?) {
        guard isEnabledInAppMessage else {return}
        let accountName = settings.configuration?.accountName ?? ""
        let request = MarkAsInAppMessageDisplayedRequest(type: settings.contactKey.type,
                                                         deviceID: settings.getApplicationIdentifier(),
                                                         accountName: accountName,
                                                         contactKey: settings.contactKey.0,
                                                         id: inAppMessageId ?? "")
        
        service.send(request: request) { [weak self] result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self?.logger.Log(message: "markAsInAppMessageAsDisplayed_ERROR %s", logtype: .debug, argument: error.localizedDescription)
            }
        }
    }
    
    private func setInAppMessageAsClicked(_ messageId: String?) {
        guard isEnabledInAppMessage else {return}
        let accountName = settings.configuration?.accountName ?? ""
        let request = MarkAsInAppMessageClickedRequest(type: settings.contactKey.type,
                                                         deviceID: settings.getApplicationIdentifier(),
                                                         accountName: accountName,
                                                         contactKey: settings.contactKey.0,
                                                         id: messageId ?? "")
        
        service.send(request: request) { [weak self] result in
            switch result {
            case .success( _ ):
                self?.removeInAppMessageFromCache(messageId ?? "")
            case .failure(let error):
                self?.logger.Log(message: "setInAppMessageAsClicked_ERROR %s", logtype: .debug, argument: error.localizedDescription)
            }
        }
    }
    
    private func setInAppMessageAsDismissed(_ inAppMessageId: String?) {
        guard isEnabledInAppMessage else {return}
        let accountName = settings.configuration?.accountName ?? ""
        let request = MarkAsInAppMessageAsDismissedRequest(type: settings.contactKey.type,
                                                         deviceID: settings.getApplicationIdentifier(),
                                                         accountName: accountName,
                                                         contactKey: settings.contactKey.0,
                                                         id: inAppMessageId ?? "")
        
        service.send(request: request) { [weak self] result in
            switch result {
            case .success( _ ):
                break
            case .failure(let error):
                self?.logger.Log(message: "setInAppMessageAsDismissed_ERROR %s", logtype: .debug, argument: error.localizedDescription)
            }
        }
    }
}

//MARK: - Workers
extension InAppMessageManager {
    
    func setNavigation(screenName: String? = nil) {
        guard !(settings.inAppMessageShowTime != 0 && Date().timeMiliseconds < settings.inAppMessageShowTime) else {return}
        let messages = DengageLocalStorage.shared.getInAppMessages()
        guard !messages.isEmpty else {return}
        let inAppMessages = InAppMessageManager.findNotExpiredInAppMessages(untilDate:Date(), messages)
        guard let priorInAppMessage = findPriorInAppMessage(inAppMessages: inAppMessages, screenName: screenName) else {return}
        showInAppMessage(inAppMessage: priorInAppMessage)
    }
    
    private func showInAppMessage(inAppMessage: InAppMessage) {
        markAsInAppMessageAsDisplayed(inAppMessageId: inAppMessage.data.messageDetails)

        if let showEveryXMinutes = inAppMessage.data.displayTiming.showEveryXMinutes, showEveryXMinutes != 0 {
            var updatedMessage = inAppMessage
            updatedMessage.nextDisplayTime = Date().timeMiliseconds + Double(showEveryXMinutes) * 60000.0
            updateInAppMessageOnCache(updatedMessage)
        } else {
            removeInAppMessageFromCache(inAppMessage.data
                                            .messageDetails ?? "")
        }
        let inappShowTime = (Date().timeMiliseconds) + (self.settings.configuration?.minSecBetweenMessages ?? 0.0)
        DengageLocalStorage.shared.set(value: inappShowTime, for: .inAppMessageShowTime)
        
        let delay = inAppMessage.data.displayTiming.delay ?? 0

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
            let controller = InAppMessagesViewController(with: inAppMessage)
            controller.delegate = self
            self.createInAppWindow(for: controller)
        }
        
    }
    
    private func createInAppWindow(for controller: InAppMessagesViewController){
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        inAppMessageWindow = UIWindow(frame: frame)
        inAppMessageWindow?.rootViewController = controller
        inAppMessageWindow?.windowLevel = UIWindow.Level(rawValue: 2)
        inAppMessageWindow?.makeKeyAndVisible()
    }
    
    private func updateInAppMessageOnCache(_ message: InAppMessage){
        let previousMessages = DengageLocalStorage.shared.getInAppMessages()
        var updatedMessages = previousMessages.filter{$0.data.messageDetails != message.data.messageDetails}
        updatedMessages.append(message)
        DengageLocalStorage.shared.save(updatedMessages)
    }
    
    private func addInAppMessagesIfNeeded(_ messages:[InAppMessage]){
        DispatchQueue.main.async {
        var previousMessages = DengageLocalStorage.shared.getInAppMessages()
        previousMessages.append(contentsOf: messages)
           DengageLocalStorage.shared.save(messages)
        }
    }
    
    private func removeInAppMessageFromCache(_ messageId: String){
        let previousMessages = DengageLocalStorage.shared.getInAppMessages()
        DengageLocalStorage.shared.save(previousMessages.filter{($0.data.messageDetails ?? "") != messageId})
    }
    
    private var isEnabledInAppMessage:Bool{
        guard let config = self.settings.configuration,
              config.accountName != nil else {return false}
        guard config.inAppEnabled else {return false}
        return true
    }
    
    private var shouldFetchInAppMessages:Bool{
        guard isEnabledInAppMessage else {return false}
        guard let lastFetchedTime = settings.lastFetchedInAppMessageTime else {return true}
        guard Date().timeMiliseconds >= lastFetchedTime else {return false}
        return true
    }
    
    private func registerLifeCycleTrackers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func willEnterForeground(){
        fetchInAppMessages()
    }
}
//MARK: - InAppMessagesViewController Delegate
extension InAppMessageManager: InAppMessagesViewControllerDelegate{
    func didTapNotification(messageId:String?) {
        inAppMessageWindow = nil
        setInAppMessageAsClicked(messageId)
    }
    
    func didTapView(messageId:String?){
        inAppMessageWindow = nil
        setInAppMessageAsDismissed(messageId)
    }
}

//MARK: - Utils
extension InAppMessageManager{
    /**
     * Find not expired in app messages with controlling expire date and date now
     *
     * @param inAppMessages in app messages that will be filtered with expire date
     */
    private static func findNotExpiredInAppMessages(untilDate: Date,  _ inAppMessages: [InAppMessage]) -> [InAppMessage] {
        return inAppMessages.filter{ message -> Bool in
            guard let expireDate = Utilities.convertDate(to: message.data.expireDate) else {return false}
            return untilDate.compare(expireDate) != .orderedDescending
        }
    }
    
    /**
     * Find prior in app message to show with respect to priority and expireDate parameters
     */
    private func findPriorInAppMessage(inAppMessages: [InAppMessage], screenName: String? = nil) -> InAppMessage? {
        
        let inAppMessageWithoutScreenName = inAppMessages.sorted.first { message -> Bool in
            return (message.data.displayCondition.screenNameFilters ?? []).isEmpty && isDisplayTimeAvailable(for: message)
        }
        
        if let screenName = screenName, !screenName.isEmpty{
            let inAppMessageWithScreenName = inAppMessages.sorted.first { message -> Bool in
                return message.data.displayCondition.screenNameFilters?.first{ nameFilter -> Bool in
                    return operateScreenValues(value: nameFilter.value, for: screenName, operatorType: nameFilter.operatorType)
                } != nil && isDisplayTimeAvailable(for: message)
            }
            return inAppMessageWithScreenName ?? inAppMessageWithoutScreenName
        }else{
           return inAppMessageWithoutScreenName
        }
    }
    
    private func operateScreenValues(value screenNameFilterValues: [String], for screenName: String, operatorType: OperatorType) -> Bool {
        let screenNameFilter = screenNameFilterValues.first ?? ""
        switch operatorType {
        case .EQUALS:
            return screenNameFilter == screenName
        case .NOT_EQUALS:
            return screenNameFilter != screenName
        case .LIKE:
            return screenName.contains(screenNameFilter)
        case .NOT_LIKE:
            return !screenName.contains(screenNameFilter)
        case .STARTS_WITH:
            return screenName.hasPrefix(screenNameFilter)
        case .NOT_STARTS_WITH:
            return !screenName.hasPrefix(screenNameFilter)
        case .ENDS_WITH:
            return screenName.hasSuffix(screenNameFilter)
        case .NOT_ENDS_WITH:
            return !screenName.hasSuffix(screenNameFilter)
        case .IN:
           return screenNameFilterValues.contains(screenName)
        case .NOT_IN:
           return !screenNameFilterValues.contains(screenName)
        }
    }
    
    private func isDisplayTimeAvailable(for inAppMessage: InAppMessage)  -> Bool {
        return (inAppMessage.data.displayTiming.showEveryXMinutes == nil ||
                inAppMessage.data.displayTiming.showEveryXMinutes == 0 ||
                (inAppMessage.nextDisplayTime ?? Date().timeMiliseconds) <= Date().timeMiliseconds)
    }
}
