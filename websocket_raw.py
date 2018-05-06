from mitmproxy import ctx
import mitmproxy.websocket

class RawLogger:
    def __init__(self):
        self.of = open("messages.log", "wb", 0)
        ctx.log.warn("[+] Websocket Capture")
        self.num = 0

    def websocket_message(self, flow: mitmproxy.websocket.WebSocketFlow):
        self.of.write(flow.messages[-1].content)
        self.of.write('\n-----------------------------\n'.encode('ascii'))

addons = [
    RawLogger()
]
