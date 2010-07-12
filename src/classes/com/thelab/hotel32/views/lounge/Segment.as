package com.thelab.hotel32.views.lounge
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Segment extends Sprite
	{
		private var color : uint;
		private var segWidth : Number;
		private var segHeight : Number;
		public var vx : Number = 0;
		public var vy : Number = 0;
		
		public function Segment(w:Number, h:Number, c:uint = 0xFF0000)
		{
			segWidth = w;
			segHeight = h;
			color = c;
			init();
		}
		
		private function init():void
		{
//			graphics.lineStyle(0);
			graphics.beginFill(color);
			graphics.drawRoundRect( -segHeight / 2, -segHeight / 2, segWidth + segHeight, segHeight, segHeight, segHeight);
			graphics.endFill();
			
//			graphics.drawCircle(0, 0, 2);
//			graphics.drawCircle(segWidth ,0, 2);
		}
		
		public function getPin():Point
		{
			var angle:Number = rotation * Math.PI / 180;
			var xPos : Number = x + Math.cos(angle) * segWidth;
			var yPos : Number = y + Math.sin(angle) * segWidth;
			return new Point(xPos, yPos);
		}
		
		public function getOrigin():Point
		{
			return new Point(x, y);
		}
	}
}