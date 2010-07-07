package com.thelab.hotel32.helpers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CrossingGuard extends Sprite
	{
		
		private var holder 						: Sprite;
		
		private var _boundsTop 					: Number;
		private var _boundsLeft 				: Number;
		private var _boundsWidth 				: Number;
		private var _boundsHeight 				: Number;
		
		private var inkAlpha					: Number;
		private var inkColor					: Number;
		
		private static const BORDER				: Number = 500;
		
		private var mouseIsOver 				: Boolean; // true when the mouse is within the bounds
		
		public static const LEAVE_REGION		: String = "LEAVE_REGION";
		public static const ENTER_REGION		: String = "ENTER_REGION";
		
		
		public function CrossingGuard(boundsLeft:Number, boundsTop:Number, boundsWidth:Number, boundsHeight:Number, visible:Boolean = false, color:Number = 0x00FF00, opac:Number=1, theName:String="") 
		{
			_boundsTop = boundsTop;
			_boundsLeft = boundsLeft;
			_boundsWidth = boundsWidth;
			_boundsHeight = boundsHeight;
			
			if (visible) {
				inkAlpha = opac;
			} else {
				inkAlpha = 0;
			}
			
			inkColor = color;
			name = theName;
			init();
		}
		
		override public function toString():String
		{
			return "[CrossingGuard] " + name + "  x:" + x 
				+ " y:" + y + " width:" + _boundsWidth +  " height:" 
				+ _boundsHeight + " mouseIsOver:" + mouseIsOver;
		}
		
		private function init() : void
		{
			//name = "cGuard" + Math.floor(Math.random() * 10000).toString();
			
			x = _boundsLeft;
			y = _boundsTop;
			
			holder = new Sprite();
			holder.name = name;
			addChild(holder);
			
			mouseIsOver = false;
			
			draw();
			
			on();
			
		}
		
		public function onRollOver(e:MouseEvent=null):void 
		{
			mouseIsOver = !mouseIsOver;
			
			if (mouseIsOver) {
				dispatchEvent(new Event(ENTER_REGION));
			} else {
				dispatchEvent(new Event(LEAVE_REGION));
			}
			
			draw();
		}
		
		private function draw():void {
			holder.graphics.clear();
			holder.graphics.beginFill(inkColor, inkAlpha);
			holder.graphics.drawRect(0, 0, _boundsWidth, _boundsHeight);
			
			if (mouseIsOver) {
				holder.graphics.drawRect(-BORDER, -BORDER, _boundsWidth + (BORDER * 2), _boundsHeight + (BORDER * 2));
			}
		}
		
		public function flip() : void
		{
			mouseIsOver = !mouseIsOver;
			draw();
		}
		
		public function off() : void 
		{
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}
		
		public function on() : void
		{
			addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
		}
		
		public function get boundsWidth():Number { return _boundsWidth; }
		
		public function set boundsWidth(value:Number):void 
		{
			_boundsWidth = value;
			draw();
		}
	}
}