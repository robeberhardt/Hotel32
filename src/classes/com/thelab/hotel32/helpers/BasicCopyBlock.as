package com.thelab.hotel32.helpers
{
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class BasicCopyBlock extends Sprite
	{
		private var field								: TextField;
		private var format								: TextFormat;
		
		public function BasicCopyBlock()
		{
			
			format = FontLibrary.getInstance().getFormat(FontLibrary.FUTURA_MEDIUM_FORMAT);
			format.letterSpacing = 1;
			format.size = 14;
			format.color = 0xFFFFFF;
			format.align = TextFormatAlign.LEFT;
			
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.wordWrap = true;
			field.embedFonts = true;
			field.selectable = false;
			field.multiline = true;
			field.text = "";
			field.setTextFormat(format);
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(field);
		}
		
		public function set size(val:Number):void
		{
			format.size = val;
			field.setTextFormat(format);
		}
		
		public function set text(s:String):void
		{
			field.text = s;
			field.setTextFormat(format);
		}
		
		public function set font(s:String):void
		{
			format.font = s;
			field.setTextFormat(format);
		}
		
		public function set fieldWidth(val:Number):void
		{
			field.width = val;
		}
	}
}