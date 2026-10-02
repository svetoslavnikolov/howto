# How to create Windows ICONS

## Tools
* Program to edit graphics. <br>
  `PowerPoint` is a fine example.
* Image Magick <br>
  If you do not have image magick in Windows, install it:
  ```
  winget install -e ImageMagick.ImageMagick
  ```  

## Create icon
1. Save an image as PNG. The bigger the image, the better.
2. Create versions with different sizes:

```
magick icon_master.png -resize 256x256 icon256.png
magick icon_master.png -resize 48x48  icon48.png
magick icon_master.png -resize 32x32  icon32.png
magick icon_master.png -resize 16x16  icon16.png
```

3. Combine all PNG files in one ICON file:

```
magick icon16.png icon32.png icon48.png icon256.png TasksAndMore.ico
```


