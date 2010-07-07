package com.thelab.hotel32.nav
{
	import com.thelab.hotel32.PhoneNumberClip;
	import com.thelab.hotel32.views.AppStage;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PhoneNumber extends MovieClip
	{
		private var phoneNumberClip : MovieClip;
		
		public function PhoneNumber()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			phoneNumberClip = new PhoneNumberClip();
			addChild(phoneNumberClip);
			x = 850;
			y = 604;
		}
		
	}
}