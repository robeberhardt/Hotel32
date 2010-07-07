package com.thelab.hotel32.common
{
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.osflash.signals.Signal;
	
	public class PanelHeadline extends Sprite
	{
		private var field					: TextField;
		private var format					: TextFormat;
		
		public var changed					: Signal;

		public function PanelHeadline()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			changed = new Signal();
			
			x = 33;
			y = 39;
			
			format = new TextFormat();
			format.font = FontLibrary.FUTURA_STD_BOOK;
			format.size = 21;
			format.leading = 5;
			format.align = TextFormatAlign.LEFT;
			format.letterSpacing = 0.5;
			format.color = 0xFFFFFF;
			
			field = new TextField();
			addChild(field);
			field.selectable = false;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.multiline = true;
			field.wordWrap = true;
			field.width = 305;
			field.embedFonts = true;
			
		}
		
		public function get text():String
		{
			return field.text;
		}

		public function set text(value:String):void
		{
			Logger.log("setting panel headline to " + value, 3);
			field.text = value;
			field.setTextFormat(format);
			changed.dispatch();
		}
	}
}