package com.thelab.hotel32.helpers
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Tag extends Sprite
	{
		private var _color						: uint;
		private var label						: TextField;
		private var format						: TextFormat;
		
		public function Tag(c:Number=0x666666)
		{
			_color = c;
			
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
			label.embedFonts = false;
			addChild(label);
			
			format = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.color = 0xFFFFFF;
			format.font = "_sans";
			format.size = 12;
			
			visible = false;
			alpha = 0;
			
			
		}
		
		public function draw(e:Event=null):void
		{
			x = Math.round(parent.width * .5);
			y = Math.round(parent.height * .5);
			
			label.text = parent.x + " : " + parent.y;
			label.x = -(Math.round(label.width * .5));
			label.y = -(Math.round(label.height * .5))-1;
			label.setTextFormat(format);
			
			graphics.clear();
			graphics.beginFill(_color, 1);
			graphics.drawRoundRectComplex(label.x -7, label.y - 4, label.width + 14, label.height + 8, 4, 4, 4, 4);
			
		}
		
		public function show():void
		{
			parent.setChildIndex(this as DisplayObject, parent.numChildren - 1);
			TweenMax.to(this, .25, { autoAlpha: 1 } );
		}
		
		public function hide():void
		{
			this.visible = false;
			this.alpha = 0;
		}
	}
}