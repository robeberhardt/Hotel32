package com.thelab.hotel32.views.video
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.thelab.hotel32.assets.AssetLoader;
	import com.thelab.hotel32.helpers.DebugConsole;
	import com.thelab.hotel32.helpers.GradientBox;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class VideoBackgroundImage extends Sprite
	{
		private var _data										: XMLList;
		private var posterWidth									: Number;
		private var posterHeight								: Number;
		private var _assetPath									: String;
		private var caret										: MovieClip;
		private var image										: Bitmap;
		private var dimmer										: Sprite;
		private var theCTA										: VideoCTAButton;
		private var _ctaText									: String;
		private var _ctaReplayText								: String;
		
		private var replayMode									: Boolean = false;
		
		private var console										: DebugConsole;
				
		private var coverClip									: MovieClip;
		
		private var eTime : int = 1;
		
		public static const VIDEO_CTA_CLICKED					: String = "VIDEO_CTA_CLICKED";
		public static const HIDE_COMPLETE						: String = "HIDE_COMPLETE";
		public static const VIDEO_HEIGHT_DOWN					: String = "VIDEO_HEIGHT_DOWN";
		public static const VIDEO_HEIGHT_UP						: String = "VIDEO_HEIGHT_UP";
				
		public function VideoBackgroundImage(data:XMLList, swfAsset:MovieClip, ctaText:String, ctaReplayText:String)
		{
			_data = data;
			_assetPath = AssetLoader.getInstance().basePath + "/" + _data.posterimage.toString();
			caret = swfAsset.caret;
			_ctaText = ctaText;
			_ctaReplayText = ctaReplayText;
			coverClip = swfAsset.coverClip;
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }			
		}
				
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			AssetLoader.getInstance().load(_assetPath, onAssetLoaded);
		}
		
		public function hideButtons():void
		{
			TweenMax.to(theCTA, .5, { autoAlpha: 0 });
			dim();
		}
		
		public function showButtons():void
		{
			TweenMax.to(theCTA, .5, { autoAlpha: 1 });
			undim();
		}

		private function onAssetLoaded(e:Event):void
		{
			image = AssetLoader.getInstance().loader.getBitmap(_assetPath);
			image.visible = false;
			image.alpha = 0;
			addChild(image);
			
			posterWidth = image.width;
			posterHeight = image.height;

			x = Math.abs((AssetLoader.PUBLISH_WIDTH - posterWidth)*.5);
			if (posterWidth > AssetLoader.PUBLISH_WIDTH)
			{
				x = -x;
			}
			
//			graphics.beginFill(0xFF0000, .25);
//			graphics.drawRect(0, 0, posterWidth, posterHeight);
			
			var colorOne:Number = Number(AssetLoader.getInstance().mainXML..slideshow.topgradient.colorOne);
			var colorTwo:Number = Number(AssetLoader.getInstance().mainXML..slideshow.topgradient.colorTwo);
			var alphaOne:Number = Number(AssetLoader.getInstance().mainXML..slideshow.topgradient.alphaOne);
			var alphaTwo:Number = Number(AssetLoader.getInstance().mainXML..slideshow.topgradient.alphaTwo);
			var mp:Number = Number(AssetLoader.getInstance().mainXML..slideshow.topgradient.midpoint);
			var r:Number = Number(AssetLoader.getInstance().mainXML..slideshow.topgradient.rotation);
			var gradHeight:Number = Number(AssetLoader.getInstance().mainXML..slideshow.topgradient.height);
			var topGradient:GradientBox = new GradientBox(1400, gradHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
			addChild(topGradient);
			
			dimmer = new Sprite();
			dimmer.graphics.beginFill(0x000000, 1);
			dimmer.graphics.drawRect(0, 0, image.width, image.height);
			addChild(dimmer);
			dimmer.alpha = 0;
			
			theCTA = new VideoCTAButton(caret);
			theCTA.y = 180;
			theCTA.addEventListener(VideoCTAButton.VIDEO_CTA_CLICKED, hide, false, 0, true);
			addChild(theCTA);
			
			theCTA.setup(_ctaText);
			theCTA.x = Math.round(posterWidth * .5 - (theCTA.width * .5));
			
			makeVignettes();
			
			coverClip.x = 0;
			coverClip.y = 540 - coverClip.height;
			addChild(coverClip);
			
			
			
			show();
		}
		
		private function makeVignettes():void
		{
			var vignetteHolder : Sprite = new Sprite();
			addChild(vignetteHolder);
			
			if (_data..posterimage.@topVig == "true")
			{
				var colorOne:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.colorOne);
				var colorTwo:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.colorTwo);
				var alphaOne:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.alphaOne);
				var alphaTwo:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.alphaTwo);
				var mp:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.midpoint);
				var r:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.rotation);
				var gradHeight:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.height);
				var topVignette:GradientBox = new GradientBox(posterWidth, gradHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
				vignetteHolder.addChild(topVignette);
				
			}
			
			if (_data..posterimage.@bottomVig == "true")
			{
				colorOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.colorOne);
				colorTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.colorTwo);
				alphaOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.alphaOne);
				alphaTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.alphaTwo);
				mp = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.midpoint);
				r = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.rotation);
				gradHeight = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.height);
				var botVignette:GradientBox = new GradientBox(posterWidth, gradHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
				vignetteHolder.addChild(botVignette);
				
				botVignette.y = posterHeight - gradHeight;
			}
			
			if (_data..posterimage.@leftVig == "true")
			{
				colorOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.colorOne);
				colorTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.colorTwo);
				alphaOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.alphaOne);
				alphaTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.alphaTwo);
				mp = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.midpoint);
				r = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.rotation);
				gradHeight = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.height);
				var leftVignette:GradientBox = new GradientBox(gradHeight, posterHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
				vignetteHolder.addChild(leftVignette);
				
				
			}
			
			if (_data..posterimage.@rightVig == "true")
			{
				colorOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.colorOne);
				colorTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.colorTwo);
				alphaOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.alphaOne);
				alphaTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.alphaTwo);
				mp = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.midpoint);
				r = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.rotation);
				gradHeight = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.height);
				var rightVignette:GradientBox = new GradientBox(gradHeight, posterHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
				vignetteHolder.addChild(rightVignette);
				rightVignette.x = posterWidth - gradHeight;
			}
			
		}
		
		/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		*
		*                          Misc.
		*
		* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
		
		private function dim():void
		{
			TweenMax.to(dimmer, .5, { alpha: .8 });
		}
		
		private function undim():void
		{
			TweenMax.to(dimmer, .5, { alpha: 0 });
		}
		
		public function rollDown():void
		{
			TweenMax.to(coverClip, .5, { y:540, ease:Quad.easeIn });
		}
		
		public function rollUp():void
		{
			TweenMax.to(coverClip, .5, { y:540 - coverClip.height, ease:Quad.easeOut });
			undim();
		}
		
		public function show(replayMode:Boolean = false):void
		{
			if (replayMode)
			{
				theCTA.setup(_ctaReplayText);
				rollUp();
				dispatchEvent(new Event(VIDEO_HEIGHT_UP));
			}
			TweenMax.to(image, 1, { autoAlpha: 1 });
			TweenMax.to(theCTA, 1, { delay: 0.25, autoAlpha: 1 });
		}
		
		public function hide(e:Event=null):void
		{
			rollDown();
			dispatchEvent(new Event(VIDEO_HEIGHT_DOWN));
			TweenMax.to(theCTA, .25, { delay: 0.5,  autoAlpha: 0 });
			TweenMax.to(image, 1, { delay: .75, alpha: .15 });
			TweenMax.delayedCall(1.75, hideComplete);
		}
		
		private function hideComplete():void
		{
			dispatchEvent(new Event(HIDE_COMPLETE));
		}
	}
}