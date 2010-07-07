package com.thelab.hotel32.helpers
{	
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;

	public class Tracker extends Sprite
	{
		private static var instance					: Tracker;
		private static var allowInstantiation		: Boolean;
		
		public function Tracker(name:String = "Tracker")
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use Tracker.getInstance()");
			} else {
				this.name = name;
			}
		}
		
		public static function getInstance(name:String = "Tracker"):Tracker {
			if (instance == null) {
				allowInstantiation = true;
				instance = new Tracker(name);
				allowInstantiation = false;
			}
			return instance;
		}
	
		public function track(trackingString:String):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("trackFlash", trackingString);
			}
		}
	}
}