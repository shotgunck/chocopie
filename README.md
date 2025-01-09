# chocopie
jellyfin + rclone + docker, media server in one container

# About
This project can help you setup a Jellyfin media server and use `rclone` to mount your media files within your container.

Basically, Jellyfin will use your mounted storage inside the container to stream, so you don't have to use your local computer's drive for anything.

# Disclaimer
* This project does **not** use Jellyfin official docker image but `ubuntu 22.04` instead.

# Requirements
* Have Docker installed (Docker Desktop for example)
* Around 1-2 GB of free space for the docker image

# Setup
## 1. Clone/download this project
You can download this project as a zip or using git
```bash
git clone https://github.com/shotgunck/chocopie
```

## 2. Get `rclone.conf`
* Assume your media are stored on a Google Drive. Go to https://rclone.org/drive/ and do a basic setup. You can try `rclone mount` on your local computer once you're done.

* After that rclone will generate a `rclone.conf` that contains your Google Drive credentials.
* On Windows, it can be found at `C:\Users\your-user\AppData\Roaming\rclone`

**Important 1:** Note down the remote name of your Drive remote. Edit the `supervisord.conf` file at line 5:
```
...
command=rclone mount gdrive: <-- Change 'gdrive' to your remote name.
...
```

**Important 2:** If you're mounting on a custom mount point, also edit the `supervisord.conf`:
```
...
command=rclone mount gdrive: /media <-- Change '/media' to your custom path. Remember this path is within the container and not your local computer.

Additionally, you must modify 'mkdir -p /media' in the Dockerfile if you use custom path.
...
```

* Make a copy of that file and store it inside the project.
## 3. Build and run using Docker
* Make sure docker engine or service is running
* Open a terminal and use `cd` to go to the project
* Build the image (you can replace "chocopie" with any name)
```bash
docker build -t chocopie .
```
* Build and run the container
```bash
docker run -d --cap-add=SYS_ADMIN --device /dev/fuse -p 8096:8096 --name choco chocopie
```
Flags explanation:
```
-d: Run the container in background
--cap-add=SYS_ADMIN --device /dev/fuse: Enable fuse for rclone mounting
-p 8096:8096: open port 8096, which is where Jellyfin web GUI will be shown
--name choco: name of the container, replace with anything you like
chocopie is the name of the image you just built earlier. If you use a different name, you must replace the name in this command.
```
* Go to `http://localhost:8096`. If everything runs well, Jellyfin server setup page will show up.
## 4. Jellyfin server setup
You will see the "Welcome to Jellyfin!" screen at this moment.
* Click 'Next'
* On 'Tell us about yourself' screen: Enter your new username and password
* On 'Set up your media libraries' screen: Click 'Add Media Library'
* Content type: Movies (for movies) or Shows (for TV shows) or any type
* Display name should be automatically filled but you can change to your liking
* On 'Folders' session click the + button
* Right now rclone has mounted your Drive and your media on `/media`. Type `/media` or navigate to find the mount point. Then click 'Ok'
* Click 'Ok' again. Your new media library should show up now. Then click 'Next'
* 'Preferred Metadata Language': Change if you needed to. Then click 'Next'
* 'Set up remote access': Leave the settings be. Click 'Next'
* "You're done!": Click 'Finish'
* Jellyfin will reload and now you can sign in.
## 5. Troubleshoot
* If Jellyfin display the 'Select server' page: Try restarting the container, wait for a bit, then open `http://localhost:8096` on a **private tab**.
* Stream is slow: If you're using Google Drive, you should setup custom API on the Google Console.
* Media did not show up: Try 'Scan Metadata' on the library. If you're using custom mount point, make sure the path is correct.

# Afterwords
This project is just for fun. There are many better ways to host Jellyfin on your computer, but this method only require Docker to be installed.

If you managed to host the container on a cloud server, then you don't need to install anything on your computer at all.
