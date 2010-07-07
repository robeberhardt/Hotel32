package com.thelab.hotel32.slideshow
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.thelab.hotel32.assets.AssetLoader;
	import com.thelab.hotel32.helpers.BasicKnockoutTextField;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Slide extends Sprite
	{	
		private var _assetPath							: String;
		private var basePath							: String;
		private var _image								: Bitmap;
		private var myTimeline							: TimelineMax;
		private var timing								: XMLList;
		private var theShow								: SlideShowController;
		public var loaded								: Boolean = false;
		private var _id									: int;
		
		private var slideWidth							: int;
				
		public static const SLIDE_LOADED				: String = "SLIDE_LOADED";
		public static const SLIDE_FADEIN_COMPLETE		: String = "SLIDE_FADEIN_COMPLETE";
		public static const SLIDE_FADEOUT_COMPLETE		: String = "SLIDE_FADEOUT_COMPLETE";
		
		public function Slide(show:SlideShowController, assetPath:String, id:int, w:int) 
		{
			_id = id;
			_assetPath = assetPath;
			theShow = show;
			basePath = AssetLoader.getInstance().basePath;
			alpha = 0;
			visible = false;
			timing = theShow.timing;
			slideWidth = w;
		}
		
		public function load():void
		{
			AssetLoader.getInstance().load(basePath + "/" + _assetPath, onAssetLoaded);
		}
		
		private function onAssetLoaded(e:Event):void
		{
			_image = AssetLoader.getInstance().loader.getBitmap(basePath + "/" + _assetPath);
			addChild(_image);
			loaded = true;
			
			dispatchEvent(new Event(SLIDE_LOADED));
		}
		
		override public function toString():String
		{
			return "\n[SLIDE asset=\'" + _assetPath + "\' + id=\'" + _id + "\']\n";
		}
	
		public function show():void
		{
			TweenMax.to(this, timing..fadeIn, { autoAlpha: 1 });
			TweenMax.delayedCall(timing..hold, slideComplete);
		}
		
		private function slideComplete():void
		{
			dispatchEvent(new Event(Slide.SLIDE_FADEIN_COMPLETE));
		}
		
		public function hide():void
		{
			TweenMax.to(this, timing..fadeOut, { autoAlpha: 0, onComplete: sendCompleteEvent });
		}
		
		private function sendCompleteEvent():void
		{
			dispatchEvent(new Event(Slide.SLIDE_FADEOUT_COMPLETE));
		}
	}
}