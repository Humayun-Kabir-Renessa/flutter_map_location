# Flutter Map & Location (null safety)
this will show current location in map, at the same time it will show address of current location in text. **Geocoding** is used to convert location latitude & longitude into address
showing current time

## Instructions

- open **AndroidManifest.xml** and add below two lines

`<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`

`<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
    
- then add your Google API key inside `<application>`. You will find Google API key from [Google console](https://console.cloud.google.com/apis/credentials)

`<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY"/>`
    
- You may need to set minSdkVersion 20 at app level **build.gradle**
 
 
 [Credit goes to Rakhi](https://medium.com/flutterdevs/location-in-flutter-27ca6fa1126c)

