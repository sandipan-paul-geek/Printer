#Requires AutoHotkey v2.0
#Include ..\Constants.ahk
#Include ..\Lib\Support.ahk

class Network {
  __New(networkId, subnetMask) {
    this.networkId := networkId
    this.subnetMask := subnetMask
  }
  class Utils {

    static isServerConnected(SMT_SERVER_IP) {
      pingCommand := "ping -n 5 -w 1000 " SMT_SERVER_IP
      Response res := ExecuteCmd(pingCommand, true)
      if (!res.success) {
        return Response(false).setMesssage("Could not determine server connection status.")
      }
      pingOutput := res.data
      successCount := 0
      for line in StrSplit(pingOutput, "`n") {
        if (InStr(line, "Reply from")) {
          successCount++
        }
      }
      if (successCount = 0) {
        return Response(false).setMesssage("No pings successful. Server is not connected.")
      } else if (successCount < 5) {
        return Response(false).setMesssage(successCount " out of 5 pings successful. Server is connected but intermittent.")
      } else {
        return Response(true).setMesssage("5 pings successful. Server is fully connected.")
      }
    }

    static IsInSmtNetwork(ipAddress) {
      systemMaskBinary := Network.Utils.IPToBinary(Network.Utils.GetSystemMask())
      ipBinary := Network.Utils.IPToBinary(ipAddress)
      for networkObj in NetworksArray {
        netBinary := Network.Utils.IPToBinary(networkObj.networkId)
        maskBinary := Network.Utils.IPToBinary(networkObj.subnetMask)
        if (ipBinary & systemMaskBinary = netBinary & maskBinary) {
          return Response(true).setMesssage("In SMT Network")
        }
      }
      return Response(false).setMesssage("Not in SMT Network")
    }

    static GetIPv4Address() {
      Response res := ExecuteCmd("ipconfig", true)
      if (!res.success) {
        return Response(false).setMesssage("Could not determine IP address")
      }
      output := res.data
      for line in StrSplit(output, "`n") {
        if (InStr(line, "IPv4 Address") or InStr(line, "IP Address")) {
          parts := StrSplit(line, ":")
          if (parts.Length == 2) {
            return Response(true).setData(Trim(parts[2])).setMesssage("IPv4 address found: " parts[2])
          }
        }
      }
      return Response(false).setMesssage("No IPv4 address found")
    }

    static IPToBinary(ip) {
      segments := StrSplit(ip, ".")
      if (segments.Length != 4) {
        throw Error("Invalid IP address format")
      }
      part4 := Trim(segments[4], "`r")
      result := (0 + segments[1]) << 24 | (0 + segments[2]) << 16 | (0 + segments[3]) << 8 | part4 + 0
      return result
    }


    static GetSystemMask() {
      Response res := ExecuteCmd("ipconfig", true)
      if (!res.success) {
        return ""
      }
      output := res.data
      for line in StrSplit(output, "`n") {
        if (InStr(line, "Subnet Mask")) {
          parts := StrSplit(line, ":")
          if (parts.Length > 1) {
            return Trim(parts[2])
          }
        }
      }
      return ""
    }
  }
}