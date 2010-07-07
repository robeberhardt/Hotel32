package com.thelab.hotel32.slideshow
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.thelab.hotel32.assets.AssetLoader;
	import com.thelab.hotel32.helpers.BasicKnockoutTextField;
	import com.thelab.hotel32.helpers.GradientBox;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SlideShowController extends Sprite
	{		
		private var assetPath							: String;
		private var slideWidth							: int;
		private var slideHeight							: int;
		private var slidesArray							: Array;
		private var slideLoadCounter					: int;
		private var currentSlideCounter					: int;
		private var showStarted							: Boolean = false;
		private var currentSlideID						: String;		
		private var theNextSlide						: String;
		private var slidesXML							: XMLList;
		public var timing								: XMLList;
		private var dimmer								: Sprite;
		private var topGradient							: GradientBox;
		
		private var slideX								: Number;
		
//		private static const SLIDESHOW_WIDTH			: Number = 1400;
//		private static const SLIDESHOW_HEIGHT			: Number = 540;
		
		public function SlideShowController(data:XML) 
		{
			slidesXML = data..hero;
			slideWidth = int(data..hero.@width);
			slideHeight = int(data..hero.@height);
			timing = AssetLoader.getInstance().mainXML..slideshow.timing;
			assetPath = AssetLoader.getInstance().basePath;
			if (assetPath.lastIndexOf("/") == -1) { assetPath += "/"; }
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event = null) : void 
		{	
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			onStageResize();
			
			slideX = Math.abs((AssetLoader.PUBLISH_WIDTH - slideWidth)*.5);
			if (slideWidth > AssetLoader.PUBLISH_WIDTH)
			{
				slideX = -slideX;
			}
			
			slidesArray = new Array();
			for (var i:int = 0; i < slidesXML..slide.length(); i++)
			{
				var theAsset:String = slidesXML..slide[i].@asset.toString();
				var theSlide:Slide = new Slide(this, theAsset, i, slideWidth);
				addChild(theSlide);
				theSlide.x = slideX;
				theSlide.addEventListener(Slide.SLIDE_FADEIN_COMPLETE, onSlideComplete, false, 0, true);
				slidesArray.push(theSlide);
			}
			
			var firstSlide:Slide = slidesArray[0] as Slide;
			firstSlide.addEventListener(Slide.SLIDE_LOADED, onFirstSlideLoaded);
			firstSlide.load();
			
			makeVignettes();
						
			dimmer = new Sprite();
			dimmer.graphics.beginFill(0x000000, 1);
			dimmer.graphics.drawRect(0, 0, slideWidth, slideHeight);
			addChild(dimmer);
			dimmer.alpha = 0;
			dimmer.x = slideX;
			
		}
		
		private function makeVignettes():void
		{
			var vignetteHolder : Sprite = new Sprite();
			addChild(vignetteHolder);
			vignetteHolder.x = slideX;
			
			if (slidesXML..@topVig == "true")
			{
				var colorOne:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.colorOne);
				var colorTwo:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.colorTwo);
				var alphaOne:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.alphaOne);
				var alphaTwo:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.alphaTwo);
				var mp:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.midpoint);
				var r:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.rotation);
				var gradHeight:Number = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.top.height);
				var topVignette:GradientBox = new GradientBox(slideWidth, gradHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
				vignetteHolder.addChild(topVignette);
			}
			
			if (slidesXML..@bottomVig == "true")
			{
				colorOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.colorOne);
				colorTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.colorTwo);
				alphaOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.alphaOne);
				alphaTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.alphaTwo);
				mp = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.midpoint);
				r = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.rotation);
				gradHeight = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.bottom.height);
				var botVignette:GradientBox = new GradientBox(slideWidth, gradHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
				vignetteHolder.addChild(botVignette);
				botVignette.y = slideHeight - gradHeight;
			}
			
			if (slidesXML..@leftVig == "true")
			{
				colorOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.colorOne);
				colorTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.colorTwo);
				alphaOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.alphaOne);
				alphaTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.alphaTwo);
				mp = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.midpoint);
				r = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.rotation);
				gradHeight = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.left.height);
				var leftVignette:GradientBox = new GradientBox(gradHeight, slideHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
				vignetteHolder.addChild(leftVignette);				
			}
			
			if (slidesXML..@rightVig == "true")
			{
				colorOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.colorOne);
				colorTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.colorTwo);
				alphaOne = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.alphaOne);
				alphaTwo = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.alphaTwo);
				mp = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.midpoint);
				r = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.rotation);
				gradHeight = Number(AssetLoader.getInstance().mainXML..slideshow.vignettes.right.height);
				var rightVignette:GradientBox = new GradientBox(gradHeight, slideHeight, r, colorOne, colorTwo, alphaOne, alphaTwo, mp);
				vignetteHolder.addChild(rightVignette);
				rightVignette.x = slideWidth - gradHeight;
			}
			
		}
		
		private function onFirstSlideLoaded(e:Event):void
		{
			e.target.removeEventListener(Slide.SLIDE_LOADED, onFirstSlideLoaded);
			e.target.addEventListener(Slide.SLIDE_FADEIN_COMPLETE, onSlideComplete, false, 0, true);
			e.target.addEventListener(Slide.SLIDE_FADEOUT_COMPLETE, onSlideFadeOutComplete, false, 0, true);
			e.target.show();
			currentSlideCounter = 0;
			
			for (var i:int=1; i < slidesArray.length; i++)
			{
				slidesArray[i].addEventListener(Slide.SLIDE_LOADED, onNextSlideLoaded, false, 0, true);
				slidesArray[i].load();
			}
		}
		
		private function onNextSlideLoaded(e:Event):void
		{
			e.target.removeEventListener(Slide.SLIDE_LOADED, onNextSlideLoaded);
			
			e.target.addEventListener(Slide.SLIDE_FADEIN_COMPLETE, onSlideComplete, false, 0, true);
			e.target.addEventListener(Slide.SLIDE_FADEOUT_COMPLETE, onSlideFadeOutComplete, false, 0, true);
		}
		
		private function onSlideComplete(e:Event):void
		{
			if (slidesArray.length > 1)
			{
				e.target.hide();
			}
		}
		
		private function onSlideFadeOutComplete(e:Event):void
		{
			
			currentSlideCounter ++;
			if (currentSlideCounter == slidesArray.length)
			{
				currentSlideCounter = 0;
			}
			slidesArray[currentSlideCounter].show();
		}
				
		private function onStageResize(e:Event=null):void
		{
			if (stage.stageWidth < AssetLoader.PUBLISH_WIDTH)
			{
				x = Math.round((AssetLoader.PUBLISH_WIDTH-stage.stageWidth)*.5);
			}
			else
			{
				x = 0;
			}
		}
		
		public function dim():void
		{
			TweenMax.to(dimmer, .5, { alpha: .8 });
		}
		
		public function undim():void
		{
			TweenMax.to(dimmer, .5, { alpha: 0 });
		}
	}
}