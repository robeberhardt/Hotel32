package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.CloseBox;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class CloseX extends MovieClip
	{
		private var asset								: MovieClip;
		public var clicked								: NativeSignal;
		public var clickedSender						: Signal;
		private var _active								: Boolean = false;
		
		
		public function CloseX()
		{
			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			clickedSender = new Signal();
		
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }	
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
//			graphics.beginFill(0x0000FF, 1);
//			graphics.drawRect(0, 0, 40, 40);
			
			asset = new CloseBox();
			addChild(asset);
			alpha = 0;
			visible = false;
			
//			active = false;
		}
		
		public function show():void
		{
			useHandCursor = true;
			buttonMode = true;
			TweenMax.to(this, .25, { autoAlpha: 1 } );
			clicked.add(onClicked);
		}
		
		public function hide():void
		{
			useHandCursor = false;
			buttonMode = false;
			TweenMax.to(this, .25, { autoAlpha: 0 } );
		}
		
		private function onClicked(e:MouseEvent):void
		{
			clickedSender.dispatch();
		}
	}
}