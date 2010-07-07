package com.thelab.hotel32.views.rooms
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.RoomsGridThumbClip;
	import com.thelab.hotel32.helpers.BasicButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class RoomsGridThumbButton extends BasicButton
	{
		private var asset								: MovieClip;
		
		public function RoomsGridThumbButton(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{	
			asset = new RoomsGridThumbClip();
			addChild(asset);
			alpha = 0.4;
			active = true;
		}
		
		override public function doRolledOver(e:MouseEvent):void
		{
			TweenMax.to(this, .25, { autoAlpha: 1 } );
		}
		
		override public function doRolledOut(e:MouseEvent):void
		{
			TweenMax.to(this, .25, { autoAlpha: 0.4 } );
		}
	}
}



