package com.thelab.hotel32.helpers
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class BasicButton extends MovieClip
	{
		public var rolledOver										: NativeSignal;
		public var rolledOut										: NativeSignal;
		public var clicked											: NativeSignal;
		public var clickedSender									: Signal;
		
		private var _active											: Boolean;
		
		public var corner											: Sprite;
		
		public function BasicButton(name:String=null)
		{
			this.name = name;
			clickedSender = new Signal();
			rolledOver = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			rolledOut = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			corner = new Sprite();
			addChild(corner);
			corner.graphics.beginFill(0x00ff00, 1);
			corner.graphics.drawCircle(0, 0, 5);
			corner.visible = false;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			setup();
		}
		
		public function setup():void
		{
			// override in subclass
		}
	
		override public function toString():String
		{
			return "[BasicButton id: " + name + "]";
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
				useHandCursor = true;
				buttonMode = true;
			}
			else
			{
				rolledOver.remove(doRolledOver);
				rolledOut.remove(doRolledOut);
				clicked.remove(doClicked);
				useHandCursor = false;
				buttonMode = false;
			}
		}
		
		public function show():void
		{
			TweenMax.to(this, .5, { autoAlpha: 1 } );
		}
		
		public function hide():void
		{
			TweenMax.to(this, .5, { autoAlpha: 0 } );
		}
	}
}