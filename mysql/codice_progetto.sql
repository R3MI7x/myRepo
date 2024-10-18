############################################################################
################     Codice per progetto BDSI 2023/2024   #################
############################################################################
#
# GRUPPO FORMATO DA:
#
# Matricola: 7046908       Cognome:     Guarnieri         Nome:     Rafael
############################################################################

DROP DATABASE IF EXISTS DBFlowerCorp;
CREATE DATABASE DBFlowerCorp;
USE DBFlowerCorp;
SET GLOBAL local_infile = 1;


############################################################################
################   Creazione schema e vincoli database     #################
############################################################################
CREATE TABLE IF NOT EXISTS Sede(
  nome_sede varchar(25) NOT NULL,
  via_sede varchar(25) NOT NULL,
  città varchar(15),
  cap int,
  telefono int UNIQUE,
  PRIMARY KEY (nome_sede, via_sede),
  INDEX idx_sede (nome_sede, via_sede)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Dipendente(
  cod_fiscale char(16) primary key,
  ore_lavoro int,
  stipendio decimal(8,3),
  ruolo enum ('Direttore', 'Amministrativo', 'Tecnico', 'Magazziniere'),
  nome_sede varchar(25),
  via_sede varchar(25),
  FOREIGN KEY (nome_sede, via_sede) REFERENCES Sede(nome_sede, via_sede)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Dati_anagrafici(
    cod_fiscale char(16) primary key,
    nome varchar(15),
    cognome varchar(15),
    città varchar(15),
    cap int,
    telefono int UNIQUE,
    via varchar(25),
    FOREIGN KEY (cod_fiscale) REFERENCES Dipendente(cod_fiscale)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Clienti(
    cod_cliente char(16) primary key,
    nome varchar(15),
    cognome varchar(15),
    tipo enum ('Privato', 'Azienda'),
    cod_fiscale char(16) UNIQUE,
    p_iva varchar(16) UNIQUE

) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Ordine(
    id_ordine char(16) primary key,
    metodo_pagamento enum ('Carta', 'Contanti', 'Bonifico'),
    data_ordine date,
    cod_cliente char(16),
	FOREIGN KEY (cod_cliente) REFERENCES Clienti(cod_cliente)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Serra(
    codice_serra varchar(10) primary key,
    superfice decimal(8,3),
    temperatura decimal(8,3),
    umidità decimal(8,3)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Strumento(
    codice_strumento char(10) primary key,
    nome varchar (20),
    prezzo decimal(8,3),
    codice_serra varchar(10),
    FOREIGN KEY (codice_serra) REFERENCES Serra(codice_serra)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Piante(
    codice_serra varchar(10),
    nome_pianta varchar(15),
    specie varchar (20),
    nome_sede varchar(25),
    via_sede varchar(25),
    quantità int,
    tipologia enum ('Annuali', 'Perenni'),
    costo_iniziale decimal(8,3),
    costo_mantenimento decimal(8,3),
    fiorite enum ('Si', 'No') default 'No',
    colore varchar (15),
    data_semina date, -- data di arrivo in sede
    id_ordine char(16),
    PRIMARY KEY (nome_pianta, specie, codice_serra),
	INDEX idx_piante (nome_pianta, specie, codice_serra),
    FOREIGN KEY (id_ordine) REFERENCES Ordine(id_ordine),
    FOREIGN KEY (codice_serra) REFERENCES Serra(codice_serra),
    FOREIGN KEY (nome_sede, via_sede ) REFERENCES Sede(nome_sede, via_sede)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Listino(
    nome_pianta varchar(15),
    specie varchar (20),
    codice_serra varchar(10),
    PRIMARY KEY (nome_pianta, specie, codice_serra),
    prezzo_ingrosso decimal(8,3),
    prezzo_dettaglio decimal(8,3),
    FOREIGN KEY (nome_pianta, specie, codice_serra) REFERENCES Piante(nome_pianta, specie, codice_serra)
    ) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Disponibilità(
   codice_fiscale char(16),
   codice_strumento char(10),
   FOREIGN KEY (codice_fiscale) REFERENCES Dipendente(cod_fiscale),
   FOREIGN KEY (codice_strumento) REFERENCES Strumento(codice_strumento)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Erogazione(
    nome_sede varchar(25),
    via_sede varchar(25),
    id_ordine char(16),
    FOREIGN KEY (nome_sede, via_sede) REFERENCES Sede(nome_sede,via_sede),
    FOREIGN KEY (id_ordine) REFERENCES Ordine(id_ordine)
) ENGINE=INNODB;


############################################################################
################  Creazione istanza: popolamento database  #################
############################################################################

INSERT INTO Sede VALUES
('FlowerCorp Firenze', 'Via lungarno 12', 'Firenze', 50122, 055697226),
('FlowerCorp Milano','Via San Bartolomeo 13', 'Milano', 20107, 055326441),
('FlowerCorp Lecce','Via dei cento 67', 'Lecce', 73100, 055986524),
('FlowerCorp Roma', 'Via Bartolomeo 34', 'Roma', 00118, 055663985);


INSERT INTO Dipendente (cod_fiscale, ore_lavoro, stipendio, ruolo, nome_sede, via_sede) VALUES
('RSSMRA85641H501Z', null, 2200.00, 'Direttore', 'FlowerCorp Firenze', 'Via lungarno 12'),
('RSSMRA48M01H501Z', null, 2200.00, 'Direttore', 'FlowerCorp Roma', 'Via Bartolomeo 34'),
('RSSMRA86M01H501Z', null, 2200.00, 'Direttore', 'FlowerCorp Lecce', 'Via dei cento 67'),
('BSSMRA86M01H501Z', null, 2200.00, 'Direttore', 'FlowerCorp Milano', 'Via San Bartolomeo 13'),
('RSSMRA85M01H501Z', null, 1500.00, 'Amministrativo', 'FlowerCorp Firenze', 'Via lungarno 12'),
('VRDLGI80A01F205Z', null, 1850.00, 'Tecnico', 'FlowerCorp Firenze', 'Via lungarno 12'),
('BNCLRD76T10F205Z', 45, null, 'Magazziniere', 'FlowerCorp Firenze', 'Via lungarno 12'),
('FRNCNT90A01H501Z', null, 1500.00, 'Amministrativo', 'FlowerCorp Milano', 'Via San Bartolomeo 13'),
('PLZMRL85M10F205Z', null, 1850.00, 'Tecnico', 'FlowerCorp Milano', 'Via San Bartolomeo 13'),
('MNTSRO80A01H501Z', 42, null, 'Magazziniere', 'FlowerCorp Milano', 'Via San Bartolomeo 13'),
('BLCMRA88T01F205Z', null, 1500.00, 'Amministrativo', 'FlowerCorp Lecce', 'Via dei cento 67'),
('MNCLGI79A01H501Z', null, 1850.00, 'Tecnico', 'FlowerCorp Lecce', 'Via dei cento 67'),
('RSSTRO85M01F205Z', 52, null, 'Magazziniere', 'FlowerCorp Lecce', 'Via dei cento 67'),
('CNTLBR78A01F505Z', null, 1500.00, 'Amministrativo', 'FlowerCorp Roma', 'Via Bartolomeo 34'),
('CNTLBR78A01F215Z', null, 1850.00, 'Tecnico', 'FlowerCorp Roma', 'Via Bartolomeo 34'),
('CNTLBR78A01F205Z', 39, null, 'Magazziniere', 'FlowerCorp Roma', 'Via Bartolomeo 34');

INSERT INTO Dati_anagrafici (cod_fiscale, nome, cognome, città, cap, telefono, via) VALUES
('RSSMRA85641H501Z', 'Maria', 'Rossi', 'Firenze', 50100, 1234567890, 'Via Felice 12'),
('RSSMRA48M01H501Z', 'Mario', 'Rossi', 'Roma', 00100, 1234567891, 'Via Comodo 34'),
('RSSMRA86M01H501Z', 'Marco', 'Rossi', 'Lecce', 73100, 1234567892, 'Via dei cento 1'),
('BSSMRA86M01H501Z', 'Luca', 'Bianchi', 'Milano', 20100, 1234567893, 'Via San Agostino 13'),
('RSSMRA85M01H501Z', 'Sara', 'Rossi', 'Firenze', 50100, 1234567894, 'Via lungotreno 11'),
('VRDLGI80A01F205Z', 'Giorgio', 'Verdi', 'Firenze', 50100, 1234567895, 'Via della Posta 12'),
('BNCLRD76T10F205Z', 'Leonardo', 'Bianchi', 'Firenze', 50100, 1234567896, 'Via lungarno 16'),
('FRNCNT90A01H501Z', 'Francesco', 'Ferrari', 'Milano', 20100, 1234567897, 'Via Del Accoglienza 9'),
('PLZMRL85M10F205Z', 'Mario', 'Palazzi', 'Milano', 20100, 1234567898, 'Via Bartolomeo 3'),
('MNTSRO80A01H501Z', 'Sergio', 'Monti', 'Milano', 20100, 1234567899, 'Via Bartolomeo 2'),
('BLCMRA88T01F205Z', 'Marco', 'Blanco', 'Lecce', 73100, 1234567800, 'Via cento 66'),
('MNCLGI79A01H501Z', 'Gianni', 'Mancini', 'Lecce', 73100, 1234567801, 'Via cento 101'),
('RSSTRO85M01F205Z', 'Roberto', 'Rossi', 'Lecce', 73100, 1234567802, 'Via dei tanti 77'),
('CNTLBR78A01F505Z', 'Laura', 'Conti', 'Roma', 00100, 1234567803, 'Via sopra 44'),
('CNTLBR78A01F215Z', 'Lorenzo', 'Conti', 'Roma', 00100, 1234567804, 'Via sotto 54'),
('CNTLBR78A01F205Z', 'Luigi', 'Conti', 'Roma', 00100, 1234567805, 'Via dei Ciliegi 34');


/*INTO TABLE Clienti   
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '|'
LINES TERMINATED BY '\r\n'
IGNORE 3 LINES;
*/
INSERT INTO Clienti (cod_cliente, nome, cognome, tipo, cod_fiscale, p_iva) VALUES
('CLT001', 'Giovanni', 'Verdi', 'Privato', 'VRDGNN85M01H501Z', NULL),
('CLT002', 'Luca', 'Rossi', 'Privato', 'RSSLCU80A01H501Z', NULL),
('CLT003', 'Sara', 'Bianchi', 'Privato', 'BCHSRA85T01H501Z', NULL),
('CLT004', 'Alessandro', 'Ferrari', 'Azienda', NULL, 'IT12345678901'),
('CLT005', 'Giovanna', 'Gialli', 'Azienda', NULL, 'IT23456789012'),
('CLT006', 'Silvia', 'Rossi', 'Privato', 'RSSSLV70A01H501Z', NULL),
('CLT007', 'Mario', 'Neri', 'Azienda', NULL, 'IT34567890123'),
('CLT008', 'Francesca', 'Marini', 'Privato', 'MRNFRC90A01H501Z', NULL),
('CLT009', 'Paolo', 'Sartori', 'Azienda', NULL, 'IT45678901234'),
('CLT010', 'Martina', 'Colombo', 'Privato', 'CLBMTN95T01H501Z', NULL),
('CLT011', 'Stefano', 'Bianchi', 'Azienda', NULL, 'IT56789012345'),
('CLT012', 'Giulia', 'Gori', 'Privato', 'GRGLIA80A01H501Z', NULL);

INSERT INTO Ordine (id_ordine, metodo_pagamento, data_ordine, cod_cliente) VALUES
('ORD001', 'Carta', '2023-01-15', 'CLT001'),
('ORD002', 'Bonifico', '2023-02-20', 'CLT002'),
('ORD003', 'Contanti', '2023-03-10', 'CLT003'),
('ORD004', 'Carta', '2023-04-05', 'CLT004'),
('ORD005', 'Bonifico', '2024-05-12', 'CLT005'),
('ORD006', 'Carta', '2024-06-07', 'CLT006'),
('ORD007', 'Contanti', '2024-07-25', 'CLT007'),
('ORD008', 'Bonifico', '2024-08-16', 'CLT008'),
('ORD009', 'Carta', '2024-09-09', 'CLT009'),
('ORD010', 'Contanti', '2024-10-01', 'CLT010'),
('ORD011', 'Bonifico', '2024-11-13', 'CLT011'),
('ORD012', 'Carta', '2024-12-20', 'CLT012');

INSERT INTO Serra (codice_serra, superfice, temperatura, umidità) VALUES
('SRR001', 500.25, 22.5, 60.0),
('SRR002', 350.50, 24.0, 55.0),
('SRR003', 400.75, 21.0, 65.0),
('SRR004', 300.00, 23.5, 62.0),
('SRR005', 450.30, 20.0, 58.0),
('SRR006', 475.10, 22.0, 63.0),
('SRR007', 390.00, 19.5, 57.0),
('SRR008', 410.25, 24.5, 61.0),
('SRR009', 380.75, 23.0, 59.0),
('SRR010', 440.50, 25.0, 64.0);

INSERT INTO Strumento (codice_strumento, nome, prezzo, codice_serra) VALUES
('ANN001', 'Annaffiatoio', 25.50, 'SRR001'),
('ANN002', 'Annaffiatoio', 25.50, 'SRR001'),
('ANN003', 'Annaffiatoio', 25.50, 'SRR001'),
('ANN004', 'Annaffiatoio', 25.50, 'SRR001'),
('TUB001', 'Tubo', 15.75, 'SRR002'),
('PAL001', 'Pala', 40.00, 'SRR001'),
('PAL002', 'Pala', 40.00, 'SRR002'),
('PAL003', 'Pala', 40.00, 'SRR003'),
('PAL004', 'Pala', 40.00, 'SRR004'),
('FFB001', 'Forbice', 35.80, 'SRR001'),
('FFB002', 'Forbice', 35.80, 'SRR002'),
('FFB003', 'Forbice', 35.80, 'SRR003'),
('FFB004', 'Forbice', 35.80, 'SRR004'),
('CCE001', 'Concimatore', 50.25, 'SRR005'),
('CCE002', 'Concimatore', 50.25, 'SRR006'),
('RLL001', 'Rastrello', 30.50, 'SRR007'),
('ZPA001', 'Zappa', 45.60, 'SRR008'),
('PPA001', 'Pompa', 80.75, 'SRR009'),
('FTO001', 'Falcetto', 22.40, 'SRR010');

/*LOAD DATA LOCAL INFILE 'popolamento_piante.in'
INTO TABLE Piante
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '|'
LINES TERMINATED BY '\r\n'
IGNORE 3 LINES;
*/

INSERT INTO Piante (codice_serra, nome_pianta, specie, nome_sede, via_sede, quantità, tipologia, costo_iniziale, costo_mantenimento, fiorite, colore, data_semina, id_ordine) VALUES
('SRR001', 'Rosa', 'Rosa', 'FlowerCorp Firenze', 'Via lungarno 12', 10, 'Annuali', 100.00, 10.00, 'Si', 'Rosso', '2023-03-15', 'ORD001'),
('SRR001', 'Tulipano', 'Tulipa', 'FlowerCorp Firenze', 'Via lungarno 12', 20, 'Annuali', 75.00, 5.00, 'Si', 'Giallo', '2023-04-10', 'ORD002'),
('SRR002', 'Girasole', 'Helianthus', 'FlowerCorp Milano', 'Via San Bartolomeo 13', 15, 'Annuali', 50.00, 8.00, 'Si', 'Giallo', '2023-05-20', 'ORD003'),
('SRR002', 'Lillà', 'Syringa', 'FlowerCorp Milano', 'Via San Bartolomeo 13', 5, 'Perenni', 120.00, 15.00, 'Si', 'Viola', NULL, 'ORD004'),
('SRR003', 'Orchidea', 'Orchidaceae', 'FlowerCorp Lecce', 'Via dei cento 67', 8, 'Perenni', 200.00, 20.00, 'Si', 'Rosa', NULL, 'ORD005'),
('SRR003', 'Margherita', 'Bellis', 'FlowerCorp Lecce', 'Via dei cento 67', 25, 'Annuali', 45.00, 6.00, 'Si', 'Bianco', '2023-02-25', 'ORD006'),
('SRR004', 'Geranio', 'Pelargonium', 'FlowerCorp Roma', 'Via Bartolomeo 34', 12, 'Annuali', 90.00, 12.00, 'Si', 'Rosso', '2023-06-01', 'ORD007'),
('SRR004', 'Ibisco', 'Hibiscus', 'FlowerCorp Roma', 'Via Bartolomeo 34', 7, 'Perenni', 130.00, 18.00, 'Si', 'Rosa', NULL, 'ORD008'),
('SRR005', 'Crisantemo', 'Chrysanthemum', 'FlowerCorp Firenze', 'Via lungarno 12', 18, 'Annuali', 60.00, 7.00, 'Si', 'Giallo', '2023-07-15', 'ORD009'),
('SRR005', 'Giglio', 'Lilium', 'FlowerCorp Firenze', 'Via lungarno 12', 6, 'Perenni', 110.00, 14.00, 'Si', 'Bianco', NULL, 'ORD010'),
('SRR006', 'Camomilla', 'Matricaria', 'FlowerCorp Milano', 'Via San Bartolomeo 13', 30, 'Annuali', 40.00, 5.50, 'Si', 'Bianco', '2023-08-10', 'ORD011'),
('SRR006', 'Lantana', 'Lantana', 'FlowerCorp Milano', 'Via San Bartolomeo 13', 12, 'Perenni', 150.00, 20.00, 'Si', 'Arancione', NULL, 'ORD012'),
('SRR007', 'Petunia', 'Petunia', 'FlowerCorp Lecce', 'Via dei cento 67', 22, 'Annuali', 70.00, 9.00, 'Si', 'Viola', '2023-09-05', 'ORD012'),
('SRR007', 'Echinacea', 'Echinacea', 'FlowerCorp Lecce', 'Via dei cento 67', 10, 'Perenni', 140.00, 16.00, 'Si', 'Rosa', NULL, 'ORD012'),
('SRR008', 'Azalea', 'Rhododendron', 'FlowerCorp Roma', 'Via Bartolomeo 34', 9, 'Perenni', 160.00, 22.00, 'Si', 'Rosso', NULL, 'ORD011'),
('SRR008', 'Violetta', 'Viola', 'FlowerCorp Roma', 'Via Bartolomeo 34', 20, 'Annuali', 55.00, 7.50, 'Si', 'Viola', '2023-10-10', 'ORD011'),
('SRR009', 'Lobelia', 'Lobelia', 'FlowerCorp Firenze', 'Via lungarno 12', 17, 'Annuali', 65.00, 8.50, 'Si', 'Blu', '2023-11-01', 'ORD010'),
('SRR009', 'Hibiscus', 'Hibiscus', 'FlowerCorp Firenze', 'Via lungarno 12', 8, 'Perenni', 170.00, 21.00, 'Si', 'Rosso', NULL, 'ORD010'),
('SRR010', 'Salvia', 'Salvia', 'FlowerCorp Milano', 'Via San Bartolomeo 13', 11, 'Perenni', 130.00, 17.00, 'Si', 'Blu', NULL, 'ORD010'),
('SRR010', 'Lupino', 'Lupinus', 'FlowerCorp Milano', 'Via San Bartolomeo 13', 14, 'Annuali', 85.00, 10.00, 'Si', 'Giallo', '2023-12-01', 'ORD010');

/*
LOAD DATA LOCAL INFILE 'popolamento_listino.in'
INTO TABLE Listino
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '|'
LINES TERMINATED BY '\r\n'
IGNORE 3 LINES;
*/
INSERT INTO Listino (nome_pianta, specie, codice_serra, prezzo_ingrosso, prezzo_dettaglio) VALUES
('Rosa', 'Rosa', 'SRR001', 120.00, 150.00),
('Tulipano', 'Tulipa', 'SRR001', 90.00, 115.00),
('Girasole', 'Helianthus', 'SRR002', 60.00, 85.00),
('Lillà', 'Syringa', 'SRR002', 140.00, 180.00),
('Orchidea', 'Orchidaceae', 'SRR003', 250.00, 300.00),
('Margherita', 'Bellis', 'SRR003', 50.00, 65.00),
('Geranio', 'Pelargonium', 'SRR004', 100.00, 130.00),
('Ibisco', 'Hibiscus', 'SRR004', 160.00, 200.00),
('Crisantemo', 'Chrysanthemum', 'SRR005', 70.00, 90.00),
('Giglio', 'Lilium', 'SRR005', 130.00, 160.00),
('Camomilla', 'Matricaria', 'SRR006', 45.00, 60.00),
('Lantana', 'Lantana', 'SRR006', 155.00, 200.00),
('Petunia', 'Petunia', 'SRR007', 75.00, 100.00),
('Echinacea', 'Echinacea', 'SRR007', 145.00, 190.00),
('Azalea', 'Rhododendron', 'SRR008', 170.00, 220.00),
('Violetta', 'Viola', 'SRR008', 60.00, 80.00),
('Lobelia', 'Lobelia', 'SRR009', 70.00, 90.00),
('Hibiscus', 'Hibiscus', 'SRR009', 180.00, 230.00),
('Salvia', 'Salvia', 'SRR010', 140.00, 180.00),
('Lupino', 'Lupinus', 'SRR010', 95.00, 120.00);


INSERT INTO Erogazione (nome_sede, via_sede, id_ordine) VALUES
('FlowerCorp Firenze', 'Via lungarno 12', 'ORD001'),
('FlowerCorp Milano', 'Via San Bartolomeo 13', 'ORD002'),
('FlowerCorp Lecce', 'Via dei cento 67', 'ORD003'),
('FlowerCorp Roma', 'Via Bartolomeo 34', 'ORD004'),
('FlowerCorp Firenze', 'Via lungarno 12', 'ORD005'),
('FlowerCorp Milano', 'Via San Bartolomeo 13', 'ORD006'),
('FlowerCorp Lecce', 'Via dei cento 67', 'ORD007'),
('FlowerCorp Roma', 'Via Bartolomeo 34', 'ORD008'),
('FlowerCorp Firenze', 'Via lungarno 12', 'ORD009'),
('FlowerCorp Milano', 'Via San Bartolomeo 13', 'ORD010'),
('FlowerCorp Lecce', 'Via dei cento 67', 'ORD011'),
('FlowerCorp Roma', 'Via Bartolomeo 34', 'ORD012');


INSERT INTO Disponibilità (codice_fiscale, codice_strumento) VALUES
('VRDLGI80A01F205Z', 'ANN001'),
('VRDLGI80A01F205Z', 'ANN002'),
('VRDLGI80A01F205Z', 'ANN003'),
('VRDLGI80A01F205Z', 'ANN004'),
('PLZMRL85M10F205Z', 'TUB001'),
('PLZMRL85M10F205Z', 'PAL001'),
('PLZMRL85M10F205Z', 'PAL002'),
('MNCLGI79A01H501Z', 'PAL003'),
('MNCLGI79A01H501Z', 'PAL004'),
('CNTLBR78A01F205Z', 'CCE001'),
('CNTLBR78A01F205Z', 'CCE002'),
('CNTLBR78A01F205Z', 'RLL001'),
('CNTLBR78A01F205Z', 'ZPA001'),
('CNTLBR78A01F205Z', 'PPA001'),
('CNTLBR78A01F205Z', 'FTO001');


##############################################################################
################  Ulteriori vincoli tramite viste e/o trigger ################
##############################################################################


DROP TRIGGER IF EXISTS assegnaStipendio;
DELIMITER $$
CREATE TRIGGER assegnaStipendio
BEFORE INSERT ON Dipendente
FOR EACH ROW
BEGIN
IF (NEW.ruolo ='Direttore') THEN SET NEW.stipendio = 2200.00;
ELSEIF (NEW.ruolo = 'Tecnico') THEN SET NEW.stipendio = 1850.00;
ELSEIF(NEW.ruolo = 'Amministrativo') THEN SET NEW.stipendio = 1500.00;
ELSEIF(NEW.ruolo = 'Magazziniere') THEN SET NEW.stipendio = NULL;
END IF ;
END $$
DELIMITER ;

# verifico se lo stipendio viene impostato correttamente
insert into Dipendente (cod_fiscale, ruolo, nome_sede, via_sede) values ('CDDDBR78A01F205Z', 'Amministrativo','FlowerCorp Firenze', 'Via lungarno 12' );
select * from Dipendente where cod_fiscale = 'CDDDBR78A01F205Z';
delete from Dipendente where cod_fiscale = 'CDDDBR78A01F205Z';


###############################################

DROP TRIGGER IF EXISTS controlloDirettore;
DELIMITER $$
CREATE TRIGGER controlloDirettore
BEFORE INSERT ON Dipendente
FOR EACH ROW
BEGIN
IF NEW.ruolo = 'Direttore' THEN         
IF (SELECT COUNT(*)                   -- Verifica se esiste già un Direttore nella stessa sede
FROM Dipendente 
WHERE nome_sede = NEW.nome_sede 
AND via_sede = NEW.via_sede 
AND ruolo = 'Direttore') > 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Un direttore è già presente per questa sede';          -- Se esiste già un Direttore, genera un errore
END IF;
END IF;
END $$
DELIMITER ;

# Provo ad inserire un altro Direttore in una sede dove ne è già presente uno
INSERT INTO Dipendente (cod_fiscale, ore_lavoro, stipendio, ruolo, nome_sede, via_sede) VALUES
('CCSMRA85641H500M', null, 2200.00, 'Direttore', 'FlowerCorp Firenze', 'Via lungarno 12');

#################################################

DROP TRIGGER IF EXISTS ControlloCliente;
DELIMITER $$
CREATE TRIGGER ControlloCliente
BEFORE INSERT ON Clienti
FOR EACH ROW
BEGIN
IF NEW.tipo = 'Privato' THEN 				 -- Controllo per clienti di tipo Privato
IF NEW.cod_fiscale IS NULL OR NEW.p_iva IS NOT NULL THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Un cliente di tipo Privato deve avere codice fiscale e non deve avere partita IVA.';
END IF;
ELSEIF NEW.tipo = 'Azienda' THEN 			 -- Controllo per clienti di tipo Azienda
IF NEW.cod_fiscale IS NOT NULL OR NEW.p_iva IS NULL THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Un cliente di tipo Azienda deve avere partita IVA e non deve avere codice fiscale.';
END IF;
END IF;
END $$
DELIMITER ;

# Test
INSERT INTO Clienti (cod_cliente, nome, cognome, tipo, cod_fiscale, p_iva)
VALUES ('CLT017', 'Giovanni', 'Rossi', 'Privato', 'VRSGNN85H01H501Z', NULL);

INSERT INTO Clienti (cod_cliente, nome, cognome, tipo, cod_fiscale, p_iva)
VALUES ('CLT018', 'Lucia', 'Bianchi', 'Privato', 'BNCLLC85T01H501Z', 'IT12345678901'); -- Questo generare un errore


INSERT INTO Clienti (cod_cliente, nome, cognome, tipo, cod_fiscale, p_iva)
VALUES ('CLT020', 'Anna', 'Neri', 'Azienda', 'NRNNNA85M01H501Z', 'IT12345678901'); -- Questo generare un errore

############################################################################

DROP TRIGGER IF EXISTS ControlloPiante_data;
DELIMITER $$
CREATE TRIGGER ControlloPiante_data
BEFORE INSERT ON Piante
FOR EACH ROW
BEGIN
IF NEW.tipologia = 'Perenni' THEN 		
IF NEW.data_semina IS NOT NULL THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Le pinate perenni non necessitano di tracciare la data di acquisizione';
END IF;
ELSEIF NEW.tipologia= 'Annuali' THEN 		
IF NEW.data_semina IS NULL THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Perfavore inserire una data di acquisizione';
END IF;
END IF;
END $$
DELIMITER ;

# Test
INSERT INTO Piante (codice_serra, nome_pianta, specie, nome_sede, via_sede, quantità, tipologia, costo_iniziale, costo_mantenimento, fiorite, colore, data_semina, id_ordine) VALUES
('SRR001', 'Fiore', 'Fiore_particolare', 'FlowerCorp Firenze', 'Via lungarno 12', 10, 'Perenni', 100.00, 10.00, 'Si', 'Rosso', '2023-03-16', 'ORD001'); -- genera errore poichè c'è la data semina

INSERT INTO Piante (codice_serra, nome_pianta, specie, nome_sede, via_sede, quantità, tipologia, costo_iniziale, costo_mantenimento, fiorite, colore, data_semina, id_ordine) VALUES
('SRR001', 'Fiore', 'Fiore_particolare', 'FlowerCorp Firenze', 'Via lungarno 12', 10, 'Annuali', 100.00, 10.00, 'Si', 'Rosso', null, 'ORD001'); -- genera errore poichè manca la data

INSERT INTO Piante (codice_serra, nome_pianta, specie, nome_sede, via_sede, quantità, tipologia, costo_iniziale, costo_mantenimento, fiorite, colore, data_semina, id_ordine) VALUES
('SRR001', 'Fiore', 'Fiore_particolare', 'FlowerCorp Firenze', 'Via lungarno 12', 10, 'Annuali', 100.00, 10.00, 'Si', 'Rosso', '2023-03-16', 'ORD001'); -- non genera errore

DELETE FROM Piante WHERE  nome_pianta = 'Fiore' AND specie= 'Fiore_particolare';


############################################################################

DROP TRIGGER IF EXISTS ControlloPiante_colore;
DELIMITER $$
CREATE TRIGGER ControlloPiante_colore
BEFORE INSERT ON Piante
FOR EACH ROW
BEGIN
IF NEW.fiorite = 'No' THEN 		
IF NEW.colore IS NOT NULL THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Le pinate non sono ancora fiorite';
END IF;
ELSEIF NEW.fiorite = 'Si' THEN 		
IF NEW.data_semina IS NULL THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Inserire il colore della fioritura';
END IF;
END IF;
END $$
DELIMITER ;

# Test
INSERT INTO Piante (codice_serra, nome_pianta, specie, nome_sede, via_sede, quantità, tipologia, costo_iniziale, costo_mantenimento, fiorite, colore, data_semina, id_ordine) VALUES
('SRR001', 'Fiore1', 'Fiore_particolare1', 'FlowerCorp Firenze', 'Via lungarno 12', 10, 'Perenni', 100.00, 10.00, 'Si', null, null, 'ORD001'); -- genera errore manca il dato del colore
INSERT INTO Piante (codice_serra, nome_pianta, specie, nome_sede, via_sede, quantità, tipologia, costo_iniziale, costo_mantenimento, fiorite, colore, data_semina, id_ordine) VALUES
('SRR001', 'Fiore2', 'Fiore_particolare', 'FlowerCorp Firenze', 'Via lungarno 12', 10, 'Perenni', 100.00, 10.00, 'No', 'Giallo', null, 'ORD001'); -- genera errore non va inserito il dato del colore

#DELETE FROM Piante WHERE  nome_pianta = 'Fiore1' AND specie= 'Fiore_particolare1';
#DELETE FROM Piante WHERE  nome_pianta = 'Fiore2' AND specie= 'Fiore_particolare2';

#################################################

DROP VIEW IF EXISTS StrumentiTecnici;
CREATE VIEW StrumentiTecnici AS
SELECT 
    codice_fiscale, 
    COUNT(codice_strumento) AS numero_strumenti,
    GROUP_CONCAT(DISTINCT codice_serra ORDER BY codice_serra) AS posizione_strumenti
FROM 
	Disponibilità NATURAL JOIN Strumento
GROUP BY codice_fiscale;

### Test
SELECT * FROM StrumentiTecnici;

############################################
DROP VIEW IF EXISTS StatisticaOrdiniAziende;
CREATE VIEW StatisticaOrdiniAziende AS
SELECT 
    Piante.nome_pianta,
    Piante.specie,
    COUNT(Piante.id_ordine) AS numero_ordini
FROM 
    Piante
    JOIN Ordine ON Piante.id_ordine = Ordine.id_ordine
    JOIN Clienti ON Ordine.cod_cliente = Clienti.cod_cliente
WHERE 
    Clienti.tipo = 'Azienda'  -- Basta cambiare questo parametro per avere la stessa selezione ma per i privati
GROUP BY 
    Piante.nome_pianta, Piante.specie
ORDER BY 
    numero_ordini DESC;

###Test
SELECT * FROM StatisticaOrdiniAziende;

##############################################################
################          Procedure          #################
##############################################################


###################################################################
/*procedura_vendita si occupa di inserire un ordine controllando che esista il cliente e che la quantità impostata sia disponibile*/
###################################################################
DELIMITER $$
CREATE PROCEDURE procedura_vendita(
    IN p_id_ordine char(16),
    IN p_metodo_pagamento enum('Carta', 'Contanti', 'Bonifico'),
    IN p_data_ordine date,
    IN p_cod_cliente char(16),
    IN p_codice_serra varchar(10),
    IN p_nome_pianta varchar(15),
    IN p_specie varchar(20),
    IN p_quantita_ordinata int
)
BEGIN
DECLARE pianta_quantita INT;
IF NOT EXISTS (SELECT 1 FROM Clienti WHERE cod_cliente = p_cod_cliente) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Il cliente non è registrato!';
END IF;
SELECT quantità INTO pianta_quantita
FROM Piante
WHERE codice_serra = p_codice_serra
AND nome_pianta = p_nome_pianta
AND specie = p_specie;
IF pianta_quantita IS NULL THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Errore: Prodotto non disponibile';
ELSEIF pianta_quantita < p_quantita_ordinata THEN
SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'Errore: Prodotto esaurito o non disponibilie in tale qunatità';
END IF;
INSERT INTO Ordine (id_ordine, metodo_pagamento, data_ordine, cod_cliente)
VALUES (p_id_ordine, p_metodo_pagamento, p_data_ordine, p_cod_cliente);
UPDATE Piante
SET quantità = quantità - p_quantita_ordinata
WHERE codice_serra = p_codice_serra
AND nome_pianta = p_nome_pianta
AND specie = p_specie;
END $$
DELIMITER ;


# Test procedura
SELECT * FROM Piante WHERE codice_serra = 'SRR001' AND nome_pianta = 'Rosa' AND specie = 'Rosa';
SELECT * FROM Ordine;
SELECT * FROM Clienti WHERE cod_cliente = 'CLT001';

CALL procedura_vendita('ORD1001', 'Carta', '2024-09-15', 'CLT001', 'SRR001', 'Rosa', 'Rosa', 1 );

SELECT * FROM Piante WHERE codice_serra = 'SRR001' AND nome_pianta = 'Rosa' AND specie = 'Rosa';
SELECT * FROM Ordine WHERE id_ordine = 'ORD1001';
SELECT * FROM Clienti WHERE cod_cliente = 'CLT001';

CALL procedura_vendita('ORD1002', 'Carta', '2024-09-15', 'CLT001', 'SRR001', 'Rosa', 'Rosa', 10 );

SELECT * FROM Piante WHERE codice_serra = 'SRR001' AND nome_pianta = 'Rosa' AND specie = 'Rosa';
SELECT * FROM Ordine WHERE id_ordine = 'ORD1001';
SELECT * FROM Clienti WHERE cod_cliente = 'CLT001';
Drop PROCEDURE procedura_vendita;
###################################################################
/*la procedura calcola_stipendio_magazziniere si occupa di calcolare lo stipendio di un magazziniere in base alle sue ore lavorative*/
###################################################################
DELIMITER $$
CREATE PROCEDURE calcola_stipendio_magazziniere(
    IN p_cod_fiscale CHAR(16),
    OUT p_stipendio DECIMAL(10,2)
)
BEGIN
DECLARE ore INT;
IF EXISTS (
SELECT 1
FROM Dipendente
WHERE cod_fiscale = p_cod_fiscale
AND ruolo = 'Magazziniere'
) THEN
SELECT ore_lavoro INTO ore
FROM Dipendente
WHERE cod_fiscale = p_cod_fiscale;
SET p_stipendio = ore * 10;
ELSE
SET p_stipendio = NULL; -- Se il dipendente non è un magazziniere, restituisce NULL
END IF;
END $$
DELIMITER ;

# Test procedura
CALL calcola_stipendio_magazziniere('BNCLRD76T10F205Z', @stipendio); -- è un magazziniere
SELECT @stipendio AS stipendio_calcolato;

CALL calcola_stipendio_magazziniere('RSSMRA85M01H501Z', @stipendio); -- non è un magazziniere
SELECT @stipendio AS stipendio_calcolato;  


############################################################
##############          Interrogazioni          ############
############################################################

## Trovare i guadagni totali prodotti dalle aziende

SELECT SUM((Listino.prezzo_ingrosso * Piante.quantità) - (Piante.costo_iniziale * Piante.quantità)) AS guadagno_totale
FROM Piante
JOIN Ordine ON Piante.id_ordine = Ordine.id_ordine
JOIN Listino ON Piante.nome_pianta = Listino.nome_pianta AND Piante.specie = Listino.specie AND Piante.codice_serra = Listino.codice_serra
JOIN Clienti ON Ordine.cod_cliente = Clienti.cod_cliente
WHERE Clienti.tipo = 'Azienda';


SELECT SUM((Listino.prezzo_dettaglio * Piante.quantità) - (Piante.costo_iniziale * Piante.quantità)) AS guadagno_totale
FROM Piante
JOIN Ordine ON Piante.id_ordine = Ordine.id_ordine
JOIN Listino ON Piante.nome_pianta = Listino.nome_pianta AND Piante.specie = Listino.specie AND Piante.codice_serra = Listino.codice_serra
JOIN Clienti ON Ordine.cod_cliente = Clienti.cod_cliente
WHERE Clienti.tipo = 'Privato';





