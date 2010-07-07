package com.thelab.hotel32.views.video
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	import com.thelab.hotel32.helpers.BasicKnockoutTextField;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class VideoCTAButton extends MovieClip
	{
		private var bg										: Sprite;
		private var frame									: Sprite;
		private var hit										: Sprite;
		
		private var caret									: MovieClip;
		
		private var labelField								: TextField;
		private var labelFormat								: TextFormat;
		private var labelWidth								: Number;
		
		public static const VIDEO_CTA_CLICKED				: String = "VIDEO_CTA_CLICKED";
		
		public function VideoCTAButton(caretAsset:MovieClip)
		{
			caret = caretAsset;
			
			addEventListener(MouseEvent.ROLL_OVER, doRollOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, doRollOut, false, 0, true);
			addEventListener(MouseEvent.CLICK, doClick, false, 0, true);
			useHandCursor = true;
			buttonMode = true;
			
			labelFormat = FontLibrary.getInstance().getFormat(FontLibrary.FUTURA_MEDIUM_FORMAT);
			labelFormat.letterSpacing = 2;
			labelFormat.size = 14;
			labelFormat.color = 0xFFFFFF;
			labelFormat.align = TextFormatAlign.CENTER;
			
			labelField = new TextField();
			labelField.antiAliasType = AntiAliasType.ADVANCED;
			labelField.autoSize = TextFieldAutoSize.LEFT;
			labelField.embedFonts = true;
			labelField.defaultTextFormat = labelFormat;
			labelField.selectable = false;
			labelField.y = 24;
			
			bg = new Sprite();
			bg.alpha = 0.7;
			addChild(bg);
			
			frame = new Sprite();
			frame.x = 9;
			frame.y = 9;
			addChild(frame);
			
			addChild(labelField);
			
			caret.y = 32;
			addChild(caret);
			
			hit = new Sprite();
			hit.alpha = 0;
			addChild(hit);
		}
		
		public function setup(s:String):void
		{
			labelField.text = s.toUpperCase();
			labelWidth = labelField.width + 18;
			
			frame.graphics.clear();
			frame.graphics.lineStyle(1, 0x98774E, 1, true);
			frame.graphics.drawRect(0, 0, labelWidth + 20, 44);		
			
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000, 1);
			bg.graphics.drawRect(0, 0, frame.width + 18, 64);
			
			hit.graphics.clear();
			hit.graphics.beginFill(0x00FF00, 1);
			hit.graphics.drawRect(0, 0, bg.width, bg.height);
			
			labelField.x = Math.round((bg.width - labelWidth) * .5);
			caret.x = labelField.x + labelWidth - 14;
			
		}
		
		override public function toString():String
		{
			return "[VideoCTAButton -- width: " + labelWidth + " ]";
		}
		
		private function doRollOver(e:MouseEvent):void
		{
			TweenMax.to(bg, .25, { alpha: 0.9 });
		}
		
		private function doRollOut(e:MouseEvent):void
		{
			TweenMax.to(bg, .25, { alpha: 0.7 });
		}
		
		private function doClick(e:MouseEvent):void
		{
			dispatchEvent(new Event(VIDEO_CTA_CLICKED, true));
		}
			
	}
}