

@objc(coolMethod) class coolMethod : CDVPlugin {
    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )
        
        let msg = command.arguments[0] as? String ?? ""
        
        if msg.characters.count > 0 {
            
            let screenSaverVC = ScreenSaverController()
            screenSaverVC.modalTransitionStyle = UIModalTransitionStyle.partialCurl
            self.viewController?.present(screenSaverVC, animated: true, completion: nil)
            
            
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: msg
            )
        }
        
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
}
