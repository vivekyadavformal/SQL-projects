CREATE DATABASE InvestmentPortfolio;
USE InvestmentPortfolio;

CREATE TABLE Investors (
    InvestorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    Phone VARCHAR(15)
);

CREATE TABLE Portfolios (
    PortfolioID INT PRIMARY KEY AUTO_INCREMENT,
    InvestorID INT NOT NULL,
    PortfolioName VARCHAR(100) NOT NULL,
    CreatedDate DATE NOT NULL, -- Will be manually set during insertion
    FOREIGN KEY (InvestorID) REFERENCES Investors(InvestorID)
);


CREATE TABLE Assets (
    AssetID INT PRIMARY KEY AUTO_INCREMENT,
    AssetType VARCHAR(50) NOT NULL,  -- e.g., Equity, Bond, etc.
    AssetName VARCHAR(100) NOT NULL
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    PortfolioID INT NOT NULL,
    AssetID INT NOT NULL,
    TransactionDate DATE NOT NULL, -- Will be manually set during insertion
    TransactionType ENUM('Buy', 'Sell') NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PricePerUnit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (PortfolioID) REFERENCES Portfolios(PortfolioID),
    FOREIGN KEY (AssetID) REFERENCES Assets(AssetID)
);


CREATE TABLE MarketPrices (
    AssetID INT NOT NULL,
    PriceDate DATE NOT NULL,
    MarketPrice DECIMAL(10, 2) NOT NULL CHECK (MarketPrice > 0),
    PRIMARY KEY (AssetID, PriceDate),
    FOREIGN KEY (AssetID) REFERENCES Assets(AssetID)
);

INSERT INTO Investors (Name, Email, Phone) VALUES
('Alice Johnson', 'alice.johnson@example.com', '1234567890'),
('Bob Smith', 'bob.smith@example.com', '0987654321'),
('Charlie Brown', 'charlie.brown@example.com', '1122334455');

INSERT INTO Portfolios (InvestorID, PortfolioName, CreatedDate) VALUES
(1, 'Growth Portfolio', '2024-01-01'),
(2, 'Retirement Portfolio', '2024-02-15'),
(3, 'Income Portfolio', '2024-03-20');

INSERT INTO Assets (AssetType, AssetName) VALUES
('Equity', 'Apple Inc.'),
('Bond', 'US Treasury Bond'),
('Mutual Fund', 'Vanguard Index Fund');

INSERT INTO Transactions (PortfolioID, AssetID, TransactionDate, TransactionType, Quantity, PricePerUnit) VALUES
(1, 1, '2024-04-01', 'Buy', 10, 150.25),
(2, 2, '2024-04-10', 'Buy', 5, 1000.00),
(3, 3, '2024-05-05', 'Sell', 8, 250.75);

INSERT INTO MarketPrices (AssetID, PriceDate, MarketPrice) VALUES
(1, '2024-04-01', 150.25),
(1, '2024-05-01', 160.00),
(2, '2024-04-10', 1000.00),
(2, '2024-05-10', 1050.00),
(3, '2024-05-05', 250.75),
(3, '2024-06-01', 260.00);

SELECT * FROM Investors;
SELECT 
    p.PortfolioID,
    p.PortfolioName,
    p.CreatedDate,
    i.Name AS InvestorName,
    i.Email AS InvestorEmail
FROM 
    Portfolios p
JOIN 
    Investors i ON p.InvestorID = i.InvestorID;

SELECT 
    t.TransactionID,
    p.PortfolioName,
    a.AssetName,
    t.TransactionDate,
    t.TransactionType,
    t.Quantity,
    t.PricePerUnit
FROM 
    Transactions t
JOIN 
    Portfolios p ON t.PortfolioID = p.PortfolioID
JOIN 
    Assets a ON t.AssetID = a.AssetID;

SELECT 
    p.PortfolioName,
    SUM(t.Quantity * t.PricePerUnit) AS TotalInvestment
FROM 
    Transactions t
JOIN 
    Portfolios p ON t.PortfolioID = p.PortfolioID
WHERE 
    t.TransactionType = 'Buy'
GROUP BY 
    p.PortfolioID, p.PortfolioName;

