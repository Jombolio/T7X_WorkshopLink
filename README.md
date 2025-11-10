# T7X Workshop Maps / Mods

- *"Why can't I see my mods/maps?"* OR *"How do I join custom zombies servers?"* 

As of 0.0.3, t7x doesn't use Steam Infrastructure to make things more stable for everyone. Because of this, Workshop Content isn't accessible by t7x so some extra steps are needed to get it working such as moving/copying the workshop content and manually going through to rename maps to their respective short names (So Call of the Dead Remastered for example turns into `\zm_coast\` with the file structure looking something like `...\Call of Duty Black Ops III\usermaps\zm_coast\zm_coast.ff`). 

**Due to this being a pain in the ass for now, here's a script to instead use symlink to connect/link your Workshop Content Folder to t7x, meaning you're not having to keep duplicates in the game directory.**

NOTE, some maps/mods can't fundamentally work with t7x due to them calling functions that have been stripped (correct me if I'm wrong devs, I'll edit this).

# T7X Workshop Link instructions
### This method is strictly for Steam Usage and assumes you have your Custom Maps downloaded. This is NOT a replacement for FastDL.

## Client (If you don't know which one you are, this is you.)
1. Like `t7x.exe`, download [WorkshopLink.bat](https://jombo.uk/resources/WorkshopLink.bat) and move `WorkshopLink.bat` into the Steam Installation for Call of Duty: Black Ops III.

2. **WorkshopLink.bat as Administrator**, it will assume your Workshop folder is on the same drive as your Steam Installation. If it does not locate it, it will tell you. 
   __(RUN AS ADMINISTRATOR OTHERWISE IT WILL NOT WORK. IT NEEDS PERMISSIONS TO WRITE)__

3. It will begin connecting/linking your workshop folder into your Black Ops III directory which allows t7x to view each map/mod and have it named in a way that makes it compatible;
- Usermaps/Custom Maps : `...\Call of Duty Black Ops III\usermaps\`
- Mods/Tweaks : `...\Call of Duty Black Ops III\mods\`

### Mods 
Mods by default should have a connection/folder/symlink inside the `\Call of Duty Black Ops III\mods\` to your workshop content folder. Don't worry about the naming scheme inside the folder since it's parsed in-game. Again, **some mods might not work due to them having calling functions that t7x has stripped.**

## Dedicated Servers
1. Like `t7x.exe`, download [WorkshopLinkDedi.bat](https://jombo.uk/resources/WorkshopLinkDedi.bat) for Windows or [WorkshopLinkDedi.sh](https://jombo.uk/resources/WorkshopLinkDedi.sh) and move `WorkshopLinkDedi` into the Steam Installation for Call of Duty: Black Ops III.
Note - For Linux, make sure to make it executable with `chmod +x .\WorkshopLinkDedi.sh`

2. Locate your Workshop Content Folder for Call of Duty Black Ops III, it should be in `...\SteamLibrary\steamapps\workshop\content\311210\`, make sure to note the directory location. After, launch **WorkshopLink.bat as Administrator**. It will ask you for your Workshop Content Folder.
   *__(RUN AS ADMINISTRATOR OTHERWISE IT WILL NOT WORK. IT NEEDS PERMISSIONS TO WRITE)__*

3. Paste/enter your Workshop Content Folder, It will begin connecting/linking your workshop content folder in your Black Ops III directory which allows t7x to view each map/mod and have it named in a way that makes it compatible;
- Usermaps/Custom Maps : `...\Call of Duty Black Ops III\usermaps\`
- Mods/Tweaks : `...\Call of Duty Black Ops III\mods\`

### Mods 
Mods by default should have a connection/folder/symlink inside the `\Call of Duty Black Ops III\mods\` to your workshop content folder. Don't worry about the naming scheme inside the folder since it's parsed in-game. Again, **some mods might not work due to them having calling functions that t7x has stripped.**

## NOTES / FAQ
__"Will I need to run the script again if I download new maps or mods from Steam Workshop?"__
- Yes, you will need to run the script again if you download new mods/maps.