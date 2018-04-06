//
//  DBWrapper.swift
//  SQLiteLearn
//
//  Created by Mac Mini-07 on 3/19/18.
//  Copyright © 2018 Mac Mini-07. All rights reserved.
//

import UIKit
import SQLite3

class DBWrapper {
    
    static let sharedInstance = DBWrapper()
    var db: OpaquePointer?
    
    init() {
        //SQLite Stuffs
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("travelagen.db")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("ERROR : Error opening travelagen.db in \(fileURL.path)" )
        }
        else {
            print("SUCCES: Succesfully open travelagen.db in \(fileURL.path)")
        }
        
    }
    
    func createTables() {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Admin (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT, level INTEGER)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table User: \(errmsg)")
            
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Transportasi (id INTEGER PRIMARY KEY AUTOINCREMENT, jenis_kendaraan TEXT, nama_kendaraan TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Transportasi: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Wisata (id INTEGER PRIMARY KEY AUTOINCREMENT, nama_wisata TEXT, kota_wisata TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Wisata: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Customer (id INTEGER PRIMARY KEY AUTOINCREMENT, nama_customer TEXT, Alamat TEXT, nomor_tlp TEXT, email TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Customer: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Penginapan (id INTEGER PRIMARY KEY AUTOINCREMENT, nama_penginapan TEXT, kualitas TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Penginapan: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS PaketWisata (id INTEGER PRIMARY KEY AUTOINCREMENT, id_wisata INTEGER, id_penginapan INTEGER, id_transportasi INTEGER, lama_wisata TEXT, harga INTEGER, status TEXT DEFAULT 'Tersedia', kapasitas TEXT, namaPaket TEXT, gambar TEXT, stock INTEGER)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table PaketWisata: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Reservasi (id INTEGER PRIMARY KEY AUTOINCREMENT, id_customer INTEGER, id_paket INTEGER, status TEXT DEFAULT 'Dipesan', id_jadwal TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Resrevasi: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Jadwal (id INTEGER PRIMARY KEY AUTOINCREMENT, tanggal TEXT)", nil, nil, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: Error creating table Jadwal: \(errmsg)")
        }
        
    }
    
    func doRegister(username: String, password: String) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "INSERT INTO Admin (username, password) VALUES ('\(username)','\(password)')"
        print("QUERY REGISTER: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doLogin(username: String, password: String) -> [String: String]? {
        let queryString = "SELECT * FROM Admin WHERE Username='\(username)'AND password='\(password)'"
        print("QUERY LOGIN: \(queryString)")
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing login: \(errmsg)")
            return nil
        }
        
        var user: [String: String]?
        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let username = String(cString: sqlite3_column_text(stmt, 1))
            let password = String(cString: sqlite3_column_text(stmt, 2))
            
            
            user = [String: String]()
            user?["id"] = String(id)
            user?["username"] = username
            user?["password"] = password
            
        }
        return user
    }
    
    func fetchPaket() -> [[String: String]]? {
        let queryString = "SELECT PaketWisata.id, PaketWisata.namaPaket, Wisata.nama_wisata, Wisata.kota_wisata, Penginapan.nama_penginapan, PaketWisata.lama_wisata, Transportasi.jenis_kendaraan, Transportasi.nama_kendaraan, PaketWisata.kapasitas, PaketWisata.status, PaketWisata.harga, PaketWisata.gambar, PaketWisata.stock FROM PaketWisata INNER JOIN Wisata ON Wisata.id = PaketWisata.id_wisata INNER JOIN Penginapan ON Penginapan.id = PaketWisata.id_penginapan INNER JOIN Transportasi ON Transportasi.id = PaketWisata.id_transportasi WHERE PaketWisata.status = 'Tersedia'"
        print("QUERY FETCH PAKET: \(queryString)")
        var stmt: OpaquePointer?
        
        var paket : [[String: String]]?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch movies: \(errmsg)")
            return nil
        }
        
        paket = [[String: String]]()
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let namaPaket = String(cString: sqlite3_column_text(stmt, 1))
            let namaWisata = String(cString: sqlite3_column_text(stmt, 2))
            let kotaWisata = String(cString: sqlite3_column_text(stmt, 3))
            let namaPenginapan = String(cString: sqlite3_column_text(stmt, 4))
            let lamaWisata = String(cString: sqlite3_column_text(stmt, 5))
            let jenisKendaraan = String(cString: sqlite3_column_text(stmt, 6))
            let namaKendaraan = String(cString: sqlite3_column_text(stmt, 7))
            let kapasitas = String(cString: sqlite3_column_text(stmt, 8))
            let status = String(cString: sqlite3_column_text(stmt, 9))
            let harga = String(cString: sqlite3_column_text(stmt, 10))
            let gambar = String(cString: sqlite3_column_text(stmt, 11))
            let stock = String(cString: sqlite3_column_text(stmt, 12))
            
            let tmp = [
                "id": String(id),
                "namaPaket": namaPaket,
                "nama_wisata": namaWisata,
                "kota_wisata": kotaWisata,
                "nama_penginapan": namaPenginapan,
                "lama_wisata": lamaWisata,
                "jenis_kendaraan": jenisKendaraan,
                "nama_kendaraan": namaKendaraan,
                "kapasitas": kapasitas,
                "status": status,
                "harga": harga,
                "gambar": gambar,
                "stock": stock
                ]
            paket?.append(tmp)
        }
        
        return paket
        
    }
    
    func doDeletePaket(Paket: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let paketId = Paket["id"]!
        
        let queryString = "DELETE FROM PaketWisata WHERE id='\(paketId)'"
        print("QUERY UPDATE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    
    func doTambahPaket(Paket: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let idwisata = Paket["id_wisata"]!
        let idpenginapan = Paket["id_penginapan"]!
        let idtransportasi = Paket["id_transportasi"]!
        let lamaWisata = Paket["lama_wisata"]!
        let harga = Paket["harga"]!
        let namaPaket = Paket["namaPaket"]!
        let kapasitas = Paket["kapasitas"]!
        let gambar = Paket["gambar"]!
        let stock = Paket["stock"]!
        
        let queryString = "INSERT INTO PaketWisata (id_wisata, id_penginapan, id_transportasi, lama_wisata, harga, namaPaket, kapasitas, gambar, stock) VALUES ('\(idwisata)','\(idpenginapan)','\(idtransportasi)','\(lamaWisata)','\(harga)','\(namaPaket)','\(kapasitas)','\(gambar)','\(stock)')"
        //print("QUERY Tambah paket: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Gagal memasukkan data: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doUpdatePaket(Paket: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let idpaket = Paket["id"]!
        let idwisata = Paket["id_wisata"]!
        let idpenginapan = Paket["id_penginapan"]!
        let idtransportasi = Paket["id_transportasi"]!
        let lamaWisata = Paket["lama_wisata"]!
        let harga = Paket["harga"]!
        let namaPaket = Paket["namaPaket"]!
        let kapasitas = Paket["kapasitas"]!
        let gambar = Paket["gambar"]!
        let stock = Paket["stock"]!
        
        let queryString = "UPDATE PaketWisata SET id_wisata='\(idwisata)', id_penginapan='\(idpenginapan)', id_transportasi='\(idtransportasi)', lama_wisata='\(lamaWisata)', harga='\(harga)', namaPaket='\(namaPaket)', kapasitas='\(kapasitas)', gambar='\(gambar)', stock='\(stock)' WHERE id='\(idpaket)'"
        //print("QUERY UPDATE PAKET: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func fetchWisata() -> [[String: String]]? {
        var stmt: OpaquePointer?
        
        let queryString = "SELECT * FROM Wisata"
        print("QUERY FETCH USERS: \(queryString)")
        
        var Wisata = [[String: String]]()
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch wisata: \(errmsg)")
            return nil
        }
        
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let wisata = String(cString: sqlite3_column_text(stmt, 1))
            let kota = String(cString: sqlite3_column_text(stmt, 2))
            
            let tmp = [
                "id": String(id),
                "wisata": String(wisata),
                "kota": String(kota)
                ]
            Wisata.append(tmp)
        }
        
        return Wisata
    }
    
    func doInsertWisata(Wisata: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let nama = Wisata["nama_wisata"]!
        let kota = Wisata["kota_wisata"]!
       
        
        let queryString = "INSERT INTO Wisata (nama_wisata, kota_wisata) VALUES ('\(nama)','\(kota)')"
        print("QUERY REGISTER: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doDeleteWisata(Wisata: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let id_wisata = Wisata["id"]!
        
        let queryString = "DELETE FROM Wisata WHERE id='\(id_wisata)'"
        print("QUERY UPDATE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing delete: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func fetchPenginapan() -> [[String: String]]? {
        var stmt: OpaquePointer?
        
        let queryString = "SELECT * FROM Penginapan"
        print("QUERY FETCH USERS: \(queryString)")
        
        var Penginapan = [[String: String]]()
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch penginapan: \(errmsg)")
            return nil
        }
        
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let namapenginapan = String(cString: sqlite3_column_text(stmt, 1))
            let kualitas = String(cString: sqlite3_column_text(stmt, 2))
            
            let tmp = [
                "id": String(id),
                "nama_penginapan": String(namapenginapan),
                "kualitas": String(kualitas)
            ]
            Penginapan.append(tmp)
        }
        
        return Penginapan
    }
    
    
    func doInsertPenginapan(Penginapan: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        
        let nama = Penginapan["nama_penginapan"]!
        let kualitas = Penginapan["kualitas"]!
        
        
        let queryString = "INSERT INTO Penginapan (nama_penginapan, kualitas) VALUES ('\(nama)','\(kualitas)')"
        print("QUERY Penginapan: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doDeletePenginapan(Penginapan: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let id_penginapan = Penginapan["id"]!
        
        let queryString = "DELETE FROM Penginapan WHERE id='\(id_penginapan)'"
        print("QUERY UPDATE Penginapan: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing delete: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doUpdateWisata(Wisata: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let wisataId = Wisata["id"]!
        let nama = Wisata["nama_wisata"]!
        let kota = Wisata["kota_wisata"]!
        
        let queryString = "UPDATE Wisata SET nama_wisata='\(nama)', kota_wisata='\(kota)' WHERE id='\(wisataId)'"
        print("QUERY UPDATE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doUpdatePenginapan(Penginapan: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let penginapanId = Penginapan["id"]!
        let nama = Penginapan["nama_penginapan"]!
        let kualitas = Penginapan["kualitas"]!
        
        let queryString = "UPDATE Penginapan SET nama_penginapan='\(nama)', kualitas='\(kualitas)' WHERE id='\(penginapanId)'"
        print("QUERY UPDATE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func fetchTransportasi() -> [[String: String]]? {
        var stmt: OpaquePointer?
        
        let queryString = "SELECT * FROM Transportasi"
        print("QUERY FETCH USERS: \(queryString)")
        
        var Transportasi = [[String: String]]()
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch wisata: \(errmsg)")
            return nil
        }
        
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let jenis = String(cString: sqlite3_column_text(stmt, 1))
            let nama = String(cString: sqlite3_column_text(stmt, 2))
            
            let tmp = [
                "id": String(id),
                "jenis": String(nama),
                "nama": String(jenis)
            ]
            Transportasi.append(tmp)
        }
        
        return Transportasi
    }
    
    func doInsertTransportasi(Transportasi: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let jenis = Transportasi["jenis_kendaraan"]!
        let nama = Transportasi["nama_kendaraan"]!
        
        
        let queryString = "INSERT INTO Transportasi (jenis_kendaraan, nama_kendaraan) VALUES ('\(jenis)','\(nama)')"
        print("QUERY REGISTER: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doDeleteTransportasi(Transportasi: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let id_kendaraan = Transportasi["id"]!
        
        let queryString = "DELETE FROM Transportasi WHERE id='\(id_kendaraan)'"
        print("QUERY UPDATE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing delete: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doUpdateTransportasi(Transportasi: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let kendaraanId = Transportasi["id"]!
        let jenis = Transportasi["jenis_kendaraan"]!
        let nama = Transportasi["nama_kendaraan"]!
        
        let queryString = "UPDATE Transportasi SET jenis_kendaraan='\(jenis)', nama_kendaraan='\(nama)' WHERE id='\(kendaraanId)'"
        print("QUERY UPDATE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    
    func doInsertCustomer(custData: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let nama = custData["nama_customer"]!
        let alamat = custData["Alamat"]!
        let telepon = custData["nomor_tlp"]!
        let email = custData["email"]!
        
        let queryString = "INSERT INTO Customer (nama_customer, Alamat, nomor_tlp, email) VALUES ('\(nama)','\(alamat)','\(telepon)','\(email)')"
        print("QUERY INSERT CUSTOMER: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
            
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func fetchCustomer() -> [[String: String]]? {
        let queryString = "SELECT * FROM Customer"
        print("QUERY FETCH MOVIES: \(queryString)")
        var stmt: OpaquePointer?
        
        var customers: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch movies: \(errmsg)")
            return nil
        }
        
        customers = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let nama = String(cString: sqlite3_column_text(stmt, 1))
            let alamat = String(cString: sqlite3_column_text(stmt, 2))
            let telepon = String(cString: sqlite3_column_text(stmt, 3))
            let email = String(cString: sqlite3_column_text(stmt, 4))
            
            let tmp = [
                "id": String(id),
                "nama_customer": String(nama),
                "Alamat": String(alamat),
                "nomor_tlp": String(telepon),
                "email": String(email),
                ]
            customers?.append(tmp)
        }
        return customers
        
    }
    
    func doUpdateCustomer(custid: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let custId = custid["id"]!
        let nama = custid["nama_customer"]!
        let tlp = custid["nomor_tlp"]!
        let email = custid["email"]!
        let alamat = custid["Alamat"]!
        
        let queryString = "UPDATE Customer SET nama_customer='\(nama)', nomor_tlp='\(tlp)', email='\(email)', Alamat='\(alamat)' WHERE id='\(custId)'"
        
        print("QUERY UPDATE Cust: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doDeleteCustomer(custId: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let id_customer = custId["id"]!
        
        // DELETE FROM Movies WHERE id=1
        let queryString = "DELETE FROM Customer WHERE id='\(id_customer)'"
        print("QUERY DELETE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doInsertReservasi(reservasi: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let custid = reservasi["id_customer"]!
        let paketid = reservasi["id_paket"]!
        let jadwalid = reservasi["id_jadwal"]!
        
        let queryString = "INSERT INTO Reservasi (id_customer, id_jadwal, id_paket) VALUES ('\(custid)', '\(jadwalid)', '\(paketid)')"
        
        print("QUERY INSERT RESERVASI: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch users: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func fetchJadwal() -> [[String: String]]? {
        let queryString = "SELECT * FROM Jadwal"
        print("QUERY FETCH Jadwal: \(queryString)")
        var stmt: OpaquePointer?
        
        var jadwal: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch movies: \(errmsg)")
            return nil
        }
        
        jadwal = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let tanggal = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "id": String(id),
                "tanggal": String(tanggal)
            ]
            jadwal?.append(tmp)
        }
        return jadwal
        
    }
    
    func doDeleteJadwal(jadwal: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let id_jadwal = jadwal["id"]!
        
        // DELETE FROM Movies WHERE id=1
        let queryString = "DELETE FROM Jadwal WHERE id='\(id_jadwal)'"
        print("QUERY DELETE JADWAL: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doInsertJadwal(jadwal: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        
        let jadwals = jadwal["tanggal"]!
        
        let queryString = "INSERT INTO Jadwal (tanggal) VALUES ('\(jadwals)')"
        
        print("QUERY INSERT RESERVASI: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch users: \(errmsg)")
            return false
        }
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doUpdateJadwal(jadwal: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let idjadwal = jadwal["id"]!
        let jadwals = jadwal["tanggal"]!
        
        let queryString = "UPDATE Jadwal SET tanggal='\(jadwals)' WHERE id='\(idjadwal)'"
        
        print("QUERY UPDATE Cust: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing insert: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func fetchReservasi() -> [[String: String]]? {
        let queryString = "SELECT Reservasi.id, Customer.nama_customer, PaketWisata.namaPaket, Wisata.nama_wisata, Wisata.kota_wisata, Penginapan.nama_penginapan, PaketWisata.lama_wisata, Transportasi.jenis_kendaraan, Transportasi.nama_kendaraan, PaketWisata.kapasitas, Reservasi.status, PaketWisata.harga, Jadwal.tanggal FROM Reservasi INNER JOIN PaketWisata ON PaketWisata.id = Reservasi.id_paket INNER JOIN Wisata ON Wisata.id = PaketWisata.id_wisata INNER JOIN Penginapan ON Penginapan.id = PaketWisata.id_penginapan INNER JOIN Transportasi ON Transportasi.id = PaketWisata.id_transportasi INNER JOIN Customer ON Customer.id = Reservasi.id_customer INNER JOIN Jadwal ON Jadwal.id = Reservasi.id_jadwal"
        print("QUERY FETCH PAKET: \(queryString)")
        var stmt: OpaquePointer?
        
        var reservasi : [[String: String]]?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch reservasi: \(errmsg)")
            return nil
        }
        
        reservasi = [[String: String]]()
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let nama_customer = String(cString: sqlite3_column_text(stmt, 1))
            let namaPaket = String(cString: sqlite3_column_text(stmt, 2))
            let namaWisata = String(cString: sqlite3_column_text(stmt, 3))
            let kotaWisata = String(cString: sqlite3_column_text(stmt, 4))
            let namaPenginapan = String(cString: sqlite3_column_text(stmt, 5))
            let lamaWisata = String(cString: sqlite3_column_text(stmt, 6))
            let jenisKendaraan = String(cString: sqlite3_column_text(stmt, 7))
            let namaKendaraan = String(cString: sqlite3_column_text(stmt, 8))
            let kapasitas = String(cString: sqlite3_column_text(stmt, 9))
            let status = String(cString: sqlite3_column_text(stmt, 10))
            let harga = String(cString: sqlite3_column_text(stmt, 11))
            let tanggal = String(cString: sqlite3_column_text(stmt, 12))
            
            let tmp = [
                "id": String(id),
                "nama_customer": nama_customer,
                "namaPaket": namaPaket,
                "nama_wisata": namaWisata,
                "kota_wisata": kotaWisata,
                "nama_penginapan": namaPenginapan,
                "lama_wisata": lamaWisata,
                "jenis_kendaraan": jenisKendaraan,
                "nama_kendaraan": namaKendaraan,
                "kapasitas": kapasitas,
                "status": status,
                "harga": harga,
                "tanggal": tanggal
                
            ]
            reservasi?.append(tmp)
        }
        
        return reservasi
        
    }
    
    
    func searchWisata(search: String) -> [[String: String]]? {
        let queryString = "SELECT Wisata.nama_wisata, Wisata.kota_wisata FROM Wisata WHERE Wisata.nama_wisata like '%\(search)%'"
        print("QUERY FETCH Wisata: \(queryString)")
        var stmt: OpaquePointer?
        
        var nama_wisata: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Wisata: \(errmsg)")
        }
        
        nama_wisata = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let wisata = String(cString: sqlite3_column_text(stmt, 0))
            let kota = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "wisata" : String(wisata),
                "kota": String(kota)
                
            ]
            nama_wisata?.append(tmp)
        }
        
        return nama_wisata
        
    }
    
    func searchPenginapan(search: String) -> [[String: String]]? {
        let queryString = "SELECT Penginapan.nama_penginapan, Penginapan.kualitas FROM Penginapan WHERE Penginapan.nama_penginapan like '%\(search)%'"
        print("QUERY FETCH Wisata: \(queryString)")
        var stmt: OpaquePointer?
        
        var penginapan: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Penginapan: \(errmsg)")
        }
        
        penginapan = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let namapenginapan = String(cString: sqlite3_column_text(stmt, 0))
            let kualitas = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "nama_penginapan": String(namapenginapan),
                "kualitas": String(kualitas)
                
            ]
            penginapan?.append(tmp)
        }
        
        return penginapan
        
    }
    
    func searchTransportasi(search: String) -> [[String: String]]? {
        let queryString = "SELECT Transportasi.jenis_kendaraan, Transportasi.nama_kendaraan FROM Transportasi WHERE Transportasi.nama_kendaraan like '%\(search)%'"
        print("QUERY FETCH Wisata: \(queryString)")
        var stmt: OpaquePointer?
        
        var penginapan: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Penginapan: \(errmsg)")
        }
        
        penginapan = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let jenis = String(cString: sqlite3_column_text(stmt, 0))
            let nama = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "jenis": String(nama),
                "nama": String(jenis)
                
            ]
            penginapan?.append(tmp)
        }
        
        return penginapan
        
    }
    
    func searchPelanggan(search: String) -> [[String: String]]? {
        let queryString = "SELECT Customer.nama_customer, Customer.nomor_tlp FROM Customer WHERE Customer.nama_customer like '%\(search)%'"
        print("QUERY FETCH Wisata: \(queryString)")
        var stmt: OpaquePointer?
        
        var penginapan: [[String: String]]?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch Penginapan: \(errmsg)")
        }
        
        penginapan = [[String: String]]()
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let telepon = sqlite3_column_int(stmt, 0)
            let nama = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "nomor_telepon": String(telepon),
                "nama_customer": String(nama)
                
            ]
            penginapan?.append(tmp)
        }
        
        return penginapan
        
    }
    
    func doUpdateStatus(ordersId: [String: String], status: String) -> Bool {
        var stmt: OpaquePointer?
        
        let id = ordersId["id"]!
        
        
        let queryString = "UPDATE Reservasi SET status='\(status)' WHERE Reservasi.id = \(id)"
        print("QUERY UPDATE MOVIE: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update status: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func fetchPaketStock() -> [[String: String]]? {
        let queryString = "SELECT PaketWisata.id, PaketWisata.stock FROM PaketWisata"
        print("QUERY FETCH PAKET: \(queryString)")
        var stmt: OpaquePointer?
        
        var paket : [[String: String]]?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: ReadValues: Error preparing fetch movies: \(errmsg)")
            return nil
        }
        
        paket = [[String: String]]()
        while (sqlite3_step(stmt)) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let stock = String(cString: sqlite3_column_text(stmt, 1))
            
            let tmp = [
                "id": String(id),
                "stock": stock
            ]
            paket?.append(tmp)
        }
        
        return paket
        
    }
    
    func doUpdatePaketStock(Paket: [String: String]) -> Bool {
        var stmt: OpaquePointer?
        
        let idpaket = Paket["id"]!
        let stock = Paket["stock"]!
        
        let queryString = "UPDATE PaketWisata SET stock='\(stock)' WHERE id='\(idpaket)'"
        print("QUERY UPDATE PAKET: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    func doUpdatePaketStatus(Paket: [String: String], status: String) -> Bool {
        var stmt: OpaquePointer?
        
        let idpaket = Paket["id"]!
        
        
        let queryString = "UPDATE PaketWisata SET status='\(status)' WHERE id='\(idpaket)'"
        print("QUERY UPDATE PAKET: \(queryString)")
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR: SaveMethod: Error preparing update: \(errmsg)")
            return false
        }
        
        return sqlite3_step(stmt) == SQLITE_DONE
    }
    
    

}
