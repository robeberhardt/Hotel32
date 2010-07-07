package com.thelab.hotel32.views.rooms
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.loading.display.ContentDisplay;
	import com.thelab.hotel32.RoomsMask;
	import com.thelab.hotel32.helpers.BasicBox;
	import com.thelab.hotel32.helpers.BasicTextField;
	import com.thelab.hotel32.helpers.CaretTextTag;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class RoomBox extends BasicBox
	{
		private var boxMask											: RoomsMask;
		public var mainAsset										: ContentDisplay;
		public var overAsset										: ContentDisplay;
		public var title											: String;
		private var hotspot											: Sprite;
		
		public var overState										: Sprite;
		
		private var titleTag										: CaretTextTag;
		private var titleTween										: TweenMax;
		
		private static const OVER_SPEED								: Number = .25;
		private static const OUT_SPEED								: Number = .25;
		
		public function RoomBox(name:String=null)
		{
			super(name);
		}
		
		override public function toString():String
		{
			return "[RoomBox id: " + name + ", index: " + index + ", x: " + x + ", y: " + y + "]";
		}
		
		override public function setup():void
		{
			useHandCursor = true;
			buttonMode = true;
			
			addChild(mainAsset);
			
			//			boxMask.overHolder.addChild(overAsset);
			addChild(overAsset);
			overAsset.visible = false;
			overAsset.alpha = 0;
			
			boxMask = new RoomsMask();
			boxMask.maskClip.top.scaleY = 0;
			boxMask.maskClip.bottom.scaleY = 0;
			boxMask.maskClip.left.scaleX = 0;
			boxMask.maskClip.right.scaleX = 0;
			addChild(boxMask);
			
			titleTag = new CaretTextTag(title);
			addChild(titleTag);
			titleTag.visible = false;
			titleTag.alpha = 0;
			titleTag.x = 8;
			titleTag.y = height - 36;
			
			hotspot = new Sprite();
			hotspot.graphics.beginFill(0xF0FF00, 0);
			hotspot.graphics.drawRect(0, 0, 498, 229);
			addChild(hotspot);
		
		}
		
		override public function doRolledOver(e:MouseEvent):void
		{
			TweenMax.to(boxMask.maskClip.top, OVER_SPEED, { scaleY: 1, ease:Quad.easeOut } );
			TweenMax.to(boxMask.maskClip.left, OVER_SPEED, { scaleX: 1, ease:Quad.easeOut } );
			TweenMax.to(boxMask.maskClip.right, OVER_SPEED, { scaleX: 1, ease:Quad.easeOut } );
			TweenMax.to(boxMask.maskClip.bottom, OVER_SPEED, { scaleY: 1, ease:Quad.easeOut } );
			TweenMax.to(overAsset, OVER_SPEED, { autoAlpha: 1 } );
			titleTween = TweenMax.to(titleTag, OVER_SPEED, { delay: .2, autoAlpha: 1 } );
		}
		
		override public function doRolledOut(e:MouseEvent):void
		{
			titleTween.kill();
			TweenMax.to(boxMask.maskClip.top, OUT_SPEED, { scaleY: 0, ease:Quad.easeIn } );
			TweenMax.to(boxMask.maskClip.left, OUT_SPEED, { scaleX: 0, ease:Quad.easeIn } );
			TweenMax.to(boxMask.maskClip.right, OUT_SPEED, { scaleX: 0, ease:Quad.easeIn } );
			TweenMax.to(boxMask.maskClip.bottom, OUT_SPEED, { scaleY: 0, ease:Quad.easeIn } );
			TweenMax.to(overAsset, OUT_SPEED, { autoAlpha: 0 } );
			TweenMax.to(titleTag, OUT_SPEED, { autoAlpha: 0 } );
		}
		
		public function open():void
		{
			clickedSender.dispatch(this);
		}
	}
}