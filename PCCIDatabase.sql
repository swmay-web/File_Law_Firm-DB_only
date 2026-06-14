SET DEFINE OFF;
DROP TABLE Reminder CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS;
DROP TABLE CustomerCase CASCADE CONSTRAINTS;
DROP TABLE Document CASCADE CONSTRAINTS;
DROP TABLE Cases CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Lawyer CASCADE CONSTRAINTS;
DROP TABLE CaseType CASCADE CONSTRAINTS;

CREATE TABLE Customer (
    cusID NUMBER(4),
    cusFName VARCHAR2(30),
    cusLName VARCHAR2(30),
    cusIC VARCHAR2(14) CHECK (REGEXP_LIKE(cusIC,'^[0-9]{6}-[0-9]{2}-[0-9]{4}$')),
    cusPhone VARCHAR2(20),
    addressL1 VARCHAR2(100) NOT NULL,
    addressL2 VARCHAR2(100),
    addressL3 VARCHAR2(100),
    postcode VARCHAR2(6),
    city VARCHAR2(50) NOT NULL,
    cityState VARCHAR2(50) NOT NULL,
    country VARCHAR2(50) DEFAULT 'Malaysia',
    cusEmail VARCHAR2(50),
    CONSTRAINT Customer_cusID_PK PRIMARY KEY(cusID),
    CONSTRAINT Customer_cusEmail_UK UNIQUE(cusEmail),
    CONSTRAINT Customer_cusIC_UK UNIQUE(cusIC)
);

ALTER TABLE Customer
ADD (
    cusType VARCHAR2(20) CHECK (cusType IN('PERSON', 'COMPANY')),
    compName VARCHAR2(100),
    compRegNo VARCHAR2(30)
);

CREATE TABLE Lawyer (
    lawID NUMBER(4),
    lawFName VARCHAR2(30) NOT NULL,
    lawLName VARCHAR2(30),
    lawPhone VARCHAR2(20),
    lawEmail VARCHAR2(40) NOT NULL,
    specialization VARCHAR2(30),
    CONSTRAINT Lawyer_lawID_PK PRIMARY KEY(lawID),
    CONSTRAINT Lawyer_lawEmail_UK UNIQUE(lawEmail)
);

CREATE TABLE CaseType (
    caseTypeID NUMBER(4),
    caseTypeName VARCHAR2(50),
    CONSTRAINT CaseType_caseTypeID_PK PRIMARY KEY(caseTypeID),
    CONSTRAINT CaseType_caseTypeName_UK UNIQUE (caseTypeName)
);

-- caseNO (reference): PCCI / cusinitial/ casedetail/no/ year --
--    companyCode VARCHAR2(10) DEFAULT 'PCCI',
--    customerInitial VARCHAR2(10),
--    detail VARCHAR2(7) CHECK(detail IN('SPA', 'PBB', 'HLBB', 'HPK','TNY', 'LPPSA', 'LA', 'GP', 'DIV', 'R&R', 'D', 'MISC')),
--    runningNo NUMBER(4),
--    caseTypeID NUMBER(4),
--    caseYear NUMBER(4),
    
CREATE TABLE Cases (
    caseID NUMBER(4),
    caseTypeID NUMBER(4),
    caseNo VARCHAR2(50) NOT NULL,
    lawID NUMBER(4),
    caseTitle VARCHAR2(10) CHECK(caseTitle IN('SPA', 'PBB', 'HLBB', 'HPK','TNY', 'LPPSA', 'LA', 'GP', 'DIV', 'R&R', 'D', 'MISC')),
    opendate DATE DEFAULT SYSDATE NOT NULL,
    closedate DATE,
    statusCase VARCHAR2(20) CHECK(statusCase IN('OPEN', 'CLOSED')),
    CONSTRAINT Cases_caseID_PK PRIMARY KEY(caseID),
    CONSTRAINT Cases_caseTypeID_FK FOREIGN KEY(caseTypeID) REFERENCES CaseType(caseTypeID),
    CONSTRAINT Cases_lawID_FK FOREIGN KEY (lawID) REFERENCES Lawyer(lawID),
    CONSTRAINT Cases_caseNo_UK UNIQUE (caseNo)
);

