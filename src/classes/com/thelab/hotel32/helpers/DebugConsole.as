package com.thelab.hotel32.helpers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class DebugConsole extends Sprite
	{
		private var console										: TextField;
		private var format										: TextFormat;
		
		private var lineCount									: int;
		
		public function DebugConsole()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			
			graphics.beginFill(0x00FF00, 1);
			graphics.drawRect(0, 0, 20, 20);
			
			console = new TextField();
			addChild(console);
			console.autoSize = TextFieldAutoSize.LEFT;
			
			format = new TextFormat();
			format.color = 0x00FF00;
			format.size = 18;
			format.align= TextFormatAlign.LEFT;
			
			lineCount = 0;
			
		}
		
		public function debug(val:String):void
		{
			if (val == "cls")
			{
				reset();
			}
			else
			{
				trace("\n"+val);
				console.appendText("\n"+val);
				lineCount ++;
				if (lineCount > 20)
				{
					reset();
				}
			}
			console.setTextFormat(format);
		}
		
		private function reset():void
		{
			console.text = "";
			lineCount = 0;
		}
	}
}