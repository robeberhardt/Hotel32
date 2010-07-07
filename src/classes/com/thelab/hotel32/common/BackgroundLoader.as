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
	
	public class BackgroundLoader extends Sprite
	{
		
		private var pageXML									: XMLList;
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
		
		
		public function BackgroundLoader(pageXML:XMLList)
		{
			this.pageXML = pageXML;
			
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
			
			for (var i:int = 0; i < pageXML..tabs..tab.length(); i++)
			{
				var tabQueue:LoaderMax = new LoaderMax( { name: pageXML..tabs..tab[i].@id.toString(), onComplete:bgLoadComplete, onError:bgLoadError } );
				
				for each (var image:XML in pageXML..tabs..tab[i]..image)
				{
					var url : String = AssetController.getInstance().basePath + image.@url.toString();
					
					var params:Object = new Object();
//					params.onProgress = progressHandler;
					params.onComplete = bgLoadComplete;
					params.onError = bgLoadError;
					params.name = image.@id.toString();
					params.estimatedBytes = Number(image.@bytes);
					
					tabQueue.append( new ImageLoader (url, params));					
				}
				
				queue.append(tabQueue);				
			}
			
			
		}
		
		public function getQueue(id:String):LoaderMax
		{
			return queue.getLoader(id) as LoaderMax;
		}
		
		public function load(tab:String, url:String):void
		{
			Logger.log("LOADING " + url + " from tab " + tab);
			readyForTransitionIn = false;
			var theTabQueue:LoaderMax = queue.getLoader(tab) as LoaderMax;
			theLoader = theTabQueue.getLoader(url) as ImageLoader;
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
	}
}