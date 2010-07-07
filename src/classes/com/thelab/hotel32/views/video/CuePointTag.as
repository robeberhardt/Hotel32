package com.thelab.hotel32.views.video
{
	import com.greensock.TweenMax;
	import com.greensock.loading.SWFLoader;
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	import com.thelab.hotel32.helpers.BasicKnockoutTextField;
	import com.thelab.hotel32.helpers.BasicTextField;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CuePointTag extends MovieClip
	{
		private var swfLoader								: SWFLoader;
		private var tempClass								: Class;
		private var _asset									: MovieClip;
		private var label									: TextField;
		private var _labelText								: String;
		private var caret									: MovieClip;
		
		private var labelField								: TextField;
		private var labelFormat								: TextFormat;
		private var labelWidth								: Number;
		
		private var _currentCuePoint						: CuePoint;
		
//		public var dotOffset								: Point;
		
		public var currentCuePointIndex						: int;
		
		public var showing									: Boolean = false;
		private var _automatic								: Boolean = true;
		
		public static const CUEPOINT_TAG_CLICKED			: String = "CUEPOINT_TAG_CLICKED";
		public static const CUEPOINT_TAG_ROLLOVER			: String = "CUEPOINT_TAG_ROLLOVER";
		public static const CUEPOINT_TAG_ROLLOUT			: String = "CUEPOINT_TAG_ROLLOUT";
		
		public function CuePointTag(loader:SWFLoader)
		{
			swfLoader = loader;
			visible = false;
			alpha = 0;
			
			tempClass = swfLoader.getClass("com.thelab.hotel32.video.cptag");
			_asset = new tempClass() as MovieClip;
			trace("_asset = " + _asset + ", label = " + _asset.label);
			addChild(_asset);
			_asset.mouseChildren = false;
			
			labelFormat = FontLibrary.getInstance().getFormat(FontLibrary.FUTURA_MEDIUM_FORMAT);
			labelFormat.letterSpacing = 2;
			labelFormat.size = 14;
			labelFormat.color = 0xFFFFFF;
			labelFormat.align = TextFormatAlign.CENTER;
			
			labelField = new TextField();
			labelField.antiAliasType = AntiAliasType.ADVANCED;
			labelField.autoSize = TextFieldAutoSize.CENTER;
			labelField.embedFonts = true;
			labelField.defaultTextFormat = labelFormat;
			labelField.selectable = false;
			labelField.x = -9;
			labelField.y = -35;
			addChild(labelField);
			
			caret  = swfLoader.getSWFChild("caret") as MovieClip;
			addChild(caret);
//			caret.scaleX = caret.scaleY = 1.2;
			caret.y = -25;
			
//			label = _asset.label;
//			label.embedFonts = false;
//			label.autoSize = TextFieldAutoSize.CENTER;
//			
//			labelFormat = _asset.label.getTextFormat();
//			labelFormat.letterSpacing = 4;
//			trace(" labelFormat = " + labelFormat);
			
			mouseChildren = false;
			useHandCursor = true;
			addEventListener(MouseEvent.ROLL_OVER, onTagRollOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onTagRollOut, false, 0, true);
//			
//			dotOffset = new Point(Math.round(_asset.dot.x), Math.round(_asset.dot.y));
			
//			onelinefield = new BasicTextField();
//			twolinefield = new BasicKnockoutTextField();
//			visitfield = new BasicKnockoutTextField("VISIT");
			
//			onelinefield.visible = false;
//			
//			_asset.addChild(onelinefield);
//			_asset.addChild(twolinefield);
//			_asset.addChild(visitfield);
//			
//			onelinefield.x = 18;
//			onelinefield.y = 22;
//			_asset.onelinelabel.visible = false;
//			
//			twolinefield.x = 18;
//			twolinefield.y = 17;
//			_asset.twolinelabel.visible = false;
//			
//			visitfield.x = 142;
//			visitfield.y = 35;
//			_asset.visit.visible = false;
			
		}
		
		private function onTagRollOver(e:MouseEvent):void
		{
			dispatchEvent(new Event(CUEPOINT_TAG_ROLLOVER));
		}
		
		private function onTagRollOut(e:MouseEvent):void
		{
			dispatchEvent(new Event(CUEPOINT_TAG_ROLLOUT));
		}
		
		public function reset():void
		{
//			trace("TAG RESET");
			showing = false;
			hide(.15);
		}
		
		private function hideFast():void
		{
			TweenMax.to(this, .25, { autoAlpha: 0 });
		}
		
		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new Event(CUEPOINT_TAG_CLICKED));
		}
		
		public function show():void
		{
			if (!showing)
			{
				TweenMax.to(this, .5, { autoAlpha: 1 });
				showing = true;
				useHandCursor = true;
				buttonMode = true;
				addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				_currentCuePoint.forceGrow()
			}
		}
		
		public function hide(speed:Number=0.5):void
		{
			if (showing)
			{
//				trace("     ==> HIDING TAG");
				TweenMax.to(this, speed, { autoAlpha: 0 });
				showing = false;
				useHandCursor = false;
				buttonMode = false;
				mouseChildren = false;
				removeEventListener(MouseEvent.CLICK, onClick);
				_currentCuePoint.forceShrink()
			}
		}
		
		public function hideAfterDelay(d:Number):void
		{
//			trace("HIDE AFTER DELAY!");
			showing = true;
			TweenMax.delayedCall(d, hide);
		}
		
		public function set labeltext(val:String):void
		{
//			_labelText = val;
			labelField.text = val;
			trace(labelField.width);
			_asset.fill.scaleX = (labelField.width + 14) * .02;
			labelField.x = -Math.round((labelField.width * .5)) - 5;
			caret.x = Math.round(labelField.width * .5) + 1;
//			_asset.label.text = val;
//			_asset.label.setTextFormat(labelFormat);
//			trace("label text set to " + _labelText);
		}

		public function get currentCuePoint():CuePoint
		{
			return _currentCuePoint;
		}

		public function set currentCuePoint(value:CuePoint):void
		{
			_currentCuePoint = value;
		}

		public function get automatic():Boolean
		{
			return _automatic;
		}

		public function set automatic(value:Boolean):void
		{
			_automatic = value;
		}
	}
}