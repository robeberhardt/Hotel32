package com.thelab.hotel32.helpers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class DragSprite extends Sprite
	{
		private var myTag : Tag;
		public var draggable : Boolean;
		
		public function DragSprite()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, setupListeners, false, 0, true); }
		}
		
		public function setupListeners(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(MouseEvent.MOUSE_DOWN, onDragStart, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragEnd, false, 0, true);
			
			myTag = new Tag();
			addChild(myTag);
			
			init();
		}
		
		public function init():void
		{
			//
		}
		
		private function onDragStart(e:MouseEvent):void
		{
			if (draggable)
			{
				this.startDrag(false, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
				addEventListener(Event.ENTER_FRAME, traceStatus, false, 0, true);
				myTag.show();
			}
		}
		
		private function onDragEnd(e:MouseEvent):void
		{
			this.stopDrag();
			removeEventListener(Event.ENTER_FRAME, traceStatus);
			myTag.hide();
		}
		
		private function traceStatus(e:Event):void
		{
			myTag.draw();
		}
	}
}