CREATE TABLE CustomerCase (
    cuscaseID NUMBER(4),
    cusID NUMBER(4),
    caseID NUMBER(4),
    roleName VARCHAR2(25) CHECK (roleName IN('CUSTOMER', 'OTHER PARTY')),
    CONSTRAINT CustomerCase_cuscaseID_PK PRIMARY KEY (cuscaseID),
    CONSTRAINT CustomerCase_cusID_FK FOREIGN KEY (cusID) REFERENCES Customer(cusID),
    CONSTRAINT CustomerCase_caseID_FK FOREIGN KEY (caseID) REFERENCES Cases(caseID)
);

CREATE TABLE Document (
    docID NUMBER(5),
    caseID NUMBER(4),
    docType VARCHAR2(20) CHECK (docType IN('PDF', 'WORD', 'LETTER', 'CONTRACT', 'FORM')),
    docName VARCHAR2(100),
    uploadDate DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT Document_docID_PK PRIMARY KEY(docID),
    CONSTRAINT Document_caseID_FK FOREIGN KEY (caseID) REFERENCES Cases(caseID)
);

CREATE TABLE Reminder (
    remindID NUMBER(4),
    caseID NUMBER(4),
    docID NUMBER(4),
    remindDate DATE DEFAULT SYSDATE NOT NULL,
    descript VARCHAR2(200),
    currentStatus VARCHAR2(50) CHECK(currentStatus IN('DONE', 'PENDING', 'ONHOLD', 'OVERDUE', 'CANCELLED')),
    CONSTRAINT Reminder_remindID_PK PRIMARY KEY (remindID),
    CONSTRAINT Reminder_caseID_FK FOREIGN KEY (caseID) REFERENCES Cases(caseID),
    CONSTRAINT Reminder_docID_FK FOREIGN KEY (docID) REFERENCES Document(docID)
);

CREATE TABLE Payment (
    payID NUMBER(4),
    caseID NUMBER(4),
    payDate DATE DEFAULT SYSDATE NOT NULL,
    payAmount NUMBER(10,2) NOT NULL,
    payDesc VARCHAR2(100),
    payRef VARCHAR2(50), --ex: bank transfer, cash, cheque, online payment--
    payStatus VARCHAR2(10) CHECK (payStatus IN('PAID','PENDING','UNPAID')),
    CONSTRAINT Payment_payID_PK PRIMARY KEY (payID),
    CONSTRAINT Payment_caseID_FK FOREIGN KEY (caseID) REFERENCES Cases(caseID)
);

-- this is insert data for customer--
INSERT INTO Customer (cusID, cusType, cusFName, cusLName, cusIC,cusPhone, addressL1, addressL2, postcode, city, cityState, country, cusEmail)
VALUES (1, 'PERSON', 'Mei Ling', 'Lee', '190321-08-7890','019-5671234', 'Syeksyen 1/2, Jalan Orang Utan,','Taman Alam,', '31400', 'Ipoh', 'Perak','Malaysia', 'meiling@gmail.com');

INSERT INTO Customer (cusID,cusType, cusFName, cusLName, cusIC,cusPhone, addressL1, addressL2, postcode, city, cityState, country, cusEmail)
VALUES (5, 'PERSON', 'Ali', 'Mohamad Li Zahli', '191121-10-3453','011-5761784', 'Syeksyen 1/4, Jalan Orang Anjing,','Taman Seri,', '40400', 'Sekinchan', 'Selangor','Malaysia', 'ali89@gmail.com');

