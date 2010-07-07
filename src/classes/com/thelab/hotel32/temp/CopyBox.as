package com.thelab.hotel32.temp
{
	import com.thelab.hotel32.CopyBoxAsset;
	import com.thelab.hotel32.helpers.DragSprite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CopyBox extends DragSprite
	{
		private var asset : MovieClip;
		
		public function CopyBox()
		{
			super();
		}
		
		override public function init():void
		{	
			asset = new CopyBoxAsset();
			addChild(asset);
			x = 748;
			y = 18;
			draggable = false;
		}
	}
}