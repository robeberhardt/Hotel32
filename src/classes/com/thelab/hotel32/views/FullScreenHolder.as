package com.thelab.hotel32.views
{
	import com.greensock.TweenMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.thelab.hotel32.common.CloseX;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	import org.osflash.signals.Signal;
	
	public class FullScreenHolder extends Sprite
	{
		private static var instance					: FullScreenHolder;
		private static var allowInstantiation		: Boolean;
		
		private var _image							: ContentDisplay;
		private var closeBox						: CloseX;
		
		public var fullScreenSignal					: Signal;
				
		public function FullScreenHolder(name:String = "FullScreenHolder")
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use AssetLoader.getInstance()");
			} else {
				this.name = name;
				fullScreenSignal = new Signal();
				
				if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
			}
		}
		
		public static function getInstance(name:String = "FullScreenHolder"):FullScreenHolder {
			if (instance == null) {
				allowInstantiation = true;
				instance = new FullScreenHolder(name);
				allowInstantiation = false;
			}
			return instance;
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function goFull(image:ContentDisplay):void
		{
			
			
			
//			x = AppStage.getInstance().min.x;
//			y = AppStage.getInstance().min.y;
				
			_image = image;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			Logger.log("stageWidth: " + stage.stageWidth);
			Logger.log("stageHeight: " + stage.stageHeight);
			
			x = -(stage.stageWidth - AppStage.PUBLISH_WIDTH) * .5;
//			y = -(stage.stageHeight - AppStage.PUBLISH_HEIGHT) * .5;
			y = AppStage.getInstance().y;
			Logger.log(x + ", " + y);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenChange);
			
//			x = AppStage.getInstance().center.x - (stage.stageWidth * .5);
//			y = AppStage.getInstance().center.y - (stage.stageHeight * .5);
			
			graphics.clear();
			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			_image.alpha = 0;
			addChildAt(_image, 0);
			
			_image.scaleX = stage.stageWidth / _image.width;
			_image.scaleY = stage.stageHeight / _image.height;
			_image.x = 0;
			_image.y = 0;
			Logger.log("\n\nSCALE: " + scaleX + ", " + scaleY);
			
			TweenMax.to(_image, 2, { autoAlpha: 1 } );
			closeBox = new CloseX();
			closeBox.x = width - 10;
			closeBox.y = 10;
			addChild(closeBox);
			closeBox.clickedSender.add(onCloseClicked);
			closeBox.show();
			
			
//			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onCloseClicked():void
		{
			
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		private function onFrame(e:Event):void
		{
			Logger.log(mouseX + ", " + mouseY);
		}
		
		private function onFullScreenChange(e:FullScreenEvent):void
		{
			Logger.log("going back to normal");
			graphics.clear();
			removeChild(_image);
			//removeChild(closeBox);
//			removeEventListener(Event.ENTER_FRAME, onFrame);
			fullScreenSignal.dispatch();
		}
	}
}