package com.thelab.hotel32.booking
{
	import com.thelab.hotel32.helpers.BasicButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	import com.thelab.hotel32.CheckRatesClip;
	
	public class CheckRatesButton extends BasicButton
	{
		private var asset : MovieClip;
		
		public function CheckRatesButton(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{	
			asset = new CheckRatesClip();
			asset.x = -asset.width;
			asset.y = -asset.height;
			addChild(asset);
			asset.gotoAndStop(2);
			active = true;
			alpha = 0;
			visible = false;
			//corner.visible = true;
		}
		
		override public function doRolledOver(e:MouseEvent):void
		{
			asset.gotoAndPlay(3);
		}
	}
}