package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.thelab.hotel32.assets.AssetController;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;
	
	public class SimpleBackgroundLoader extends Sprite
	{
		
		private var pageData								: XMLList;
		private var queue									: LoaderMax;
		private var holderA									: Sprite;
		private var holderB									: Sprite;
		private var currentHolder							: Sprite;
		
		private var theLoader								: ImageLoader;
		
		public var transitionStarted						: Signal;
		public var transitionMiddle							: Signal;
		public var transitionFinished						: Signal;
		
		private var readyForTransitionIn					: Boolean;
		
		public static const TRANSITION_IN					: String = "TRANSITION_IN";
		public static const TRANSITION_OUT					: String = "TRANSITION_OUT";
		
		
		public function SimpleBackgroundLoader(data:XMLList)
		{
			pageData = data;
			Logger.log(this + " pageData = " + pageData);
			
			transitionStarted = new Signal();
			transitionMiddle = new Signal();
			transitionFinished = new Signal();
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			x = 86;
			
			holderA = new Sprite();
			holderA.visible = false;
			holderA.alpha = 0;
			addChild(holderA);
			
			holderB = new Sprite();
			holderB.visible = false;
			holderB.alpha = 0;
			addChild(holderB);
			
			currentHolder = holderA;
			
			queue = new LoaderMax( { name:"roomsBackground_loader" } );
			
			Logger.log("there are " + pageData..image.length() + " images.");
			for  (var i:int = 0; i < pageData..image.length(); i++)
			{
				var image:XML = pageData..image[i];
				Logger.log("image = " + image);
				var url: String = AssetController.getInstance().basePath + image.@url.toString();
				
				Logger.log(this + " -- " + image);
				var params:Object = new Object();
				params.name = image.@id.toString();
				params.onComplete = bgLoadComplete;
				params.onError = bgLoadError;
				params.estimatedBytes = Number(image.@bytes);
				
				Logger.log("appending loader " + params.name);
				queue.append(new ImageLoader(url, params));
			}	
		}
		
		public function getQueue(id:String):LoaderMax
		{
			return queue.getLoader(id) as LoaderMax;
		}
		
		public function load(name:String):void
		{
			Logger.log("LOADING " + name);
			readyForTransitionIn = false;
			theLoader = queue.getLoader(name) as ImageLoader;
			theLoader.load();
			transitionOut();
		}
		
		public function transitionOut():void
		{
			TweenMax.to(currentHolder, .5, { autoAlpha: 0, onComplete: checkForReady });
		}
		
		private function addContentToNextHolder():void
		{
			
			switch (currentHolder)
			{
				case holderA :
					currentHolder = holderB;
					break;
				
				case holderB :
					currentHolder = holderA;
					break;
				
			}
			
			currentHolder.visible = false;
			currentHolder.alpha = 0;
			while (currentHolder.numChildren > 0) { currentHolder.removeChildAt(0); }
			currentHolder.addChild(theLoader.rawContent);
			transitionMiddle.dispatch();
			transitionIn();
		}
		
		public function transitionIn():void
		{
			TweenMax.to(currentHolder, .5, { autoAlpha: 1 } );
		}
		
		public function checkForReady():void
		{
			Logger.log("Checking for ready -- it's " + readyForTransitionIn);
			
			if (readyForTransitionIn == true)
			{
				addContentToNextHolder();
			}
			else
			{
				readyForTransitionIn = true;
			}
		}
		
		private function bgLoadComplete(e:LoaderEvent):void
		{
			checkForReady();
		}
		
		private function bgLoadError(e:LoaderEvent):void
		{
			Logger.log("ERROR ERROR ERROR ERROR ERROR -- " + e, 3);
		}
		
		public function hide():void
		{
			TweenMax.to(this, .25, { autoAlpha: 0 } );
		}
		
		public function show():void
		{
			TweenMax.to(this, .25, { autoAlpha: 1 } );
		}
		
		override public function toString():String
		{
			return "[SimpleBackgroundLoader id: " + name + "]";
		}
	}
}