import Foundation
import RealmSwift

//MARK: - UserObject
final class UserObject: Object {
    @Persisted(primaryKey: true) var id: Int = -1
    @Persisted var name: String = ""
    @Persisted var username: String = ""
    @Persisted var email: String = ""
    @Persisted var address: AddressObject?
    @Persisted var phone: String = ""
    @Persisted var website: String = ""
    @Persisted var company: CompanyObject?
    
    // MARK: - Mapping
    convenience init(from user: User) {
        self.init()
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.email = user.email
        
        let addressObj = AddressObject()
        addressObj.street = user.address.street
        addressObj.suite = user.address.suite
        addressObj.city = user.address.city
        addressObj.zipcode = user.address.zipcode
        let geoObj = GeoObject()
        geoObj.lat = user.address.geo.lat
        geoObj.lng = user.address.geo.lng
        addressObj.geo = geoObj
        self.address = addressObj
        
        self.phone = user.phone
        self.website = user.website
        
        let companyObj = CompanyObject()
        companyObj.name = user.company.name
        companyObj.catchPhrase = user.company.catchPhrase
        companyObj.bs = user.company.bs
        self.company = companyObj
    }
    
    // MARK: - To API model
    func toUser() -> User {
        return User(
            id: id,
            name: name,
            username: username,
            email: email,
            address: Address(
                street: address?.street ?? "",
                suite: address?.suite ?? "",
                city: address?.city ?? "",
                zipcode: address?.zipcode ?? "",
                geo: Geo(lat: address?.geo?.lat ?? "", lng: address?.geo?.lng ?? "")
            ),
            phone: phone,
            website: website,
            company: Company(
                name: company?.name ?? "",
                catchPhrase: company?.catchPhrase ?? "",
                bs: company?.bs ?? ""
            )
        )
    }
}

//MARK: - EmbeddedObject
class GeoObject: EmbeddedObject {
    @Persisted var lat: String = ""
    @Persisted var lng: String = ""
}

//MARK: - AddressObject
final class AddressObject: EmbeddedObject {
    @Persisted var street: String = ""
    @Persisted var suite: String = ""
    @Persisted var city: String = ""
    @Persisted var zipcode: String = ""
    @Persisted var geo: GeoObject?
}

//MARK: - CompanyObject
final class CompanyObject: EmbeddedObject {
    @Persisted var name: String = ""
    @Persisted var catchPhrase: String = ""
    @Persisted var bs: String = ""
}
