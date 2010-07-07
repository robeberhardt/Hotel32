package com.thelab.hotel32.views
{
	import com.greensock.loading.display.ContentDisplay;
	import com.thelab.hotel32.assets.AssetLoader;
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	import com.thelab.hotel32.helpers.BasicTextField;
	
	import flash.display.Bitmap;
	import flash.events.Event;

	public class SpaView extends BasicView
	{
		public function SpaView(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{
			assetsLoaded.addOnce(onAssetsLoaded);
			loadAssets();
		}
		
		private function onAssetsLoaded():void
		{
			var spa:ContentDisplay = queue.getContent("spa");
			addChild(spa);
			sendReady();
		}
	}
}