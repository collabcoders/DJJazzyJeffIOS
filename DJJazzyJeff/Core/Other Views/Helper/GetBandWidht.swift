//
//  GetBandWidht.swift
//  SAMUH
//
//  Created by Jigar Khatri on 14/09/22.
//

import Foundation
import ObjectMapper


struct RawPlaylistModel: Codable{
    internal var Url: URL?
    internal var content: String?
}

struct StreamResolution: Codable{
    internal var bandwidth: String?
    internal var name: String?
}


func getPlaylist(from url: URL, completion: @escaping (String) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print(error)
            completion("")
        } else if let data = data, let string = String(data: data, encoding: .utf8) {
            print(url)
            print(string)
            completion(string)
        } else {
            print("")
        }
    }
    task.resume()
}


/// Iterates over the provided playlist contetn and fetches all the stream info data under the `#EXT-X-STREAM-INF"` key.
/// - Parameter playlist: Playlist object obtained from the stream url.
/// - Returns: All available stream resolutions for respective bandwidth.

//func getStreamResolutions(from playlist: RawPlaylistModel, completion: @escaping ([StreamResolution], [StreamUrl]) -> Void) {
//    var resolutions = [StreamResolution]()
//    var resolutionsURL = [StreamUrl]()
//
//    return completion(resolutions, resolutionsURL)
//
//}
func getStreamResolutions(from playlist: RawPlaylistModel, completion: @escaping ([StreamResolution], [String]) -> Void) {
    var resolutions = [StreamResolution]()
    var resolutionsURL = [String]()

    playlist.content?.enumerateLines { line, shouldStop in
        print(line)
        
        let infoline = line.replacingOccurrences(of: "#EXT-X-STREAM-INF", with: "")
        let infoItems = infoline.components(separatedBy: ",")
        let bandwidthItem = infoItems.first(where: { $0.contains(":BANDWIDTH") })
        let nameItem = infoItems.first(where: { $0.contains("NAME")})
        let nameURL = infoItems.first(where: { $0.contains("chunklist_")})
       
        //SET NAME
        if nameURL != "" && nameURL != nil{
            resolutionsURL.append(nameURL ?? "")
        }
        
        //SET BANNER
        if let bandwidth = bandwidthItem?.components(separatedBy: "=").last,
            let name = nameItem?.components(separatedBy: "=").last{
            print(nameURL ?? "")
            var strName = name.replacingOccurrences(of: "p", with: "")
            strName = strName.replacingOccurrences(of: "\"", with: "")
            resolutions.append(StreamResolution(bandwidth: bandwidth, name: strName))
        }
    }
    return completion(resolutions ,resolutionsURL)
}

