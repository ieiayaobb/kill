package com.net.core 
{
	import com.caller.call.CallBack;
	import com.netease.protobuf.Message;
	import com.net.util.MsgUtil;
	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class NetEngine extends EventDispatcher
	{
		private var netSocket:NetSocket = null;
		private var callBack:CallBack;
		
		private var baseMsg:Person;
		
		public function NetEngine() : void
		{
			callBack=new CallBack;
			baseMsg=new Person;
		}
		
		public function connect(server:String, port:int) : void
		{
			this.netSocket = new NetSocket(server, port);
			this.netSocket.addEventListener(NetEvent.ON_PACKET, this.onPacket);
			this.netSocket.addEventListener(NetEvent.ON_CONNECT, this.onConnect);
			this.netSocket.addEventListener(NetEvent.ON_DISCONNECT, this.onDisconnect);
			return;
		}
		
		public function close() : void
		{
			if (this.netSocket && this.netSocket.socket && this.netSocket.socket.connected)
			{
				this.netSocket.socket.close();
			}
			return;
		}
		
		public function call(message:Message) : void
		{
			this.netSocket.send_to_net(message);
			return;
		}
		
		/**
		 *   发送基本数据
		 * */
		public function callBaseMsg(funcName:String,arr:Array) : void
		{
			baseMsg.func=funcName;
			baseMsg.param=arr;
			this.netSocket.send_to_net(baseMsg);
			return;
		}
		
		private function onConnect(event:NetEvent) : void
		{
			dispatchEvent(new NetEvent(NetEvent.ON_CONNECT));
			return;
		}
		
		private function onDisconnect(event:NetEvent) : void
		{
			dispatchEvent(event);
			return;
		}
		
		private function onPacket(event:NetEvent) : void
		{	
			callBack.dispatch(event.funcName,event.byte);
			return;
		}
		
		public function addCallback(type:String, func:Function):void{
			callBack.addCallback(type,func);
		}
	}
	
}
