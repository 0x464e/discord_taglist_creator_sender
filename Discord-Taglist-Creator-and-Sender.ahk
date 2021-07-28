#SingleInstance, Force
#NoTrayIcon

/*
Discord Taglist Creator & Sender
Made by Ox#0254

See the GitHub for more info and instructions
https://github.com/0x464e/discord_taglist_creator_sender
*/

Gui, % "-Resize"
Gui, Add, Edit, % "x5 y20 w280 h213 +Multi vInputTags", % "Uncheck ""From Clipboard"" to use this field`n`n" Clipboard
Gui, Add, Text, % "x5 y5 w100 h15", % "Input Tags"
Gui, Add, Checkbox, % "x290 y20 w100 h15 Checked vFromClipboard gFromClipboard", % "From Clipboard"
Gui, Add, Checkbox, % "x290 y40 w150 h15 vWYSIWYGCompatible", % "WYSIWYG Compatible"
Gui, Add, Checkbox, % "x290 y60 w150 h15 vPayPigNitro", % "Pay Pig Nitro"
Gui, Add, Checkbox, % "x290 y80 w100 h15 gAddLineBreaks vAddLineBreaks", % "Add Linebreaks"
Gui, Add, Checkbox, % "x290 y100 w100 h15 gInvisiblePadding vInvisiblePadding", % "Invisible Padding"
Gui, Add, Edit, % "x290 y120 w50 h20 vInvisPadCountAboveEdit"
Gui, Add, UpDown, % "Range1-1000 vInvisPadCountAbove", 50
Gui, Add, Text, % "x345 y123 w100 h15", % "Pads Above"
Gui, Add, Edit, % "x290 y143 w50 h20 vInvisPadCountBelowEdit"
Gui, Add, UpDown, % "Range1-1000 vInvisPadCountBelow", 50
Gui, Add, Text, % "x345 y145 w100 h15", % "Pads Below"
Gui, Add, Button, % "x290 y165 w100 h30 vParseInput gParseInput", % "Parse Input"
Gui, Add, Text, % "x290 y200 w100 h15 vPartCount", % "Parts: ?"
Gui, Add, Text, % "x290 y220 w200 h15 vLastPartLength", % "Last Part Length: ?"
Gui, Add, Checkbox, % "x150 y247 w105 h20 vActivateSender gActivateSender", % "Activate Sender"
Gui, Add, Text, % "x100 y275 w100 h20", % "Hotkey"
Gui, Add, Hotkey, % " x100 y295 w100 h20 vSendHotkey", % "F12"
Gui, Add, Text, % "x205 y275 w100 h15", % "Parts To Send"
Gui, Add, Edit, % "x205 y295 w100 h20 -Multi vPartsToSend", % "All"
Gui, Add, Button, % "x337 y265 w70 h25 gShowHelp", % "Help"
Gui, Add, Link, % "x330 y295" , % "<a href=""https://github.com/0x464e/discord_taglist_creator_sender"">Made by Ox#0254</a>"
Gui, Show, % "Center w425 h332", % "Discord Taglist Creator & Sender"

GuiControl, Disable, InputTags
GuiControl, Disable, InvisPadCountAbove
GuiControl, Disable, InvisPadCountAboveEdit
GuiControl, Disable, InvisPadCountBelow
GuiControl, Disable, InvisPadCountBelowEdit
GuiControl, Disable, ActivateSender

OnClipboardChange("ClipboardChange")
return

ESC::ExitApp

ParseInput()
{
	global InputTags, FromClipboard, WYSIWYGCompatible, PartCount, LastPartLength, ActivateSender, TagParts, ParseInput
	Gui, Submit, Nohide
	inp := FromClipboard ? Clipboard : InputTags
	TagParts := ParseTags(inp)
	GuiControl, , PartCount, % "Parts: " TagParts.Length()
	GuiControl, , LastPartLength, % "Last Part Length: " StrLen(TagParts[TagParts.Length()])
	if (TagParts.Length())
		GuiControl, Enable, ActivateSender
}

