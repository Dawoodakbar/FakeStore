//
//  Product.swift
//  FakeStore
//
//  Created by Dawood on 18/01/2026.
//

import Foundation

// MARK: - Product Model
struct Product: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    struct Rating: Codable, Hashable {
        let rate: Double
        let count: Int
    }
    
    var imageURL: URL? {
        URL(string: image)
    }
    
    var formattedPrice: String {
        "$\(String(format: "%..2f", price))"
    }
    
    var ratingStars: String {
        String(repeating: "⭐️", count: Int(rating.rate))
    }
    
    var ratingText: String {
        "\(String(format: "%.1f", rating.rate)) (\(rating.count) reviews"
    }
    
    var categoryDisplayName: String {
        category.capitalized
    }
    
}


// MARK: - User Model

struct User: Codable, Identifiable, Hashable {
    let id: Int
    let email: String
    let username: String
    let password: String?
    let name: Name
    let address: Address
    let phone: String
    
    struct Name: Codable, Hashable {
        let firstName: String
        let lastName: String
    }
        
    struct Address: Codable, Hashable {
        let city: String
        let street: String
        let number: Int
        let zipcode: String
        let geolocation: Geolocation
        
        struct Geolocation: Codable, Hashable {
            let lat: String
            let long: String
            
            var latitude: Double? {
                Double(lat)
            }
            
            var longitude: Double? {
                Double(long)
            }
        }
    }
    
    var fullName: String {
        "\(name.firstName.capitalized) \(name.lastName.capitalized)"
    }
    
    var fullAddress: String {
        "\(address.number) \(address.street), \(address.city) \(address.zipcode)"
    }
    
    var initials: String {
        let first = name.firstName.prefix(1).uppercased()
        let last = name.lastName.prefix(1).uppercased()
        return first + last
    }
    
}


// MARK: - Cart Model

struct Cart: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let date: String
    let products: [CartProduct]
    
    struct CartProduct : Codable, Hashable, Identifiable {
        let productId: Int
        let quantity: Int
        
        var id: Int { productId }
    }
    
    
    // MARK: Computed Properties
    
    var cartDate: Date? {
        ISO8601DateFormatter().date(from: date)
    }
    
    var totalItems: Int {
        products.reduce(0) { $0 + $1.quantity }
    }
}


// MARK: - Cart with Product Details (Extended Model)

struct CartItemDetail: Identifiable, Hashable {
    let id = UUID()
    let product: Product
    let quantity: Int
    
    var subtotal: Double {
        product.price * Double(quantity)
    }
    
    var formattedSubtotal: String {
        "$\(String(format: "%.2f", subtotal))"
    }
}


// MARK: - Authentication Models

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
}


// MARK: - API Response Wrappers


struct ProductResponse: Codable {
    let products: [Product]
}

struct UserResponse: Codable {
    let users: [User]
}

struct CartResponse: Codable {
    let carts: [Cart]
}


// MARK: - Category Model

typealias Category = String

enum ProductCategory: String, Codable, CaseIterable, Identifiable {
    case electronics = "electronics"
    case jewelery = "jewlery"
    case mensClothing = "men's clothing"
    case womenClothing = "women's clothing"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .electronics: return "Electronics"
        case .jewelery: return "Jewelery"
        case .mensClothing: return "Men's Clothing"
        case .womenClothing: return "Women's Clothing"
        }
    }
    
    var icon: String {
        switch self {
        case .electronics: return "laptopcomputer"
        case .jewelery: return "sparkles"
        case .mensClothing: return "tshirt"
        case .womenClothing: return "figure.dress.line.vertical.figure"
        }
    }
}

// MARK: - Create/Update Request Models

// For POST/PUT requests to create/update products
struct ProductRequest: Codable {
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
}

// For POST/PUT requests to create/update users
struct UserRequest: Codable {
    let email: String
    let username: String
    let password: String
    let name: User.Name
    let address: User.Name
    let phone: String
}

struct CartRequest: Codable {
    let userId: Int
    let date: String
    let products: [Cart.CartProduct]
    
    init(userId: Int, date: String, products: [Cart.CartProduct]) {
        self.userId = userId
        self.date = ISO8601DateFormatter().string(from: Date())
        self.products = products
    }
}

// MARK: - 9. Sample/Mock Data (for Previews & Testing)

extension Product {
    static let sample = Product(
        id: 1,
        title: "Fjallraven - Foldsack No. 1 Backpack",
        price: 109.95,
        description: "Your perfect pack for everyday use and walks in the forest.",
        category: "men's clothing",
        image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        rating: Rating(rate: 3.9, count: 120)
    )
    
    static let samples = [
        sample,
        Product(
            id: 2,
            title: "Mens Casual Premium Slim Fit T-Shirts",
            price: 22.3,
            description: "Slim-fitting style, contrast raglan long sleeve.",
            category: "men's clothing",
            image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
            rating: Rating(rate: 4.1, count: 259)
        ),
        Product(
            id: 3,
            title: "Mens Cotton Jacket",
            price: 55.99,
            description: "Great outerwear jacket for Spring/Autumn/Winter.",
            category: "men's clothing",
            image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
            rating: Rating(rate: 4.7, count: 500)
        )
    ]
}

extension User {
    static let sample = User(
        id: 1,
        email: "john@gmail.com",
        username: "johnd",
        password: nil,
        name: User.Name(firstName: "john", lastName: "doe"),
        address: User.Address(
            city: "kilcoole",
            street: "7835 new road",
            number: 3,
            zipcode: "12926-3874",
            geolocation: User.Address.Geolocation(lat: "-37.3159", long: "81.1496")
        ),
        phone: "1-570-236-7033"
    )
}

extension Cart {
    static let sample = Cart(
        id: 1,
        userId: 1,
        date: "2020-03-02T00:00:00.000Z",
        products: [
            Cart.CartProduct(productId: 1, quantity: 4),
            Cart.CartProduct(productId: 2, quantity: 1)
        ]
    )
}
