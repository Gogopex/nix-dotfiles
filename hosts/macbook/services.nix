{ ... }:
{
  # Disabled problematic USB/display services that interfere with Thunderbolt/USB-C
  # These services were causing conflicts with macOS's native USB and display management
  # by continuously polling and manipulating system services

  # system.activationScripts.usbservices.text = ''
  #   echo "Ensuring USB services are running..."
  #   launchctl bootout gui/$(id -u) /System/Library/LaunchAgents/com.apple.USBAgent.plist 2>/dev/null || true
  #   launchctl bootstrap gui/$(id -u) /System/Library/LaunchAgents/com.apple.USBAgent.plist 2>/dev/null || true
  # '';

  # launchd.user.agents = {
  #   displaydetection = {
  #     serviceConfig = {
  #       ProgramArguments = [ "/usr/bin/killall" "-USR1" "Dock" ];
  #       RunAtLoad = true;
  #       WatchPaths = [ "/System/Library/Displays" ];
  #     };
  #   };
  #
  #   displayprobe = {
  #     serviceConfig = {
  #       ProgramArguments = [ "/bin/sh" "-c" "system_profiler SPDisplaysDataType > /dev/null 2>&1" ];
  #       RunAtLoad = true;
  #       StartInterval = 30;
  #     };
  #   };
  #
  #   usbmonitor = {
  #     serviceConfig = {
  #       ProgramArguments = [ "/usr/bin/killall" "-USR1" "SystemUIServer" ];
  #       RunAtLoad = true;
  #       WatchPaths = [ "/dev" ];
  #     };
  #   };
  # };
}
