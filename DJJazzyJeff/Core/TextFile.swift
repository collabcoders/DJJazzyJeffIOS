//
//  TextFile.swift
//  User
//
//  Created by jigar on 11/01/21.
//

import Foundation
func languageChangeNotification(){
    str = Text()
    NotificationCenter.default.post(name: .languageUpdate, object: nil, userInfo: nil)
}

var str = Text()


struct Text {
//    var appName  = "DJJazzyJeff".localized()
    var VERSION = "VERSION".localized()
    var appLoading = "Loading...".localized()
    
    //OTHER TEXT
    var ok = "Ok".localized()


    //LOGIN PAGE
    var strEmail = "EMAIL".localized()
    var strPassword = "PASSWORD".localized()
    var strForgotPassword = "Forget your Password?".localized()
    var strSignIn = "MagMob Sign In".localized()
    var strSignUp = "Or, Join for Free".localized()

    var errorEmail = "Please enter email".localized()
    var errorValidEmail = "Please enter valid email".localized()
    var errorPassword = "Please enter password".localized()
    
    //FORGOT PASSWORD PAGE
    var strForgotPAsswordTitle = "Enter your account email and tap 'Send'".localized()
    var strForgotPassowrdSubmit = "Send".localized()
    var strForgotPassowrdCancel = "Cancel".localized()


    //SIGNUP PAGE
    var strFirstName = "FIRST NAME".localized()
    var strLastName = "LAST NAME".localized()
    var strPhone = "PHONE".localized()
    var strConfirmPass = "CONFIRM PASSWORD".localized()
    var strRegistration = "JOIN THE MAGMOB".localized()
    var strReturnSignIn = "Return to Sign In".localized()

    var errorFirstName = "Please enter first name".localized()
    var errorLastName = "Please enter last name".localized()
    var errorConfirmPassword = "Please enter confirm password".localized()
    var errorPasswordNotMatch = "The Password and Confirm Password do not match.".localized()
    var errorPhone = "Please enter phone number".localized()

    var strTitleSignup = "Join for Free".localized()
    var strMessageSignup = "\nThis is the official app of the legendary DJ Jazzy Jeff, the Magnificent House Party Livestream, and the Mag Mob VIP community.\n\nIn early 2020, Jeff began the Magnificent House Party (a.k.a. MHP) as a series of livestreams broadcasted online for people and fans (a.k.a. Mag Mob) to enjoy Jeff's music and turntable skills, from the safety of their own homes. Since its inception, MHP has produced over 300 exclusive DJ sets from Jeff and many of his legendary DJ friends.\n\nBecome a Mag Mob Member today and join the weekly scheduled MHP livestreams. Also get exclusive, on-demand access to the MHP archive (including audio streaming of shows and exclusive mixes), VIP access to special livestreams, special performances, shows, events, and more.".localized()



    //HOME
    var areYouSureYouWantToLogout = "Are you sure you want to Logout?".localized()
    var yes = "Yes".localized()
    var no = "No".localized()


    //APP ERROR
    var invalidRequestParamater = "Invalid request parameter".localized()
    var somethingWentWrong = "Something went wrong!".localized()
    var error = "Error".localized()
    
    //NO INTERNET
    var noNetTitle = "No Internet".localized()
    var noNetTitle2 = "Please check your network connectivity and try again".localized()
    var strRetry = "Retry".localized()

    
    //MENU SCREE
    var strLiveStream = "LIVESTREAM".localized()
    var strVideos = "VIDEOS".localized()
    var strMusic = "MUSIC".localized()
    var strStore = "STORE".localized()
    var strUpgrade = "UPGRADE".localized()
    var strFavorites = "FAVORITES".localized()
    var strSignOut = "SIGN OUT".localized()

    //HOME PAGE
    var strAllVideo = "FEATURED VIDEOS".localized()
    var strAllMusic = "FEATURED MUSIC".localized()
    
    //MUSIC PAGE
    var strSearch = "Search".localized()
    var strFavoriteAlert = "free members cannot create Favorites playlist. To upgrade tap the 'Upgrade' link on the home screen slide menu.".localized()
    var strSaveFavorite = "Music added to your Favorites.".localized()
    var strRemoveFavorite = "Music remove to your Favorites.".localized()

    var strMenuTitle = "Music Categories".localized()
    var strMenuAllMusic = "All Music".localized()
    var strMenuFeturedMixes = "Fetured Mixes".localized()
    var strMenuFetured = "Summertime Miztapes".localized()
    var strMenuFeturedMusic = "Fetured Music".localized()
    var strMenuJeeffs = "Jeff's Beetz".localized()
    var strMenuCancel = "Cancel".localized()
    
}
