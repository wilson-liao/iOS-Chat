//
//  FileManager.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/21.
//

import UIKit

let fm = FileManager.default


func removeFile(path:URL) {
    do {
        try FileManager.default.removeItem(at: path)
    }
    catch {
        print(error)
    }
}

func clearDirectory(path:URL) {
    do {
        let ls = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        
        for file in ls {
            removeFile(path: file)
            print("Removed \(file.absoluteString)")
        }
    }
    catch {
        print(error)
    }
}

func getDocumentsURL() -> URL{
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL
}

func initCredentialsURL() {
    fm.createFile(atPath: credentialsURL().path, contents: nil)
}

func credentialsURL() -> URL {
    let credentialsURL = getDocumentsURL().appendingPathComponent("credentials")
    return credentialsURL
}

func writeCred(creds: String) {
    if !fm.fileExists(atPath: credentialsURL().path) {
        initCredentialsURL()
    }
    if let data = creds.data(using: .utf8) {
        do {
            try data.write(to: credentialsURL())
            print("Successfully wrote to file! \(credentialsURL())")
        } catch {
            print("Error writing to file: \(error)")
        }
    }
}

func getCred() -> Dictionary<String,String> {
    do {
        let data = try Data(contentsOf: credentialsURL())
        if let string = String(data: data, encoding: .utf8) {
//            print("cred string: \(string)")
            return convertToDictionary(text: string) ?? [:]
        }
        return [:]
    }
    catch {
        print(error)
        return [:]
    }
}

func dictToJSONString(dict: Dictionary<String, String>) -> String {
    if let theJSONData = try? JSONSerialization.data(
        withJSONObject:dict, options: .prettyPrinted),
    let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
        return theJSONText
    }
    return "aaa"
}

func convertToDictionary(text: String) -> [String: String]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}



//func getDescFile(from fileName: String) -> URL{
//    let newName = fileName + ".Desc"
//    let descFileURL = getDescFolderURL().appendingPathComponent(newName)
//    return descFileURL
//}

//func writeDescription(at path: URL, desc: String, filename: String){
//    let fm = FileManager.default
//    let newurl = getDescFile(from: filename)
//    fm.createFile(atPath: newurl.path, contents: nil)
//    
//    if let data = desc.data(using: .utf8) {
//        do {
//            try data.write(to: newurl)
//            print("Successfully wrote to file! \(newurl)")
//        } catch {
//            print("Error writing to file: \(error)")
//        }
//    }
//}

//func writeTitle(at path: URL, title: String) {
//    // Create a FileManager instance
//    let fileManager = FileManager.default
//    let newPath = getJournalsFolderURL().appendingPathComponent(title)
//    let newDescPath = getDescFile(from: newPath.name())
//    // Rename 'hello.swift' as 'goodbye.swift'
//    do {
//        try fileManager.moveItem(atPath: path.path, toPath: newPath.path)
//        //also change description file name
//        try fileManager.moveItem(atPath: getDescFile(from: path.name()).path, toPath: newDescPath.path)
//        
//    } catch let error as NSError {
//        print("Ooops! Something went wrong: \(error)")
//    }
//    print("successfully wrote title")
//}

//func getFileDict(path: URL) -> Dictionary<URL, Date> {
//    do {
//        let list = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
//        
//        var fileDict = Dictionary<URL, Date>()
//        
//        for file in list {
//            let dateAttr = try FileManager.default.attributesOfItem(atPath: file.path)[.creationDate] as? Date ?? Date()
//            fileDict[file] = dateAttr
//        }
//        return fileDict
//    }
//    catch {
//        print(error)
//    }
//    return Dictionary<URL, Date>()
//}

//func ls(path:URL, sortKey: String) -> Array<(key: URL, value: Date)>{
//    let fileDict = getFileDict(path: path)
//    
//    let nameSortedDict = fileDict.sorted( by: { $0.0.name() < $1.0.name() })
//    let dateSortedDict = fileDict.sorted( by: { $0.1 < $1.1 })
//    var loop = nameSortedDict
//    
//    print("\nnumber of files: \(fileDict.count)\n")
//    let formattedf = "File Name".padding(toLength: 25, withPad: " ", startingAt: 0)
//    let formattedd = "Date Created".padding(toLength: 30, withPad: " ", startingAt: 0)
//    let desc = "Description"
//    print("\(formattedf)\(formattedd)\(desc)")
//    
//    if sortKey == "Earliest Date" {
//        loop = dateSortedDict
//    }
//    else if sortKey == "Alphabetical Order" {
//        loop = nameSortedDict
//    }
//    else if sortKey == "Latest Date" {
//        loop = dateSortedDict.reversed()
//    }
//    else if sortKey == "Reverse Alphabetical Order" {
//        loop = nameSortedDict.reversed()
//    }
//    
//    for (f, d) in loop {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
//        let fileName = f.name().padding(toLength: 25, withPad: " ", startingAt: 0)
//        let dateString = formatter.string(from: d).padding(toLength: 30, withPad: " ", startingAt: 0)
//        let descURL = getDescFile(from:f.name())
//        print("\(fileName)\(dateString)\(readFile(at:descURL))")
//    }
//    return loop
//}
