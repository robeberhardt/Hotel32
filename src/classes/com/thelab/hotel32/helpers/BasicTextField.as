package com.thelab.hotel32.helpers
{
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class BasicTextField extends TextField
	{
		private var _format : TextFormat;
		
		public function BasicTextField(theFormat:String, defaultText:String="BasicTextField!")
		{
			_format = FontLibrary.getInstance().getFormat(theFormat);
			this.defaultTextFormat = _format;
			this.embedFonts = true;
			this.textColor = 0xFFFFFF;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.multiline = false;
			this.selectable = false;
			this.mouseEnabled = false;
			this.text = defaultText;
			this.setTextFormat(_format);
			
		}
		
		public function reapplyFormat():void
		{
			this.setTextFormat(_format);
		}
				
		public function set size(val:Number):void
		{
			_format.size = val;
			this.setTextFormat(_format);
		}
		
		public function set color(val:Number):void
		{
			_format.color = val;
			this.setTextFormat(_format);
		}
		
		public function get format():TextFormat
		{
			return _format;
		}
	}
}