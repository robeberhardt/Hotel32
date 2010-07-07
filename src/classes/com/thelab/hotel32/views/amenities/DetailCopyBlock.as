package com.thelab.hotel32.views.amenities
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
	
	public class DetailCopyBlock extends Sprite
	{
		private var field								: TextField;
		private var format								: TextFormat;
		private var fieldMask							: Sprite;
		
		public function DetailCopyBlock(name:String="")
		{
			this.name = name;
			
			format = new TextFormat();
			format.font = FontLibrary.ARIAL_FORMAT;
			format.size = 11;
			format.align = TextFormatAlign.LEFT;
			format.color = 0xFFFFFF;
			format.letterSpacing = .8;
			format.leading = 6;
			
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.width = 450;
			field.wordWrap = true;
			field.multiline = true;
			field.selectable = false;
			field.embedFonts = true;
			
			fieldMask = new Sprite();
			fieldMask.graphics.beginFill(0xFF0000, .5);
			fieldMask.graphics.drawRect(0, 0, 450, 90);
			
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		override public function toString():String 
		{
			return "[DetailCopyBlock id=" + name + "]";
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(field);
			addChild(fieldMask);
			field.mask = fieldMask;
		}
		
		public function set text(val:String):void
		{
			field.text = val;
			field.setTextFormat(format);
		}
	}
}