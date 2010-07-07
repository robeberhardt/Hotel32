package com.thelab.hotel32.helpers
{
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class BasicKnockoutTextField extends TextField
	{
		private var myFormat : TextFormat;
		
		public function BasicKnockoutTextField(defaultText:String = "")
		{
			super();
			
			myFormat = FontLibrary.getInstance().getFormat(FontLibrary.KNOCKOUT_FORMAT);
			myFormat.letterSpacing = 2;
			myFormat.size = 11;
			myFormat.color = 0xC99D72;
			myFormat.leading = 3;
			myFormat.align = TextFormatAlign.LEFT;
		
			this.defaultTextFormat = myFormat;
			this.text = defaultText;
			this.embedFonts = true;
			//this.textColor = 0xC99D72;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.multiline = true;
			this.selectable = false;
			this.setTextFormat(myFormat);
		}
		
		public function reapplyFormat():void
		{
			this.setTextFormat(myFormat);
		}
	}
}