INSERT INTO Customer (cusID,cusType, cusFName, cusLName, cusIC,cusPhone, addressL1, addressL2, postcode, city, cityState, country, cusEmail)
VALUES (2, 'PERSON', 'Loom Hua', 'Lai', '080521-08-7890','017-9971224', '40, Jalan Sekia,','Taman Korea,', '31400', 'Ipoh', 'Perak','Malaysia', 'loomhual@gmail.com');

INSERT INTO Customer (cusID,cusType, cusFName, cusLName, cusIC,cusPhone, addressL1, addressL2, postcode, city, cityState, country, cusEmail)
VALUES (3, 'PERSON', 'Alien', 'Dust', '001201-01-8765','012-5231774', '30, Jalan Meow,','Taman GGBon,', '79600', 'Johor Bahru', 'Johor','Malaysia', 'iamalien@gmail.com');

INSERT INTO Customer (cusID, cusType,cusFName, cusLName, cusIC,cusPhone, addressL1, addressL2, postcode, city, cityState, country, cusEmail)
VALUES (4, 'PERSON','Ah Gao', 'Chong', '020514-07-4567','013-5551664', 'Syeksyen 1/3, Jalan Hospital,','Taman Patient,', '10400', 'Georgetown', 'Pulau Pinang','Malaysia', 'chongahgao@gmail.com');

INSERT INTO Customer (cusID, cusType,cusFName, cusLName, cusIC,cusPhone, addressL1, addressL2, postcode, city, cityState, country, cusEmail)
VALUES (6, 'PERSON','Fatimah', 'Nur Aisyah', '090101-06-3000','013-3369904', '28, Jalan Patriotik,','Taman Bangga,', '25900', 'Kuantan', 'Pahang','Malaysia', 'hospfatimah@gmail.com');

INSERT INTO Customer (cusID, cusType, compName, compRegNo, cusPhone, addressL1, postcode, city, cityState, country)
VALUES (7, 'COMPANY', 'ABC', 'AGH3454HN', '019-7779809', '22, JALAN BIG ROAD,', 31400, 'IPOH', 'PERAK', 'MALAYSIA');
--create data for lawyer--
INSERT INTO Lawyer (lawID, lawFName,lawLName,lawPhone, lawEmail, specialization)
VALUES (1, 'King Kong', 'Lai','017-3443234', 'kkkong@gmail.com', '');

INSERT INTO Lawyer (lawID, lawFName,lawLName,lawPhone, lawEmail, specialization)
VALUES (2, 'Finger Nail', 'Pui','015-3456204', 'fingernail@gmail.com', '');

INSERT INTO Lawyer (lawID, lawFName,lawLName,lawPhone, lawEmail, specialization)
VALUES (3, 'Pro Yay', 'Lum','017-45671234', 'iampro@gmail.com', '');

INSERT INTO Lawyer (lawID, lawFName,lawLName,lawPhone, lawEmail, specialization)
VALUES (4, 'Blue Ray', 'Loo','012-3451299', 'blueraysadfish@gmail.com', '');

INSERT INTO Lawyer (lawID, lawFName,lawLName,lawPhone, lawEmail, specialization)
VALUES (5, 'Sea King', 'Goh','010-3003200', 'haiwangg@gmail.com', '');

--create data for case type--
INSERT INTO CaseType VALUES (1,'Inheritance');
INSERT INTO CaseType VALUES (2,'Property');
INSERT INTO CaseType VALUES (3,'Family');
INSERT INTO CaseType VALUES (4,'Corporate');

--create data for cases --
INSERT INTO Cases (caseID, caseTypeID, caseNo, lawID, caseTitle, opendate, closedate, statusCase)
VALUES(1, 2, 'PCCI/LML/SPA/001/2026', 2, 'SPA', TO_DATE('03-05-2026', 'DD-MM-YYYY'), NULL, 'OPEN');

INSERT INTO Cases (caseID, caseTypeID, caseNo, lawID, caseTitle, opendate, closedate, statusCase)
VALUES(2, 1, 'PCCI/AM/LA/001/2026', 2, 'LA', TO_DATE('12-01-2026', 'DD-MM-YYYY'), NULL, 'OPEN');

