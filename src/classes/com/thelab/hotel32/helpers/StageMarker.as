package com.thelab.hotel32.helpers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class StageMarker extends Sprite
	{
		private var _color						: uint;
		private var label						: TextField;
		private var format						: TextFormat;
		
		public function StageMarker(c:Number=0x00FF00, theX:Number=0, theY:Number=0)
		{
			_color = c;
			x = theX;
			y = theY;
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			label = new TextField();
			label.selectable = false
			label.autoSize = TextFieldAutoSize.CENTER;
			label.height = 0;
			label.border = false;
			addChild(label);
			
			format = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.color = 0xFFFFFF;
			format.font = "_sans";
			format.size = 12;
			
			draw();
			
			addEventListener(MouseEvent.MOUSE_DOWN, onDragStart, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragEnd, false, 0, true);
		}
		
		private function onDragStart(e:MouseEvent):void
		{
			this.startDrag(false, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			addEventListener(Event.ENTER_FRAME, draw, false, 0, true);
		}
		
		private function onDragEnd(e:MouseEvent):void
		{
			this.stopDrag();
			removeEventListener(Event.ENTER_FRAME, draw);
		}
		
		private function draw(e:Event=null):void
		{
			label.text = x + " : " + y;
			label.x = -(Math.round(label.width * .5));
			label.y = -(Math.round(label.height * .5))-1;
			label.setTextFormat(format);
			
			graphics.clear();
			graphics.beginFill(_color, .7);
			graphics.drawRoundRectComplex(label.x -4, label.y - 4, label.width + 8, label.height + 8, 4, 4, 4, 4);
			
			graphics.lineStyle(1, 0xFFFFFF, .35);
			graphics.moveTo(0, -20);
			graphics.lineTo(0, 20);
			graphics.moveTo(-(label.width + 28)*.5, 0);
			graphics.lineTo((label.width + 28)*.5, 0)
		}
		
//		override public function set x(value:Number):void
//		{
//			x = value;
//			if (stage) { draw(); };
//		}
//		
//		override public function set y(value:Number):void
//		{
//			y = value;
//			if (stage) { draw(); };
//		}
	}
}