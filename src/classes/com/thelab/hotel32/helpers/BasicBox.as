package com.thelab.hotel32.helpers
{
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class BasicBox extends Sprite
	{

		public var index											: uint;
		public var rolledOver										: NativeSignal;
		public var rolledOut										: NativeSignal;
		public var clicked											: NativeSignal;
		public var clickedSender									: Signal;
		
		private var _active											: Boolean;
				
		public function BasicBox(name:String=null)
		{
			this.name = name;
			
			clickedSender = new Signal();
			
			rolledOver = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			rolledOut = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }	
		}
		
		override public function toString():String
		{
			return "[BasicBox id: " + name + ", x: " + x + ", y: " + y + "]";
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			setup();
		}
		
		public function setup():void
		{
			//
		}
		
		public function doRolledOver(e:MouseEvent):void
		{
			Logger.log("you rolled over " + this, 1);
		}
		
		public function doRolledOut(e:MouseEvent):void
		{
			Logger.log("you rolled out of " + this, 2);
		}
		
		public function doClicked(e:MouseEvent):void
		{
			clickedSender.dispatch(this);
		}
		
		public function set active(val:Boolean):void
		{
			_active = val;
			if (_active)
			{
				rolledOver.add(doRolledOver);
				rolledOut.add(doRolledOut);
				clicked.add(doClicked);
			}
			else
			{
				rolledOver.remove(doRolledOver);
				rolledOut.remove(doRolledOut);
				clicked.remove(doClicked);
			}
		}
	}
}