SELECT 
    a.AssetName,
    mp.MarketPrice,
    mp.PriceDate
FROM 
    Assets a
JOIN 
    MarketPrices mp ON a.AssetID = mp.AssetID
WHERE 
    mp.PriceDate = (SELECT MAX(PriceDate) FROM MarketPrices WHERE AssetID = a.AssetID);

INSERT INTO Investors (Name, Email, Phone) VALUES
('David Miller', 'david.miller@example.com', '5566778899'),
('Emma Davis', 'emma.davis@example.com', '6677889900'),
('Fiona Adams', 'fiona.adams@example.com', '7788990011'),
('George Clark', 'george.clark@example.com', '8899001122'),
('Hannah Baker', 'hannah.baker@example.com', '9900112233');

INSERT INTO Portfolios (InvestorID, PortfolioName, CreatedDate) VALUES
(4, 'High-Risk Portfolio', '2024-06-01'),
(5, 'Education Fund', '2024-06-15'),
(1, 'Real Estate Portfolio', '2024-07-01'),
(3, 'Healthcare Investments', '2024-07-20'),
(2, 'Diversified Assets', '2024-08-01');

INSERT INTO Assets (AssetType, AssetName) VALUES
('Real Estate', 'Downtown Apartment'),
('Cryptocurrency', 'Bitcoin'),
('Commodity', 'Gold'),
('Equity', 'Tesla Inc.'),
('Bond', 'Corporate Bond ABC');

INSERT INTO Transactions (PortfolioID, AssetID, TransactionDate, TransactionType, Quantity, PricePerUnit) VALUES
(4, 4, '2024-06-10', 'Buy', 20, 700.00),
(5, 5, '2024-06-20', 'Buy', 50, 450.00),
(1, 6, '2024-07-05', 'Buy', 1, 30000.00),
(3, 7, '2024-07-25', 'Buy', 100, 50.00),
(2, 8, '2024-08-10', 'Buy', 10, 800.00),
(4, 3, '2024-08-15', 'Sell', 5, 600.00),
(1, 2, '2024-08-20', 'Sell', 10, 900.00);


INSERT INTO MarketPrices (AssetID, PriceDate, MarketPrice) VALUES
(4, '2024-06-10', 700.00),
(5, '2024-06-20', 450.00),
(6, '2024-07-05', 30000.00),
(7, '2024-07-25', 50.00),
(8, '2024-08-10', 800.00),
(3, '2024-08-15', 600.00),
(2, '2024-08-20', 900.00),
(1, '2024-09-01', 750.00),
(5, '2024-09-01', 500.00);


SELECT * FROM Transactions;

INSERT INTO Transactions (PortfolioID, AssetID, TransactionDate, TransactionType, Quantity, PricePerUnit) VALUES
(4, 4, '2024-08-25', 'Buy', 30, 650.00),
(5, 5, '2024-08-30', 'Sell', 20, 500.00),
(6, 6, '2024-09-01', 'Buy', 5, 31000.00),
(7, 7, '2024-09-02', 'Sell', 50, 55.00),
(8, 8, '2024-09-03', 'Buy', 15, 750.00),
(1, 1, '2024-09-04', 'Sell', 8, 800.00),
(2, 2, '2024-09-05', 'Buy', 12, 450.00),
(3, 3, '2024-09-06', 'Sell', 25, 60.00),
(4, 4, '2024-09-07', 'Buy', 40, 700.00),
(5, 5, '2024-09-08', 'Sell', 10, 500.00),
(6, 6, '2024-09-09', 'Buy', 8, 32000.00),
(7, 7, '2024-09-10', 'Sell', 10, 58.00),
(8, 8, '2024-09-11', 'Buy', 20, 770.00),
(1, 1, '2024-09-12', 'Sell', 10, 810.00),
(2, 2, '2024-09-13', 'Buy', 14, 440.00),
(3, 3, '2024-09-14', 'Sell', 30, 65.00),
(4, 4, '2024-09-15', 'Buy', 25, 690.00),
(5, 5, '2024-09-16', 'Sell', 18, 510.00),
(6, 6, '2024-09-17', 'Buy', 6, 33000.00),
(7, 7, '2024-09-18', 'Sell', 20, 56.00);
