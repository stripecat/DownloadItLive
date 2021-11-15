# DownloadItLive
A news downloader for PlayIt Live from PlayIt Software.

How to install

- Put the script in a folder on the broadcasting server.
- Run it once under as a user that has access to that folder.
- DownloadItLive will now create the folder structure.
- The successfully downloaded files will be in the newly created folder PublicFiles under the same path as the script was started in.
- Create a Scheduled Task that runs every hour 5 minutes before the broadcast will occur.
- Setup PIL accordingly. I guess a "Monitored folder" is a good start.
- All logs will be stored under Logs.


My own solution with PlayIt Live

I tried to use a "Monitored folder"-feature on PIL. It did work as intended, but I soon noticed it kept the file locked. This is probably
easy to fix. But I ended up solving the problem with a local webserver as I have one already for other purposes. I simply set the script
to download the newscast-file in a folder under the webserver's root. This makes it available over http. Then I created a "Remote URL" in PIL.
This is super robust, as it connects to something like http://localhost/news/FSNWorldNews.mp3. It will always work as no traffic will leave the
server itself. This off course requires PIL and the web server to run on the same host.

If you elect to do this, please remember:

- Setup the webserver to only listen to 127.0.0.1.
- Block port 80 in the firewall. No need to expose potentional attack surface.
- Make sure to patch the webserver! If you use IIS on Windows, your regular Windows-updates will cover this.
- Don't enable anything except static html on the webserver. This solution does not require ASPX, PHP or anything.
- Don't enable folder browsing. The URL of the "Remote URL" must lead directly to the file anyway.
- No need for https. It's local webserver that's not available outside the system.
- Enjoy timely and correct newscasts from your station!

Disclaimer

I take no responsibility for and problems and ill-effects of using this script. Please make sure to read through the manual and the script before using it. It should be pretty self-explanatory.