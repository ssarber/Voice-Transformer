//
//  RecordedAudio.swift
//  Voice Transformer
//
//  Created by ssarber on 1/22/15.
//  Copyright (c) 2015 Zuk Gek. All rights reserved.
//

import Foundation


class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    

    init(filePath: NSURL!, audioTitle: String!) {
        filePathUrl = filePath
        title = audioTitle
    }
}