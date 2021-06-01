# RSS Feed Photo Editor

The application displays news from an RSS feed in one list.  

Pagination works(fake for xml)  

For each news, the application displays a headline and a picture.  

At the bottom of the screen is a set of buttons that apply various effects to images, such as b / w filter, sepia, blur, etc.  

When the corresponding filter is activated, it is applied to all images in the list.  

Notes:  
MVC  
FeedKit(RSS Parsing)  
Kingifsher(Image cache)  
CoreImage(CIFilter)  
 
The news uses its own image  

Applying an effect to images does not slow down the application:  
Advanced Concurrency: Async Operations [links](https://uynguyen.github.io/2020/05/16/iOS-Concurrency-Operations/)  

You can specify the data source (replace the RSS feed).


<img src="" width="300" height="650" />