INSERT INTO Cases (caseID, caseTypeID, caseNo, lawID, caseTitle, opendate, closedate, statusCase)
VALUES(3, 3, 'PCCI/AD/DIV/001/2025', 1, 'DIV', TO_DATE('13-2-2025', 'DD-MM-YYYY'), NULL, 'OPEN');

INSERT INTO Cases (caseID, caseTypeID, caseNo, lawID, caseTitle, opendate, closedate, statusCase) 
VALUES(4, 2, 'PCCI/CAG/D/001/2026', 3, 'D', TO_DATE('03-01-2026', 'DD-MM-YYYY'), TO_DATE('03-03-2026', 'DD-MM-YYYY'), 'CLOSED');

INSERT INTO Cases (caseID, caseTypeID, caseNo, lawID, caseTitle, opendate, closedate, statusCase) 
VALUES(5, 2, 'PCCI/LBR/LPPSA/023/2026', 3, 'D', TO_DATE('13-2-2026', 'DD-MM-YYYY'), NULL, 'OPEN');

INSERT INTO Cases (caseID, caseTypeID, caseNo, lawID, caseTitle, opendate, closedate, statusCase) 
VALUES(6, 2, 'PCCI/GSK/R&R/001/2025', 3, 'R&R', TO_DATE('03-12-2025', 'DD-MM-YYYY'), TO_DATE('03-03-2026', 'DD-MM-YYYY'), 'CLOSED');

--create data for customercase
INSERT INTO CustomerCase VALUES(1, 1, 1, 'CUSTOMER');
INSERT INTO CustomerCase VALUES(2, 5, 2, 'CUSTOMER');
INSERT INTO CustomerCase VALUES(3, 7, 2, 'OTHER PARTY'); -- make other company name
INSERT INTO CustomerCase VALUES(4, 3, 3, 'CUSTOMER');
INSERT INTO CustomerCase VALUES(5, 4, 4, 'CUSTOMER');
INSERT INTO CustomerCase VALUES(6, 4, 5, 'CUSTOMER');
INSERT INTO CustomerCase VALUES(7, 5, 6, 'CUSTOMER');

--create data for Document--
INSERT INTO Document VALUES (1, 1, 'PDF', 'AGREEMENT', TO_DATE('01-01-2026', 'DD-MM-YYYY'));
INSERT INTO Document VALUES (2, 1, 'WORD', 'LETTER TO GOV', TO_DATE('11-01-2026', 'DD-MM-YYYY'));
INSERT INTO Document VALUES (3, 1, 'LETTER', 'APPROVAL TO RELEASE THE PROPERTY', TO_DATE('01-01-2026', 'DD-MM-YYYY'));

--create data for Reminder--
INSERT INTO Reminder VALUES(1,1,1,TO_DATE('10-02-2026', 'DD-MM-YYYY'), NULL , 'DONE');
INSERT INTO Reminder VALUES(2,1,2,TO_DATE('17-02-2026', 'DD-MM-YYYY'), 'agreement' , 'PENDING');
INSERT INTO Reminder VALUES(3,1,3,TO_DATE('14-01-2026', 'DD-MM-YYYY'), NULL , 'ONHOLD');

--create data for Payment--
INSERT INTO Payment VALUES (2, 1, TO_DATE('02-02-2026', 'DD-MM-YYYY'), 100, 'SERVICE CHARGE', 'BANK TRANSFER', 'UNPAID');
INSERT INTO Payment VALUES (3, 2, TO_DATE('02-03-2026', 'DD-MM-YYYY'), 85.50, 'SERVICE CHARGE', 'BANK TRANSFER', 'PAID');
INSERT INTO Payment VALUES (1, 1, TO_DATE('02-01-2026', 'DD-MM-YYYY'), 100, 'SERVICE CHARGE', 'BANK TRANSFER', 'PENDING');

SET DEFINE ON;
commit;
