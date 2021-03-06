import XCTest
@testable import Dengage_Framework

class SettingsTests: XCTestCase {
    
    var sut : Settings = .shared
    
    var storageMock : DengageLocalStorageMock =  DengageLocalStorageMock(suitName: "dengage")
    var logMock : SDKLoggerMock = SDKLoggerMock()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = Settings.init(storage: storageMock, logger: logMock) 
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetAndGetSdkVersion() {
        sut.setSdkVersion(sdkVersion: "2.0")
        XCTAssertEqual("2.0", sut.getSdkVersion())
    }
    
    func testSetAndGetCarrierId() {
        sut.setCarrierId(carrierId: "20500")
        XCTAssertEqual("20500", sut.getCarrierId())
    }
    
    func testSetAndGetAdvertisingId() {
        sut.setAdvertisingId(advertisingId: "id")
        XCTAssertEqual("id", sut.getAdvertisinId())
    }
    
    func testSetAndGetApplicationIdentifier() {
        sut.setApplicationIdentifier(applicationIndentifier: "id")
        XCTAssertEqual("id", sut.getApplicationIdentifier())
    }
    
    func testSetAndGetDengageIntegrationKey() {
        sut.setDengageIntegrationKey(integrationKey:"id")
        XCTAssertEqual("id", sut.getDengageIntegrationKey())
    }
    
    func testSetAndGetBadgeCountReset() {
        sut.setBadgeCountReset(badgeCountReset: true)
        XCTAssertTrue(sut.getBadgeCountReset()!)
    }
    
    func testSetAndGetContactKey() {
        sut.setContactKey(contactKey: "mail_address")
        XCTAssertEqual("mail_address", sut.getContactKey())
    }
    
    func testSetAndGetContactKeyWithNil() {
        sut.setContactKey(contactKey: nil)
        XCTAssertEqual("", sut.getContactKey())
    }
    
    func testSetAndGetToken() {
        sut.setToken(token: "token")
        XCTAssertEqual("token", sut.getToken())
    }
    
    func testSetAndGetPermission() {
        sut.setPermission(permission: false)
        XCTAssertFalse(sut.getPermission()!)
    }
    
    func testSetAndGetAppversion() {
        sut.setAppVersion(appVersion: "5.0")
        let appversion = sut.getAppversion()
        XCTAssertEqual("5.0", appversion)
    }
    
    
}
