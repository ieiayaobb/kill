package com.caller.ICall
{
	public interface ICallBack
	{
		function addCallback(type:String,func:Function):void;
		function removeCallback(type:String,func:Function):void;
		function dispatch(type:String,data:Object=null):void;
	}
}