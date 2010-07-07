package com.thelab.hotel32.nav
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.thelab.hotel32.LegalCopyClip;
	
	public class LegalCopy extends MovieClip
	{
		private var legalCopyClip : MovieClip;
		
		public function LegalCopy()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			legalCopyClip = new LegalCopyClip();
			addChild(legalCopyClip);
			x = 110;
			y = 603;
		}
		
	}
}