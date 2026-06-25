CREATE TABLE IF NOT EXISTS Agency (
    agencyID INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    address TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS PropertyType (
    propertyTypeID INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL CHECK (description <> '')
);

CREATE TABLE IF NOT EXISTS Property (
    propertyID INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL CHECK (name <> ''),
    address TEXT NOT NULL CHECK (address <> ''), 
    type INTEGER NOT NULL,
    value REAL NOT NULL CHECK (value > 0), 
    agencyID INTEGER NOT NULL,
    FOREIGN KEY (type) REFERENCES PropertyType(propertyTypeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (agencyID) REFERENCES Agency(agencyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Neighborhood (
    neighborhoodID INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL CHECK (name <> '') 
);

CREATE TABLE IF NOT EXISTS Location (
    latitude REAL NOT NULL CHECK (latitude BETWEEN -90 AND 90),
    longitude REAL NOT NULL CHECK (longitude BETWEEN -180 AND 180),
    neighborhoodID INTEGER NOT NULL,
    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (neighborhoodID) REFERENCES Neighborhood(neighborhoodID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Document (
    documentNumber INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL CHECK (type IN ('Title Deed', 'Lease Agreement', 'Mortgage')), 
    propertyID INTEGER NOT NULL,
    FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Client (
    clientID INTEGER PRIMARY KEY AUTOINCREMENT,
    address TEXT NOT NULL CHECK (address <> ''),
    type TEXT NOT NULL CHECK (type IN ('Individual', 'Corporate')) 
);

CREATE TABLE IF NOT EXISTS Transaction_ (
    transactionID INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL CHECK (date <= CURRENT_DATE),
    value REAL NOT NULL CHECK (value > 0),
    type TEXT NOT NULL CHECK (type IN ('Sale', 'Rent', 'Lease')), 
    clientID INTEGER NOT NULL,
    FOREIGN KEY (clientID) REFERENCES Client(clientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS TransactionHistory (
    transactionHistoryID INTEGER PRIMARY KEY AUTOINCREMENT,
    status TEXT NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Completed', 'Canceled')), 
    statusDate DATE NOT NULL CHECK (statusDate <= CURRENT_DATE), 
    transactionID INTEGER NOT NULL,
    FOREIGN KEY (transactionID) REFERENCES Transaction_(transactionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Contract_ (
    contractID INTEGER PRIMARY KEY AUTOINCREMENT,
    conditions TEXT NOT NULL CHECK (conditions <> ''), 
    value REAL NOT NULL CHECK (value >= 0), 
    deadline DATE NOT NULL CHECK (deadline > CURRENT_DATE), 
    agreedValue REAL CHECK (agreedValue >= 0),
    transactionID INTEGER NOT NULL,
    FOREIGN KEY (transactionID) REFERENCES Transaction_(transactionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Agent (
    agentID INTEGER PRIMARY KEY AUTOINCREMENT,
    transactionsNumber INTEGER NOT NULL CHECK (transactionsNumber >= 0)
);

CREATE TABLE IF NOT EXISTS AgentTransaction (
    agentTransactionID INTEGER PRIMARY KEY AUTOINCREMENT,
    agentRole TEXT NOT NULL CHECK (agentRole IN ('Buyer Agent', 'Seller Agent', 'Manager')), 
    assignedDate DATE NOT NULL CHECK (assignedDate <= CURRENT_DATE),
    transactionID INTEGER NOT NULL,
    agentID INTEGER NOT NULL,
    FOREIGN KEY (transactionID) REFERENCES Transaction_(transactionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (agentID) REFERENCES Agent(agentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Person (
    name TEXT NOT NULL CHECK (name <> ''), 
    phoneNumber TEXT NOT NULL CHECK (phoneNumber <> ''),
    email TEXT NOT NULL CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'), 
    agentID INTEGER NOT NULL,
    PRIMARY KEY (phoneNumber),
    FOREIGN KEY (agentID) REFERENCES Agent(agentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Appointment (
    appointmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    appointmentDate DATE NOT NULL CHECK (appointmentDate >= CURRENT_DATE),
    appointmentHour TIME NOT NULL,
    appointmentType TEXT NOT NULL CHECK (appointmentType IN ('Viewing', 'Negotiation', 'Inspection', 'Consultation')),
    agentID INTEGER NOT NULL,
    clientID INTEGER NOT NULL,
    FOREIGN KEY (agentID) REFERENCES Agent(agentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (clientID) REFERENCES Client(clientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Interest (
    interestID INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL CHECK (date >= CURRENT_DATE), 
    status TEXT NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'Closed', 'Pending')),
    propertyID INTEGER NOT NULL,
    FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
