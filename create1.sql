CREATE TABLE IF NOT EXISTS Agency (
    agencyID INTEGER NOT NULL,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    PRIMARY KEY (agencyID)
);

CREATE TABLE IF NOT EXISTS PropertyType (
    propertyTypeID INTEGER NOT NULL,
    description TEXT NOT NULL CHECK (description <> ''), 
    PRIMARY KEY (propertyTypeID)
);

CREATE TABLE IF NOT EXISTS Property (
    propertyID INTEGER NOT NULL,
    name TEXT NOT NULL CHECK (name <> ''),
    address TEXT NOT NULL CHECK (address <> ''), 
    type INTEGER NOT NULL,
    value REAL NOT NULL CHECK (value > 0), 
    agencyID INTEGER NOT NULL,
    PRIMARY KEY (propertyID),
    FOREIGN KEY (type) REFERENCES PropertyType(propertyTypeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (agencyID) REFERENCES Agency(agencyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Neighborhood (
    neighborhoodID INTEGER NOT NULL,
    name TEXT NOT NULL CHECK (name <> ''),
    PRIMARY KEY (neighborhoodID)
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
    documentNumber INTEGER NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('Title Deed', 'Lease Agreement', 'Mortgage')),
    propertyID INTEGER NOT NULL,
    PRIMARY KEY (documentNumber),
    FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Client (
    clientID INTEGER NOT NULL,
    address TEXT NOT NULL CHECK (address <> ''),
    type TEXT NOT NULL CHECK (type IN ('Individual', 'Corporate')),
    PRIMARY KEY (clientID)
);

CREATE TABLE IF NOT EXISTS Transaction_ (
    transactionID INTEGER NOT NULL,
    date DATE NOT NULL CHECK (date <= CURRENT_DATE),
    value REAL NOT NULL CHECK (value > 0),
    type TEXT NOT NULL CHECK (type IN ('Sale', 'Rent', 'Lease')),
    clientID INTEGER NOT NULL,
    PRIMARY KEY (transactionID),
    FOREIGN KEY (clientID) REFERENCES Client(clientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS TransactionHistory (
    transactionHistoryID INTEGER NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('Pending', 'Completed', 'Canceled')), 
    statusDate DATE NOT NULL CHECK (statusDate <= CURRENT_DATE),
    transactionID INTEGER NOT NULL,
    PRIMARY KEY (transactionHistoryID),
    FOREIGN KEY (transactionID) REFERENCES Transaction_(transactionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Contract_ (
    contractID INTEGER NOT NULL,
    conditions TEXT NOT NULL CHECK (conditions <> ''),
    value REAL NOT NULL CHECK (value >= 0), 
    deadline DATE NOT NULL CHECK (deadline > CURRENT_DATE),
    agreedValue REAL CHECK (agreedValue >= 0),
    transactionID INTEGER NOT NULL,
    PRIMARY KEY (contractID),
    FOREIGN KEY (transactionID) REFERENCES Transaction_(transactionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Agent (
    agentID INTEGER NOT NULL,
    transactionsNumber INTEGER NOT NULL CHECK (transactionsNumber >= 0),
    PRIMARY KEY (agentID)
);

CREATE TABLE IF NOT EXISTS AgentTransaction (
    agentTransactionID INTEGER NOT NULL,
    agentRole TEXT NOT NULL CHECK (agentRole IN ('Buyer Agent', 'Seller Agent', 'Manager')),
    assignedDate DATE NOT NULL CHECK (assignedDate <= CURRENT_DATE),
    transactionID INTEGER NOT NULL,
    agentID INTEGER NOT NULL,
    PRIMARY KEY (agentTransactionID),
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
    email TEXT NOT NULL CHECK (email LIKE '%_@__%.__%'),
    agentID INTEGER NOT NULL,
    PRIMARY KEY (phoneNumber),
    FOREIGN KEY (agentID) REFERENCES Agent(agentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Appointment (
    appointmentID INTEGER NOT NULL,
    appointmentDate DATE NOT NULL CHECK (appointmentDate >= CURRENT_DATE), 
    appointmentHour TIME NOT NULL,
    appointmentType TEXT NOT NULL CHECK (appointmentType IN ('Viewing', 'Negotiation', 'Inspection', 'Consultation')),
    agentID INTEGER NOT NULL,
    clientID INTEGER NOT NULL,
    PRIMARY KEY (appointmentID),
    FOREIGN KEY (agentID) REFERENCES Agent(agentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (clientID) REFERENCES Client(clientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Interest (
    interestID INTEGER NOT NULL,
    date DATE NOT NULL CHECK (date >= CURRENT_DATE), 
    status TEXT NOT NULL CHECK (status IN ('Active', 'Closed', 'Pending')),
    propertyID INTEGER NOT NULL,
    PRIMARY KEY (interestID),
    FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
