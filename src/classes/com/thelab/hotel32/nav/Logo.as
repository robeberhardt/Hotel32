package com.thelab.hotel32.nav
{
	import com.thelab.hotel32.LogoAsset;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class Logo extends MovieClip
	{
		private var logoClip : MovieClip;
		private var rolledOver : NativeSignal;
		private var clicked : NativeSignal;
		public var clickedSender : Signal;
		
		private var _active						: Boolean;
		
		public function Logo()
		{
			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			clickedSender = new Signal();
			rolledOver = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			
			active = false;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			logoClip = new LogoAsset();
			addChild(logoClip);
			x = 111;
			
		}
		
		private function onRolledOver(e:MouseEvent):void
		{
			logoClip.gotoAndPlay(3);
		}
		
		private function onClicked(e:MouseEvent):void
		{
			clickedSender.dispatch();
			active = false;
		}


		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
			if (_active)
			{
				useHandCursor = true;
				buttonMode = true;
				clicked.add(onClicked);
				rolledOver.add(onRolledOver);
			}
			else
			{
				useHandCursor = false;
				buttonMode = false;
				clicked.remove(onClicked);
				rolledOver.remove(onRolledOver);
			}
		}

	}
}