package com.thelab.hotel32.views.lounge
{
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Panorama extends Sprite
	{
		private var queue							: LoaderMax;
		private var holder							: Sprite;
		private var mask							: Sprite;
		
		public function Panorama(name:String="")
		{
			this.name = name;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE);
			
			x = 86;
			holder = new Sprite();
			addChild(holder);
//			mask = new Sprite();
		}
		
		public function load(url:String):void
		{
			
			queue.append(new ImageLoader(
		}
		
		override public function toString():String
		{
			return "[ Panorama id: " + name + " ]";
		}
	}
}