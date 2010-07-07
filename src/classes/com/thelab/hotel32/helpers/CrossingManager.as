package com.thelab.hotel32.helpers{
	//
	import com.thelab.hotel32.assets.AssetLoader;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;

	//
	public class CrossingManager extends Sprite{
		//
		public var hitRect:Sprite;
		private var showingContainer:Boolean = false;
		//private var _model:Model;
		private var isHitting:Boolean = false;
		private var bookingInteraction:Boolean = false;
		//
		public static const LEAVE_REGION		: String = "LEAVE_REGION";
		public static const ENTER_REGION		: String = "ENTER_REGION";
		public static const STOP_PAUSING		: String = "STOP_PAUSING";
		public static const HIDE_PROMOS			: String = "HIDE_PROMOS";
		public static const START_BOOKING_INTERACTION : String = "START_BOOKING_INTERACTION";
		//
		public function CrossingManager(){
			//addEventListener(Event.ADDED_TO_STAGE, init);
		}
		//initialized in main.as
		public function init(e:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			y = 4;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			onStageResize();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMotion);
			//stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			//
			hitRect = new Sprite();
			hitRect.graphics.beginFill(0xFF0000,0);
			hitRect.graphics.drawRect(-20,-10,450,80);
			hitRect.graphics.endFill();
			addChild(hitRect);
		}
		
		// this function is called when we turn bm interaction back on
		public function testForHit():void
		{
			trace(" TESTING FOR HIT");
			if (hitRect.hitTestPoint(stage.mouseX, stage.mouseY))
			{
				trace("   hit was true!");
				var myTimer:Timer = new Timer(1000);
				myTimer.addEventListener(TimerEvent.TIMER, onDelayTimer, false, 0, true);
				myTimer.start();
			} else
			{
				trace("   hit was FALSE");
			}
		}
		
		private function onDelayTimer(e:Event):void
		{
			e.target.removeEventListener(TimerEvent.TIMER, onDelayTimer);
			dispatchEvent(new Event(ENTER_REGION));
		}
		
		public function addMouseLeaveEvent():void
		{
			trace("adding mouse leave event...");
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		public function removeMouseLeaveEvent():void
		{
			trace("removing mouse leave event...");
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		//
		private function onMouseMotion(e:MouseEvent):void{
			if(hitRect.hitTestPoint(stage.mouseX, stage.mouseY)){
				if(!showingContainer){
					if(!bookingInteraction){
						showContainer();
					}
				}
				isHitting = true;
			}else{
				if(showingContainer){
					hideContainer();
				}
				isHitting = false;
			}
		}
		//when interacting with booking module
		public function onMouseLeave(e:Event=null):void{
			hideContainer();
		}
		public function onStartInteracting(e:Event=null):void{
			//trace("onStartInteracting");
			hideContainerNoEvent();
			bookingInteraction = true;
		}
		public function onStopInteracting(e:Event=null):void{
			//trace("onSTOPInteracting");
			if(isHitting){
				//trace("whoop");
				//showContainer();
				hidePromos()
			}
			stopPausing();
			bookingInteraction = false;
		}
		//
		public function stopPausing():void{
			dispatchEvent(new Event(STOP_PAUSING));
		}
		public function hidePromos():void{
			dispatchEvent(new Event(HIDE_PROMOS));
		}
		//
		public function showContainer():void{
			showingContainer = true;
			hitRect.height = 300;
			dispatchEvent(new Event(ENTER_REGION));
		}
		public function hideContainer():void{
			showingContainer = false;
			hitRect.height = 80;
			dispatchEvent(new Event(LEAVE_REGION));
		}
		public function hideContainerNoEvent():void{
			showingContainer = false;
			hitRect.height = 80;
			dispatchEvent(new Event(START_BOOKING_INTERACTION));
		}
		
		private function onStageResize(e:Event=null):void
		{
			if (stage.stageWidth < AssetLoader.PUBLISH_WIDTH)
			{
				x = Math.round((AssetLoader.PUBLISH_WIDTH-stage.stageWidth)*.5);
			}
			else
			{
				x = 10;
			}
		}
	}
}