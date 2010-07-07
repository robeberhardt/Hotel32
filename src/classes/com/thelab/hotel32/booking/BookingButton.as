package com.thelab.hotel32.booking
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.BookRoomClip;
	import com.thelab.hotel32.helpers.BasicButton;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.views.AppStage;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BookingButton extends BasicButton
	{
		private var asset : MovieClip;
		
		public function BookingButton(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{	
			asset = new BookRoomClip();
			addChild(asset);
			asset.gotoAndStop(2);
			active = true;
			x = 951;
			y = 25;
			alpha = 0;
			visible = false;
		}
		
		override public function doRolledOver(e:MouseEvent):void
		{
			asset.gotoAndPlay(3);
		}
		
//		override public function doClicked(e:MouseEvent):void
//		{
//			Logger.log("YOU CLICKED THE " + this);
//		}
	}
}