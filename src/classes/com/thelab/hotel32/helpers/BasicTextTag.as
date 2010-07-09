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
	
	public class BasicTextTag extends Sprite
	{
		private var labelField								: TextField;
		private var labelFormat								: TextFormat;
		private var labelWidth								: Number;
		private var _size									: Number;
		
		public function BasicTextTag(s:String)
		{

			labelFormat = FontLibrary.getInstance().getFormat(FontLibrary.FUTURA_MEDIUM_FORMAT);
			labelFormat.letterSpacing = 3;
			labelFormat.size = 14;
			labelFormat.color = 0xFFFFFF;
			labelFormat.align = TextFormatAlign.CENTER;
			
			labelField = new TextField();
			labelField.antiAliasType = AntiAliasType.ADVANCED;
			labelField.autoSize = TextFieldAutoSize.LEFT;
			labelField.embedFonts = true;
			labelField.selectable = false;
			
			labelField.text = s.toUpperCase();
			labelField.setTextFormat(labelFormat);
					
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(labelField);
			
		}
		
		public function set size(val:Number):void
		{
			labelFormat.size = val;
			labelField.setTextFormat(labelFormat);
		}
		
		public function set text(s:String):void
		{
			labelField.text = s.toUpperCase();
			labelField.setTextFormat(labelFormat);
		}
	}
}