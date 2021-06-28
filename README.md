# map_location

**this will show current location in map
at the same time it will show address of current location in text
Geocoding is used to convert location latitude & longitude into address
showing current time**

## Instructions

- 1. open AndroidManifest.xml and add below two lines
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
- 2. then add your Google API key inside <application>
    <meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY"/>
    
- 3. You may need to set minSdkVersion 20 at app level build.gradle`
 
 
 [Credit](https://medium.com/flutterdevs/location-in-flutter-27ca6fa1126c)