ParseTags(inp)
{
	global AddLineBreaks, WYSIWYGCompatible, InvisiblePadding, InvisPadCountAbove, InvisPadCountBelow, PayPigNitro
	ret := []
	, used := {}
	, fortnite := 1
	, mLen := 0
	, maxLength := PayPigNitro ? 4000 : 2000
	, inp := StrReplace(inp, "!")
	
	while (fortnite := RegexMatch(inp, "<@&?\d{15,20}>", match, fortnite + mLen))
		if((!used[match] && _ := !_) && StrLen((outp, mLen := StrLen(match), used[match] := "fortnite", match := (WYSIWYGCompatible ? RegExReplace(match, "@(?=\d)", "@!") : match) (AddLineBreaks ? "`n" : ""))) + StrLen(match)
		- (AddLineBreaks ? 1 : 0) + (InvisiblePadding ? StrLen(padsAbove := GenerateInvisPads(InvisPadCountAbove)) + StrLen(padsBelow := GenerateInvisPads(InvisPadCountBelow, false)) + !!InvisPadCountBelow * 1 : 0) > maxLength)
			ret.push(InvisiblePadding ? GenerateInvisPads(InvisPadCountAbove) outp (InvisPadCountBelow ? "`n" : "") GenerateInvisPads(InvisPadCountBelow, false) : (AddLineBreaks ? RTrim(outp, "`n") : outp))
			, outp := match, _ := __
		else if (_)
			outp .= match, _ := __
	
	return (outp ? (ret, ret.Push(InvisiblePadding ? GenerateInvisPads(InvisPadCountAbove) outp "`n" GenerateInvisPads(InvisPadCountBelow, false) : (AddLineBreaks ? RTrim(outp, "`n") : outp))) : ret)
}

GenerateInvisPads(count, above := true)
{
	if (!count)
		return
	Loop, % count - !above
		pads .= "`n"
	return above ? Chr(0x2800) pads : pads Chr(0x2800) ;U+2800 Braille Pattern Blank
}

FromClipboard()
{
	global FromClipboard
	Gui, Submit, NoHide
	GuiControl, % FromClipboard ? ("Disable", ClipboardChange(73)) : "Enable", InputTags
}

AddLineBreaks()
{
	global AddLineBreaks, InvisiblePadding
	Gui, Submit, NoHide
	if(AddLineBreaks)
	{
		GuiControl, , InvisiblePadding, 0
		GuiControl, Disable, InvisPadCountAbove
		GuiControl, Disable, InvisPadCountAboveEdit
		GuiControl, Disable, InvisPadCountBelow
		GuiControl, Disable, InvisPadCountBelowEdit
	}
}

InvisiblePadding()
{
	global AddLineBreaks, InvisiblePadding
	Gui, Submit, NoHide
	if(InvisiblePadding)
	{
		GuiControl, , AddLineBreaks, 0
		GuiControl, Enable, InvisPadCountAbove
		GuiControl, Enable, InvisPadCountAboveEdit
		GuiControl, Enable, InvisPadCountBelow
		GuiControl, Enable, InvisPadCountBelowEdit
	}
	else
	{
		GuiControl, Disable, InvisPadCountAbove
		GuiControl, Disable, InvisPadCountAboveEdit
		GuiControl, Disable, InvisPadCountBelow
		GuiControl, Disable, InvisPadCountBelowEdit
	}
}

ClipboardChange(Type)
{
	global InputTags, FromClipboard
	Gui, Submit, NoHide
	if (!FromClipboard)
		return
	GuiControl, , InputTags, % "Uncheck ""From Clipboard"" to use this field`n`n" (Type == 2 ? "" : Clipboard)
}

ActivateSender()
{
	global SendHotkey, PartsToSend, ActivateSender
	Gui, Submit, NoHide
	if (ActivateSender)
	{
		if (!SendHotkey)
		{
			MsgBox, % "Error:`nNo hotkey set"
			GuiControl, , ActivateSender, 0
			return
		}
		if (!(PartsToSend ~= "i)^(\s*all\s*|(\d+$|(\d+,?)+))$"))
		{
			MsgBox, % "Error:`n' " PartsToSend " ' was not recongnized as a valid list parts"
			GuiControl, , ActivateSender, 0
			return
		}
		
		GuiControl, Disable, SendHotkey
		GuiControl, Disable, PartsToSend
		GuiControl, Disable, ParseInput
		
		Hotkey, % SendHotkey, SendPart, On
	}
	else
	{
		GuiControl, Enable, SendHotkey
		GuiControl, Enable, PartsToSend
		GuiControl, Enable, ParseInput
		
		Hotkey, % SendHotkey, SendPart, Off
		SendPart(true)
	}
}

SendPart(reset := false)
{
	global TagParts, PartsToSend
	static _parts := [], i := 0, _indexes := {}
	if (reset)
	{
		_parts := [], i := 0, _indexes := {}
		return
	}
	
	if (!_parts.Length())
	{
		if (PartsToSend ~= "i)all")
			_parts := TagParts
		else
			for each, index in StrSplit(PartsToSend, ",")
				if (index && index <= TagParts.Length() && !_indexes[index])
					_parts.push(TagParts[index]), _indexes[index] := "fortnite"
	}
	Clipboard := ""
	Clipboard := _parts[Mod(i++, _parts.Length())+1]
	ClipWait, 2
	Send, % Chr(22) Chr(10)
}

ShowHelp()
{
	Run, % "https://github.com/0x464e/discord_taglist_creator_sender"
}

GuiClose()
{
	ExitApp
}