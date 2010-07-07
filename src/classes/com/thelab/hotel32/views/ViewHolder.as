package com.thelab.hotel32.views
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ViewHolder extends Sprite
	{
		private var viewMask						: Sprite;
		
		public static const CONTENT_TOP				: Number = 98;
		public static const CONTENT_WIDTH			: Number = 1194;
		public static const CONTENT_HEIGHT			: Number = 486;
		
		public function ViewHolder()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
	
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			y = CONTENT_TOP;
			
			viewMask = new Sprite();
			viewMask.graphics.beginFill(0x00FF00, .8);
			viewMask.graphics.drawRect(0, 0, CONTENT_WIDTH, CONTENT_HEIGHT);
			addChild(viewMask);
			mask = viewMask;
		}
	}
}