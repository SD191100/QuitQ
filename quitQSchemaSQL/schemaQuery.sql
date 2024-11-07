USE QuitQ;
GO

-- Users Table with Role attribute
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY,
    Username NVARCHAR(50) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(255),
    Role NVARCHAR(20) CHECK (Role IN ('Customer', 'Seller', 'Admin')) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Active' -- 'Active' or 'Deactivated'
);

-- SellerDetails Table to store seller-specific information
CREATE TABLE SellerDetails (
    SellerDetailID INT PRIMARY KEY IDENTITY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID), -- Links to Users table where Role = 'Seller'
    CompanyName NVARCHAR(100) NOT NULL,
    GSTNumber NVARCHAR(20) UNIQUE NOT NULL, -- GST number for tax purposes     
    BusinessAddress NVARCHAR(255),
    BusinessPhone NVARCHAR(20),
    BankAccountNumber NVARCHAR(50),
    IFSCCode NVARCHAR(20),
);

-- Products Table with UserID as foreign key to Users table for seller tracking
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID), -- UserID refers to the seller
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    Price DECIMAL(10, 2) NOT NULL,
    Image NVARCHAR(255)
);

-- ProductInventory Table to track stock and availability for each product
CREATE TABLE ProductInventory (
    InventoryID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),  
    Stock INT NOT NULL, -- Current stock level
    ReorderLevel INT DEFAULT 10, -- Minimum stock before restocking
    LastRestockedDate DATETIME, -- Date when the product was last restocked
    AvailabilityStatus NVARCHAR(20) DEFAULT 'In Stock', -- 'In Stock', 'Out of Stock', 'Discontinued'
    LastUpdated DATETIME DEFAULT GETDATE() -- Tracks when the inventory was last updated
);

-- Orders Table for customer orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID), -- Refers to customer placing the order
    OrderDate DATETIME,
    ShippingAddress NVARCHAR(255),
    TotalAmount DECIMAL(10, 2),
    Status NVARCHAR(50) -- e.g., 'Pending', 'Shipped', 'Delivered'
);

-- OrderItems Table to store products within each order
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    Price DECIMAL(10, 2)
);

-- Carts Table for user carts
CREATE TABLE Carts (
    CartID INT PRIMARY KEY IDENTITY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID), -- Refers to the user who owns the cart
    TotalAmount DECIMAL(10, 2)
);

-- CartItems Table to store items within each cart
CREATE TABLE CartItems (
    CartItemID INT PRIMARY KEY IDENTITY,
    CartID INT FOREIGN KEY REFERENCES Carts(CartID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT
);

-- Categories Table managed by Admin to categorize products
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    CreatedByUserID INT FOREIGN KEY REFERENCES Users(UserID), -- Tracks admin who created or modified
    LastModifiedDate DATETIME DEFAULT GETDATE()
);

