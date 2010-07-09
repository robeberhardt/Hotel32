package com.thelab.hotel32.views.lounge
{
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.display.ContentDisplay;
	import com.thelab.hotel32.assets.AssetController;
	import com.thelab.hotel32.assets.PanoFrameAsset;
	import com.thelab.hotel32.common.CloseX;
	import com.thelab.hotel32.helpers.BasicButton;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.views.AppStage;
	import com.thelab.hotel32.views.FullScreenHolder;
	import com.thelab.hotel32.views.lounge.FullScreenButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class Panorama extends Sprite
	{
		private var panoData						: XMLList;
		private var queue							: LoaderMax;
		private var loader							: ImageLoader;
		
		public var ready							: Signal;
		public var closed							: Signal;
		
		private var asset							: MovieClip;
		private var image							: ContentDisplay;
		private var panoMask						: MovieClip;
		private var hitClip							: MovieClip;
		
		private var _active							: Boolean;
		private var move							: NativeSignal;
		private var center							: Point;
		private var speedX							: Number;
		private var speedY							: Number;
		
		private var holder							: Sprite;
		private var fsHolder						: Sprite;
		private var fsButton						: FullScreenButton;
		private var closeBox						: CloseX;
		
		public function Panorama(data:XMLList)
		{
			panoData = data;
			ready = new Signal();
			closed = new Signal();
			queue = new LoaderMax();
			
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			visible = false;
			alpha = 0;
			
			FullScreenHolder.getInstance().fullScreenSignal.add(onReturnFromFullScreen);
			
			move = new NativeSignal(this, Event.ENTER_FRAME, Event);
			
			var url:String = AssetController.getInstance().basePath + panoData..panoimage.@url.toString();
			var params:Object = new Object();
			params.name = panoData..panoimage.@id.toString();
			params.onComplete = loadComplete;
			params.onError = loadError;
			
			loader = new ImageLoader(url, params);
			queue.append(loader);
			
			holder = new Sprite();
			addChild(holder);
			
			fsHolder = new Sprite();
			fsHolder.graphics.beginFill(0x0000FF, 1);
			fsHolder.graphics.drawCircle(0, 0, 150);
			
			x = 86;
			y = 9;			
		}
		
		private function onReturnFromFullScreen():void
		{
			Logger.log("we're back from full screen");
			holder.addChildAt(image, numChildren-1);
			image.mask = panoMask;
			image.x = center.x - Math.floor(image.width * .5);
			image.y = center.y - Math.floor(image.height * .5);
			active = true;
		}
		
		private function loadComplete(e:LoaderEvent):void
		{
			image = loader.content;
			
			asset = new PanoFrameAsset();
			holder.addChild(asset.frame);
			holder.addChild(image);
			panoMask = asset.maskClip;
			holder.addChild(panoMask);
			image.mask = panoMask;
			hitClip = asset.hitClip;
			holder.addChild(hitClip);
			hitClip.alpha = 0;
			
			
			
			fsButton = new FullScreenButton("fullScreen");
			addChild(fsButton);
			fsButton.clickedSender.add(onFullScreenClicked);
			fsButton.x = hitClip.width - fsButton.width - 10;
			fsButton.y = hitClip.height - fsButton.height - 10;
			
			center = new Point(Math.floor(hitClip.width * .5), Math.floor(hitClip.height * .5));
//			Logger.log("     --->   CENTER = " + center);
			
//			var dot:Sprite = new Sprite();
//			addChild(dot);
//			dot.graphics.beginFill(0xFF0000, 1);
//			dot.graphics.drawCircle(center.x, center.y, 30);
			
//			var cornerMarker:Sprite = new Sprite();
//			cornerMarker.graphics.beginFill(0x00FF00, 1);
//			cornerMarker.graphics.drawRect(0, 0, 10, 10);
//			holder.addChild(cornerMarker);
			
			image.x = center.x - Math.floor(image.width * .5);
			image.y = center.y - Math.floor(image.height * .5);
			
//			Logger.log("  --> center = " + center);
			
			closeBox = new CloseX();
			closeBox.x = hitClip.width - closeBox.width - 10;
			closeBox.y = 10;
			holder.addChild(closeBox);
			closeBox.clickedSender.add(function() { closed.dispatch(); } );
			closeBox.show();
			
			ready.dispatch();
		}
		
		private function onFullScreenClicked(which:BasicButton):void
		{
//			Logger.log("YOU CLICKED FULL SCREEN");
			
			image.mask = null;
			
			FullScreenHolder.getInstance().goFull(image);
//			fsHolder.scaleX = image.width / stage.stageWidth;
//			fsHolder.scaleY = image.height / stage.stageHeight;
//			Logger.log("\n\nSCALE: " + fsHolder.scaleX + ", " + fsHolder.scaleY);
//			fsHolder.x = -AppStage.getInstance().center.x;
//			fsHolder.y = -AppStage.getInstance().center.y;
//			AppStage.getInstance().addChildAt(fsHolder, numChildren+1);
//			fsHolder.x = AppStage.getInstance().center.x;
//			fsHolder.y = AppStage.getInstance().center.y - stage.stageWidth;
//			fsHolder.x = -stage.stageWidth;
//			fsHolder.y = -stage.stageHeight;
			active = false;
			
		}
		
		private function loadError(e:LoaderEvent):void
		{
			Logger.log("error loading... " + e.text);
		}
		
		public function load():void
		{
			if (loader.status != LoaderStatus.COMPLETED) 
			{
				loader.load(); 
			}
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(val:Boolean):void
		{
			_active = val;
			if (_active)
			{
				Logger.log("MOVE = " + move);
//				if (move == null) { move = new NativeSignal(this, Event.ENTER_FRAME, Event); }
				move.add(onMove);
			}
			else
			{
				move.removeAll();
				//move = null;
			}
		}
		
		private function onMove(e:Event):void
		{
			var multiplier:Number = 10;
			var border:Number = 10;
			
			var speedX:Number = -(center.x - mouseX) / center.x;
			if (Math.abs(speedX) > 1) { (speedX < 0) ? speedX = -1 : speedX = 1; }
			
			var speedY:Number = -(center.y - mouseY) / center.y;
			if (Math.abs(speedY) > 1) { (speedY < 0) ? speedY = -1 : speedY = 1; }
			
			image.x -= (speedX * multiplier);
			if (image.x > border) { image.x = border; }
			if (image.x < -image.width - border + hitClip.width) { image.x = -image.width - border + hitClip.width; }
					
			image.y -= (speedY * multiplier);
			if (image.y > border) { image.y = border; }
			if (image.y < -image.height - border + hitClip.height) { image.y = -image.height - border + hitClip.height; }
			
			
//			Logger.log(image.x + " : " + image.y);
		}
		
		public function show():void
		{
			TweenMax.to(this, .5, { autoAlpha: 1 } );	
			active = true;
		}
		
		public function hide():void
		{
			TweenMax.to(this, .5, { autoAlpha: 0 } );
			active = false;
		}
		
		override public function toString():String
		{
			return "[ Panorama id: " + name + " ]";
		}
	}
}