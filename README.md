# Discord Taglist Creator & Sender
An AHK gui program to parse Discord tags from an input string and transform them to a desired output format for sending. As many parts as is required to be able to send all the tags are created.  
One part can fit up to 2000 <sub><sup>(or 4000 if you have the expensive Discord nitro)</sup></sub> characters can fit in one part.

![Image](https://i.imgur.com/67RGrXU.png)

## Getting  Started

### Installing
>**AutoHotkey is Windows only!**
* Install [AutoHotkey](https://www.autohotkey.com/)
* Download the `.ahk` file from this repository
* Run the the file by just double clicking it  
<sup><sub>(If the AHK installation would've somehow failed to associate `.ahk` files with the AHK interpreter, you can manually run `.ahk` files by just passing in the file to the interpreter, which is found in your AHK installation directory (usually `C:\Program Files\AutoHotkey\AutoHotkey.exe`))</sub></sup>

### Usage
* Obtain a list of Discord user/role tags in their raw format (`<@12345678910>`, `<@&12345678910>`)  
 [this](#getting-discord-tags) snippet can be used if you don't have better methods available. 
* Input your tags into the program either by just keeping it in your clipboard (`From Clipboard` option is ticked) or by pasting them into the big text input field
* Choose your desired settings:
	* **WYSIWYG Compatible**  
	Makes the output compatible with Discord's *new* WYSIWYG text input field.  
	Having this enabled will cost you one character extra per tag and will make everything quite a bit more laggy. I'd recommend disabling WYSIWYG <sub><sup>(you can disable from Settings ? Text & Images ? Use slash commands and preview emoj...)</sup></sub> and not having this option enabled. 
	* **Pay Pig Nitro**
	You're paying Discord $10 a month for the more expensive nitro, so you can use this option to use the 4000 character message length.
	* **Add Linebreaks**
	Adds a linebreak in-between each tag.  
	One tag per line.
	* **Invisible Padding**
	Adds the desired amount of pads (one pad is one empty line) above/below your tags.
* Hit `Parse Input` and your input will be parsed.  
You can see the amount of parts your message will require and the length of the last part.  
If you see that your last part has a lot of characters to go before reaching the message size limit, you might want to tweak your settings (e.g add more invisible padding) to get the most out of however many parts your taglist will require.  
Remember to re-parse after changing settings.
* When you're happy with your parts, choose settings for the sender:
	* **Hotkey**
	Hotkey which will trigger the part-in-turn to be sent.
	* **Parts To Send**
	Indicates which parts you want to send.  
	Either the literal word `all` to send all parts, or a comma separated list of part numbers.  
	E.g. your taglist requires 6 parts and you want to send them half and half with your friend. You will input `1,2,3` and your friend will input `4,5,6`.
* Activate the sender by ticking the checkbox and press your desired hotkey in the Discord text input field repeatedly to send your tags.  
 Disable the sender if you want to make any changes.

### Getting Discord tags
I can provide a basic javascript snippet you can use with BetterDiscord, but more advanced/better implementations will be kept private for now.

To use these, simply paste the function(s) into your console and use them like `getTags("12345678910")`.  
For getting user tags, you will have to cache the members first by e.g scrolling the online members list.
```js
function getTags(guildId, WYSIWYG = false)
{
	let { GuildStore, GuildMemberStore, UserStore } = ZLibrary.DiscordModules;
	let guild = GuildStore.getGuild(guildId);
	let currentUser = UserStore.getCurrentUser().id;
	let members = GuildMemberStore.getMembers(guildId);
	
	let tagList = "";
	
	for (let member of members)
	{
		let m = UserStore.getUser(member.userId);
		
		if (m.bot)
			continue;
		if (m.id == currentUser)
			continue;
		
		tagList += "<@" + (WYSIWYG ? "!" : "") + m.id + ">";
	}
	
	let info = `Users: ${tagList.split("@").length - 1}
Character Count: ${tagList.length}
Parts Needed: ${Math.ceil(tagList.length / 2000)}`;
	
	console.log(info);
	console.log(tagList);
}

function getRoles(guildId, onlyMentionable = false)
{
	let { GuildStore, GuildMemberStore } = ZLibrary.DiscordModules;
	let guild = GuildStore.getGuild(guildId);
	let roles = Object.values(guild.roles);
	roles.sort((role1, role2) => { return role2.position - role1.position });
	
	let roleTagList = "";
	
	for (let role of roles)
	{
		if (!role.position)
			continue;
		if (onlyMentionable && !role.mentionable)
			continue;
		
		roleTagList += `<@&${role.id}>`;
	}
	
	let info = `Users: ${roleTagList.split("@").length - 1}
Character Count: ${roleTagList.length}
Parts Needed: ${Math.ceil(roleTagList.length / 2000)}`;
	
	console.log(info);
	console.log(roleTagList);
}
```
