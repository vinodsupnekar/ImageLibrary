# ImageLibrary
 
Following Features are covered inside Image Library:-

1. Get all events from mail url api

2. Populate home screen with all images asynchronously into a 3*3 grid.

3. Images are loaded asynchronously first preference is to Disk Memory and if no data found into Disk, 
  We hit to server with image url
 
4. I have used prefetching mechanism of Collectionview to make loading content into cells smoother.

5. Unwanted backend api calls are cancelled in not needed when view goes out of view of user.
