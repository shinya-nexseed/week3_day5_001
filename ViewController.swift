//
//  ViewController.swift
//  week3_day5_001
//
//  Created by Shinya Hirai on 2015/10/23.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    // APIから取得したデータを保持し続けるDictionary型の変数
    var jsonDict = [:]
    
    // AVPlayerを定義
    var player:AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var num = 1
        textField.text = String(num)
        
        // APIの情報
        var urlStr = "https://itunes.apple.com/search?term=beatles&country=JP&lang=ja_jp&media=music"
        
        // Str ⇒ URLに変換
        var apiUrl = NSURL(string: urlStr)
        
        // URL ⇒ DATAに変換
        var apiData = NSData(contentsOfURL: apiUrl!)
        
        // DATA ⇒ jsonに変換
        jsonDict = NSJSONSerialization.JSONObjectWithData(apiData!, options: nil, error: nil) as! NSDictionary
        
        // データ格納
        createVals(num: num)
        
        
        ///////////////////////// メソッドについて ///////////////////////////////
        
        // メソッド1の呼び出し
        sayHello()
        
        // メソッド2の呼び出し
        saySomething("こんにちはー")
        
        // メソッド3の呼び出し
        var name = getMyName()
        println(name)
        
        // メソッド呼び出し時の補完候補名の左側に返り値の型が記されている
        // Voidの場合は返り値なしのメソッド
        
        // メソッド4の呼び出し
        var answer = plusNumbers(10, num2: 5)
        println(answer)
        
        // メソッドminusNumbersの呼び出し
        var answer2 = minusNumbers(num1: 10, num2: 5)
        println(answer2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func inputText(sender: AnyObject) {
        sayHello()
        
        var num = textField.text.toInt()!
        
        createVals(num: num)
    }
    
    // 自作メソッド その1
    // func メソッド名() {
    //     処理
    // }
    
    // 例 sayHello()メソッドを定義する
    func sayHello() {
        println("Hello")
    }
    
    // 自作メソッド その2
    // 引数ありのメソッド
    // func メソッド名(引数名:引数の型) {
    //     処理
    // }
    
    // 引数とは
    // メソッド呼び出し時にメソッド内で使用したいデータを引き渡すための変数
    
    // 例 saySomething()メソッドを定義する
    func saySomething(word:String) {
        println("\(word)")
    }
    
    // 自作メソッド その3
    // 返り値ありのメソッド
    // func メソッド名() -> 返り値の型 {
    //     処理
    // }
    
    // 返り値とは
    // メソッド実行時に指定した値を返せる
    // 返し方はreturnで値を指定する
    
    // 例 getMyName()メソッドを定義する
    func getMyName() -> String {
        return "Shinya Hirai"
    }
    
    // 自作メソッド その4
    // 引数あり (複数) 返り値ありのメソッド
    // func メソッド名(引数名1:引数の型1, 引数名2:引数の型2) -> 返り値の型 {
    //     処理
    // }

    // 引数はカンマ (,) 区切りで何個でも入れることが可能
    
    // 例 plusNumbers()メソッドを定義する
    func plusNumbers(num1:Int, num2:Int) -> Int {
        var answer = num1 + num2
        return answer
    }
    
    // メソッド定義のHack その1
    // 引数のラベルを用意する
    // 引数名のはじめに#を付ける
    // 必要なのは第一引数のみ
    func minusNumbers(#num1:Int, num2:Int) -> Int {
        var answer = num1 - num2
        return answer
    }
    
    // メソッド定義のHack その2 (非推奨)
    // 引数のラベルをすべて省略する
    // 第二引数以上の引数名の最初にスペースをあけて_を付ける
    // func minusNumbers(num1:Int, _ num2:Int)
    //                             ↑ これ
    
    
    
    // jsonDictデータをそれぞれ必要な値に分解して変数に保持するメソッド
    func createVals(#num:Int) {
        
        // 自己代入
        var numForAry = num
        numForAry-=1
        println(numForAry)
        
        // 取得した曲数
        var totalCount = jsonDict["resultCount"] as! Int
        println(totalCount)
        
        // jsonDictを配列データに変換
        var musicAry = jsonDict["results"] as! NSArray
        
        // 指定した曲のTrack name
        var trackName = musicAry[numForAry]["trackName"] as! String
        println("曲名: \(trackName)")
        
        // 指定した曲のImage URL
        var artworkUrl = musicAry[numForAry]["artworkUrl100"] as! String
        println("artworkUrl: \(artworkUrl)")
        
        // 指定した曲のPreview URL
        var previewUrl = musicAry[numForAry]["previewUrl"] as! String
        println("previewUrl: \(previewUrl)")

        showData(totalCount: totalCount, trackName: trackName, artworkUrl: artworkUrl)
        
        playMusic(previewUrl: previewUrl)
    }
    
    // Viewに表示 (更新) するメソッド
    func showData(#totalCount:Int, trackName:String, artworkUrl:String) {
        // LabelとImageViewにデータを表示
        var num = textField.text
        countLabel.text = "\(num) / \(totalCount)"
        
        trackNameLabel.text = trackName
        
        var url = NSURL(string: artworkUrl)
        var data = NSData(contentsOfURL: url!)
        var image = UIImage(data: data!)
        
        imageView.image = image
        
    }
    
    
    // 曲を再生するメソッド
    func playMusic(#previewUrl: String) {
        // AVFoundationを使用して曲を再生する
        var url = NSURL(string: previewUrl)
        player = AVPlayer(URL: url!)
        
        player.play()
    }
}

