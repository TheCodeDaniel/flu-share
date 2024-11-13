import Cocoa
import FlutterMacOS
import Network

@main
class AppDelegate: FlutterAppDelegate {
    
  private let channelName = "com.flushare/wifi"
  private var connection: NWConnection?
  private var listener: NWListener?
    
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
            let controller = mainFlutterWindow?.contentViewController as! FlutterViewController
            let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.engine.binaryMessenger)
            
            methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
                switch call.method {
                case "startNetworkListener":
                    self?.startNetworkListener(result: result)
                case "connectToPeer":
                    if let args = call.arguments as? [String: Any],
                       let address = args["address"] as? String,
                       let port = args["port"] as? Int {
                        self?.connectToPeer(address: address, port: port, result: result)
                    }
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    
    private func startNetworkListener(result: @escaping FlutterResult) {
           do {
               listener = try NWListener(using: .tcp, on: NWEndpoint.Port(integerLiteral: 8080))
               listener?.stateUpdateHandler = { state in
                   switch state {
                   case .ready:
                       print("Listener ready on port \(self.listener?.port?.rawValue ?? 0)")
                       result("Listener started on port \(self.listener?.port?.rawValue ?? 0)")
                   case .failed(let error):
                       print("Listener failed with error: \(error)")
                       result(FlutterError(code: "ERROR", message: "Listener failed", details: error.localizedDescription))
                   default:
                       break
                   }
               }
               listener?.newConnectionHandler = { [weak self] newConnection in
                   self?.connection = newConnection
                   newConnection.start(queue: .main)
               }
               listener?.start(queue: .main)
           } catch {
               result(FlutterError(code: "ERROR", message: "Failed to start listener", details: error.localizedDescription))
           }
       }

       private func connectToPeer(address: String, port: Int, result: @escaping FlutterResult) {
           let host = NWEndpoint.Host(address)
           let nwPort = NWEndpoint.Port(integerLiteral: UInt16(port))
           connection = NWConnection(host: host, port: nwPort, using: .tcp)
           
           connection?.stateUpdateHandler = { state in
               switch state {
               case .ready:
                   print("Connected to \(address):\(port)")
                   result("Connected to \(address):\(port)")
               case .failed(let error):
                   print("Connection failed with error: \(error)")
                   result(FlutterError(code: "ERROR", message: "Connection failed", details: error.localizedDescription))
               default:
                   break
               }
           }
           connection?.start(queue: .main)
       }
    
    
}
